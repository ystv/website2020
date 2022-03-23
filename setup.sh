verbose=''
force=''
rootdir="$(pwd)"
# Manaully set variables
host=''
port='5432'
db=''
user=''
# Automated variables
pgpass_file=''
# Method variables
method=''
method_file=''


get_help() { printf "
Usage...
 NO ARGS		Set up the database

 export [..]		Export to a file
 export-data [..]	Export (data only) to a file
 import [..]		Import from a file
 migrate [..]		Migrate old database from a file

 -H --host		Set the database host
 -P --port		Set the database port
 -D --database		Set the name of the database
 -U --user		Set the database user

 -c --config [..]	Use a pgpass config file
 -f --force		Force any file rewrites or conflicts

 -v --verbose		Verbose
 -h --help		Show this help screen
"; }


declare -A messages=( \
	["NAarg"]="Argument not valid" \
	["NAmethod"]="Method not valid" \
	["0xmethod"]="Method has not been set - default to 'setup'" \
	["2xmethod"]="Method has been set twice" \
	["NAfile"]="Method file not valid" \
	["0xfile"]="Method file has not been set (or invalid method)" \
	["EXfile"]="Method file does not exist" \
	["RWfile"]="Method file already exists! Risking rewrite of data" \
	["0xconfig"]="DB values have not been set" \
	["2xconfig"]="DB values have been set twice - default to config file" \
	["EXconfig"]="Config file does not exist" \
	["TMPconfig"]="Temporary config file already exists" \
	["ERpasswd"]="Password failed to generate" \
	["PSQLfail"]="PSQL command failed" \
)
error() {
	echo "ERROR: ${messages[$1]} [$2]" >&2 ;}
warn() {
	[[ -n "$verbose" ]] && echo "WARNING: ${messages[$1]} [$2]" >&2; }
log() {
	[[ -n "$verbose" ]] && echo "INFO: $1" >&2; }


while [[ $# -gt 0 ]]; do
	case "$1" in
	 -v|--verbose) verbose='true' ;;
	 -h|--help) get_help; exit 0 ;;
	 -f|--force) force="true" ;;
	 *)
		# Check arguments have a valid 2nd term
		case "$2" in
		 -*|--*) error "NAfile" "$2"; exit 1 ;;
		 '') error "0xfile" "$1"; exit 1 ;;
		esac

		# Deal with items that have a 2nd term - shift twice
		case "$1" in
		 -H|--host) host="$2" ;;
	 	 -P|--port) port="$2" ;;
	 	 -D|--database) db="$2" ;;
	 	 -U|--user) user="$2" ;;

		 -c|--config) pgpass_file="$2" ;;
		 -*|--*) error "NAarg" "$1"; exit 1 ;;
		 *)
			# Check if method has not already been set
			[[ -z "$method" ]] || { error "2xmethod" "$1"; exit 1; }
			method="$1"; method_file="$2"
			;;
	 	esac; shift;;
	esac; shift
done


[[ -n "$verbose" ]] && log "Verbose enabled..."
[[ -n "$force" ]] && log "Force enabled..."
log "Applying [$method] on [$method_file]"

# Check for conflicts in the config options
## Doesn't check values that have defaults
if [[ -n "$pgpass_file" ]]; then
	log "Config file [$pgpass_file] given"
	[[ -z "$host$db$user" ]] || warn "2xconfig" "$pgpass_file"
	[[ -f "$pgpass_file" ]] || { error "EXconfig" "$pgpass_file"; exit 1; }

# If no config file is given, are there config variables?
## Doesn't check values that have defaults
elif [[ -z "$host" || -z "$db" || -z "$user" ]]; then
	error "0xconfig" "$host:$port:$db:$user"; exit 1;

else
	pgpass_file=".pgpass.temp"
	[[ -f "$pgpass_file" ]] && warn "TMPconfig" "$pgpass_file" 
	log "Saving [$host:$port:$db:$user] to [$pgpass_file]"

	echo "$host:$port:$db:$user" > "$pgpass_file"
	chmod 600 "$pgpass_file"
fi


PGPASSFILE="$rootdir/$pgpass_file"
[[ -f "$PGPASSFILE" ]] || { error "EXconfig" "$PGPASSFILE"; exit 1; }
log "Using [$PGPASSFILE] with contents [$(cat $PGPASSFILE)]"


gen_passwd() { openssl rand -base64 32; }
# Test if passwords can be generated
pass="$(gen_passwd)"
[[ -n "$pass" ]] || { error "ERpasswd" "$pass"; exit 1; }

trap ctrl_c 1

function ctrl_c() {
    echo 
    echo "Ctrl-C by user"
    exit
}

case "$method" in
 export|export-data)
	log "Dumping data ($method) to [$method_file]"

	# Test if file already exists
	if [[ -f "$method_file" ]]; then
		if [[ -n "$force" ]]
			then error "RWfile" "$method_file"; exit 1;
			else warn "RWfile" "$method_file"
		fi
	else
		log "Writing to a new file: [$method_file]"
	fi


	# EXPORT DATA
	## Open database and output to a file
	## Do different things based on [export] or [export-data]
	
	# Export the users and roles
	## We're excluding the password values as then the
	## running user doesn't need to be "Superuser". This
	## does mean the user will need to regen the passwords
	case "$method" in
	 export)
		pg_dump \
			-h $host \
			-U $user \
			-p $port \
			-d $db \
			--format=custom \
			--no-privileges \
			--no-owner \
		 > "$method_file" \
		 || { error "PSQLfail" "pg_dump"; exit 1; }
		;;
	 export-data)
		pg_dump \
			-h $host \
			-U $user \
			-p $port \
			-d $db \
			--format=custom \
			--no-privileges \
			--no-owner \
			--data-only \
		 > "$method_file" \
		 || { error "PSQLfail" "pg_dump"; exit 1; }
		;;
	esac ;;

 import)
	log "Importing database from [$method_file]"

	# Test if file exists
	[[ -f "$method_file" ]] || { error "EXfile" "$method_file"; exit 1; }

	# Import into database
	pg_restore \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		--format=custom \
		--no-privileges \
		--no-owner \
	"$method_file" || { error "PSQLfail" "import"; exit 1; }
	;;

 migrate)
	log "Migrating data from [$method_file]"

	# Test if file exists
	[[ -f "$method_file" ]] || { error "EXfile" "$method_file"; exit 1; }

	# Set user/role names
	owner_user="${db}_owner"
	owner_passwd="$(gen_passwd)"
	webapi_user="${db}_wapi"
	webapi_passwd="$(gen_passwd)"

	# Initialise database
	pushd db-init
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-p $port \
		-d postgres \
		-v db_name=$db \
		-v owner_password=$owner_passwd \
		-v wapi_password=$webapi_passwd \
	 	|| { error "PSQLfail" "migrate db-init"; exit 1; }
	popd

	# Create tables
	pushd schema-structure
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		-v owner_user=$owner_user \
		|| { error "PSQLfail" "migrate schema-structure"; exit 1; }
	popd

	# Import migration data (export output)
	pg_restore \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		--format=custom \
		--no-privileges \
		--no-owner \
	"$method_file" || { error "PSQLfail" "migrate import"; exit 1; }

	# Migration
	pushd schema-migrate/pre2020

	# Run pre-migration actions
	pushd pre-actions
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		|| { error "PSQLfail" "migrate schema-migrate"; exit 1; }
	popd

	# Migrate from old to new
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		|| { error "PSQLfail" "migrate schema-migrate"; exit 1; }

	# Run post-migration actions
	pushd post-actions
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-p $port \
		-d $db \
		|| { error "PSQLfail" "migrate schema-data"; exit 1; }
	popd

	popd

	# Output the passwords to the user
	echo -e "CREDENTIALS"
	echo -e "owner:\nusername: $owner_user\npassword: $owner_passwd"
	echo -e "wapi:\nusername: $webapi_user\npassword: $webapi_passwd"
	;;

 '')
	warn "0xmethod" "$method"
	# SETUP
	## Run the database schema setup
	## Run the database data setup
	## Run the tests

	# Set user/role names
	owner_user="${db}_owner"
	owner_passwd="$(gen_passwd)"
	webapi_user="${db}_wapi"
	webapi_passwd="$(gen_passwd)"

	# Initialise database
	pushd db-init
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-v db_name=$db \
		-v owner_password=$owner_passwd \
		-v wapi_password=$webapi_passwd \
	 	|| { error "PSQLfail" "migrate db-init"; exit 1; }
	popd

	# Create tables
	pushd schema-structure
	psql -f "_meta.sql" \
		-h $host \
		-U $user \
		-d $db \
		-v owner_user=$owner_user \
		|| { error "PSQLfail" "migrate schema-structure"; exit 1; }
	popd

	# Output the passwords to the user
	echo -e "CREDENTIALS"
	echo -e "owner:\nusername: $owner_user\npassword: $owner_passwd"
	echo -e "wapi:\nusername: $webapi_user\npassword: $webapi_passwd"
	;;

 *) error "NAmethod" "$method"; exit 1 ;;
esac
