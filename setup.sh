# Variables
verbose=0 # 0=err+warn 1=log
force=''
# Config variables
host=''
port='5432'
dbname=''
dbuser=''
dbpass=''
askpass=''
# Method variables
method=''
method_file=''

declare -A messages=( \
	["INVconfig"]="Config arguments not fully set" \
	["INVfile"]="File argument not valid" \
	["INVarg"]="Argument not valid" \
	["0Xfile"]="No file argument given" \
	["2Xvar"]="Variable declared twice" \
	["2Xpass"]="Password to be declared twice - default to [-P]" \
	["RWfile"]="File already exists - risking rewriting data" \
	["PSQL"]="PSQL exited with an error" \
)
error() {
	echo "ERROR: ${messages[$1]} [$2]" >&2; exit 1; }
warn() {
	echo "WARN: ${messages[$1]} [$2]" >&2; }
log() { [[ "$verbose" -ge 1 ]] && \
	echo "LOG: ${messages[$1]}" >&2; }

getHelp() { printf "Usage...
 setup			Set up the database
 export [..]		Export database to a file
 import [..]		Import from a file
 backup [..]		Export data to a file
 migrate [..]		Migrate old database from a file

 -H --host		Set the database host
 -p --port		Set the database port
 -d --database		Set the database name
 -U --username		Set the database username
 -P --password		Set the database password

 -f --force		Force any file rewrites/conflicts
 -a --askpass		Query for the password

 -v --verbose		Verbose mode
 -h --help		Show this help screen
"; exit 0; }


setVerbose() { [[ "$verbose" -lt "$1" ]] && verbose="$1"; }
testVar() {
	# Test if a variable has already been set
	[[ -n $1 ]] && error "2Xvar" "$1"
}
genPassword() { echo "$(pwmake 128)$(pwmake 128)"; }


while [[ $# -gt 0 ]]; do
	case "$1" in
	 -v|--verbose) setVerbose 1 ;;
	 -V|--debug) setVerbose 2 ;;
	 -f|--force) force='true' ;;
	 -a|--ask-pass) askpass='true' ;;
	 -h|--help) getHelp ;;

	 setup) testVar "$method"; method="$1" ;;
	 *)
		case "$2" in
		 -*|--*) error "INVfile" "$2" ;;
		 '') error "0Xfile" "$1" ;;
		esac
		case "$1" in
		 -H|--host) testVar "$host"; host="$2" ;;
		 -p|--port) testVar "$port"; port="$2" ;;
		 -d|--database) testVar "$dbname"; dbname="$2" ;;
		 -U|--username) testVar "$dbuser"; dbuser="$2" ;;
		 -P|--password) testVar "$dbpass"; dbpass="$2" ;;
		
		 -*|--*) error "INVarg" "$1" ;;
		 *) testVar "$method"; method="$1"; method_file="$2" ;;
		esac; shift ;;
	esac; shift
done


[[ -n "$verbose" ]] && log "Verbose enabled..."
[[ -n "$force" ]] && log "Force mode enabled..."


if [[ -n "$askpass" ]]; then
	if [[ -n "$dbpass" ]]; then warn "2Xpass"
	else read -s -p "Password: " dbpass
	fi
fi


[[ -z "$method" ]] && getHelp


config="$host:$port:$dbname:$dbuser"
[[ -z "$host" || -z "$port" || -z "$dbname" ||  -z "$dbuser" ]] &&\
	error "INVconfig" "$config"


dbInfo="-h $host -U $dbuser -p $port"
owner_user="${dbname}_owner"; owner_password="$(genPassword)"
wapi_user="${dbname}_wapi"; wapi_password="$(genPassword)"
wauth_user="${dbname}_wauth"; wauth_password="$(genPassword)"

credentials="CREDENTIALS
owner:
 username: $owner_user
 password: $owner_password
wapi:
 username: $wapi_user
 password: $wapi_password
wauth:
 username: $wauth_user
 password: $wauth_password
"

case "$method" in
 setup)
	# Database setup
	pushd db-init
	 PGPASSWORD="$dbpass" psql $dbInfo -d postgres \
		-v db_name=$dbname \
		-v owner_password="$owner_password" \
		-v wapi_password="$wapi_password" \
		-v wauth_password="$wauth_password" \
		-f "_meta.sql" || error "PSQL" "setup db-init"
	popd

	pushd schema-structure
	 PGPASSWORD="$dbpass" psql $dbInfo -d $dbname \
		-v owner_user=$owner_user \
		-f "_meta.sql" || error "PSQL" "setup schema-structure"
	popd

	echo "$credentials"
;;

 export)
	# Export everything
	if [[ -f "$method_file" ]]; then
		if [[ -n "$force" ]]
			then error "RWfile" "$method_file"
			else warn "RWfile" "$method_file"
		fi
	else log "Writing to a new file: [$method_file]"
	fi

	PGPASSWORD="$dbpass" pg_dump $dbInfo -d $dbname \
		--format=custom \
		--no-privileges \
		--no-owner \
		>> "$method_file" || error "PSQL" "export dump"
	;;

 import)
	# Import from a file
	[[ -f "$method_file" ]] || error "NOfile" "$method_file"

	PGPASSWORD="$dbpass" pg_restore $dbInfo -d $dbname \
		--format=custom \
		--no-privileges \
		--no-owner \
		"$method_file" || error "PSQL" "import"
 	;;

 backup)
	# Export data
	if [[ -f "$method_file" ]]; then
		if [[ -n "$force" ]]
			then error "RWfile" "$method_file"
			else warn "RWfile" "$method_file"
		fi
	else log "Writing to a new file: [$method_file]"
	fi

	PGPASSWORD="$dbpass" pg_dump $dbInfo \
		--format=custom \
		--no-privileges \
		--no-owner \
		--data-only \
		>> "$method_file" || error "PSQL" "export dump"
	;;

 migrate)
	# Migrate old database schema
	[[ -f "$method_file" ]] || error "NOfile" "$method_file"

	# Replace existing pre-2020 data if it exists.
	PGPASSWORD="$dbpass" pg_restore $dbInfo -d $dbname \
		--format=custom \
		--no-privileges \
		--no-owner \
		--clean \
		--if-exists \
		"$method_file" || error "PSQL" "migrate"

	# Truncate all website2020 tables.
	pushd management-scripts
	PGPASSWORD="$dbpass" psql $dbInfo -d $dbname \
	-f "clean.sql" || error "PSQL" "clean"
	popd

	# Run migration scripts.
	pushd schema-migrate/pre2020
	 pushd pre-actions
	 PGPASSWORD="$dbpass" psql $dbInfo -d $dbname \
		-f "_meta.sql" || error "PSQL" "migrate pre-actions"
	 popd
	 PGPASSWORD="$dbpass" psql $dbInfo -d $dbname \
		-f "_meta.sql" || error "PSQL" "migrate old-->new"
	 popd
	 pushd post-actions
	 PGPASSWORD="$dbpass" psql $dbInfo -d $dbname \
		-f "_meta.sql" || error "PSQL" "migrate post-actions"
	 popd
	popd
;;

 *) getHelp
esac
