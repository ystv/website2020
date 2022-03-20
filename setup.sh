verbose=''
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

 -c --config		Use a psql config file

 -v --verbose		Verbose
 -h --help		Show this help screen
"; }


declare -A messages=( \
	["NAmethod"]="Method not valid" \
	["0xmethod"]="Method has not been set - default to 'setup'" \
	["2xmethod"]="Method has been set twice" \
	["NAfile"]="Method file not valid" \
	["0xfile"]="Method file has not been set" \
	["EXfile"]="Method file does not exist" \
	["0xconfig"]="DB values have not been set" \
	["2xconfig"]="DB values have been set twice - default to config file" \
)
error() {
	echo "ERROR: ${messages[$1]} [$2]" >&2 ;}
warn() {
	[[-n "$verbose" ]] && echo "WARNING: ${messages[$1]} [$2]" >&2; }
log() {
	[[ -n "$verbose" ]] && echo "INFO: $1" >&2; }


while [[ $# -gt 0 ]]; do
	case "$1" in
	 -v|--verbose) verbose='true'; log "Verbose mode..." ;;
	 -h|--help) get_help; exit 0 ;;
	 *)
		# Check arguments have a valid 2nd term
		case "$2" in
		 -*|--*) error "NAfile" "$2"; exit 1 ;;
		 '') error "0xfile" "$2"; exit 1 ;;
		esac

		# Deal with items that have a 2nd term - shift twice
		case "$1" in
		 -H|--host) host="$2" ;;
	 	 -P|--port) port="$2" ;;
	 	 -D|--database) db="$2" ;;
	 	 -U|--user) user="$2" ;;

		 -c|--config) psql_file="$2" ;;

		 *)
			# Check if method has not already been set
			[[ -n "$method" ]] && { error "2xmethod" "$1"; exit 1; }
			method="$1"; method_file="$2"

			# Check if file actually exists
			[[ -f "$2" ]] || { error "EXfile" "$2"; exit 1; }
			;;
	 	esac; shift;;
	esac; shift
done


# Check for conflicts in the config options
if [[ -n "$psql_file" ]]; then
	log "Config file [$psql_file] given"
	[[ -n "$host$port$db$user" ]] && warn "2xconfig"

# If no config file is given, are there config variables?
elif [[ -z "$host" || -z "$port" || -z "$db" || -z "$user" ]]; then
	error "0xconfig" "$psql_file"; exit 1;

else
	log "Config variables [$host:$port:$db:$user] given"
fi


case "$method" in
 export)
	log "Dumping database to [$method_file]"
	# EXPORT ALL
	## Open database and output to a file
	;;
 export-data)
	log "Dumping data to [$method_file]"
	# EXPORT DATA
	## Open database and output to a file
	;;
 import)
	log "Importing database from [$method_file]"
	# IMPORT
	## Open file and import data into the database
	;;
 migrate)
	log "Migrating data from [$method_file]"
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
