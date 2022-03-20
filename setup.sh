verbose=''
force=''
# Manaully set variables
host=''
port=''
db=''
user=''
# Automated variables
psql_file=''
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

 -c --config [..]	Use a psql config file
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

		 -c|--config) psql_file="$2" ;;
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


# Check for conflicts in the config options
if [[ -n "$psql_file" ]]; then
	log "Config file [$psql_file] given"
	[[ -z "$host$port$db$user" ]] || warn "2xconfig"
	[[ -f "$psql_file" ]] || { error "EXconfig" "$psql_file"; exit 1; }

# If no config file is given, are there config variables?
elif [[ -z "$host" || -z "$port" || -z "$db" || -z "$user" ]]; then
	error "0xconfig" "$host:$port:$db:$user"; exit 1;

else
	log "Config variables [$host:$port:$db:$user] given"
fi


case "$method" in
 export|export-data)
	log "Dumping data ($method) to [$method_file]"

	# Test if file already exists (risking writing over a file)
	if [[ -f "$method_file" ]]; then
		if [[ -n "$force" ]]
			then warn "RWfile" "$method_file" # Append instead
			else error "RWfile" "$method_file"; exit 1
		fi
	else
		log "Writing to a new file: [$method_file]"
		#touch "$2"
	fi


	# EXPORT DATA
	## Open database and output to a file
	## Do different things based on [export] or [export-data]
	;;
 import)
	log "Importing database from [$method_file]"

	# Test if file exists
	[[ -f "$method_file" ]] || { error "EXfile" "$method_file"; exit 1; }

	# IMPORT
	## Open file and import data into the database
	;;
 migrate)
	log "Migrating data from [$method_file]"

	# Test if file exists
	[[ -f "$method_file" ]] || { error "EXfile" "$method_file"; exit 1; }

	# MIGRATION
	## Do some migration process on the old data
	;;
 '')
	warn "0xmethod" "$method"
	# SETUP
	## Run the database schema setup
	## Run the database data setup
	## Run the tests
	;;
 *) error "NAmethod" "$method"; exit 1 ;;
esac
