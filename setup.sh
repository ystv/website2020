method=''
method_arg=''
verbose=''

show_help() { printf "
Usage...
 NO ARGS\t\t Set up the database
 --dump [..]\t\t Dump database with schema to a file
 --dump-data [..]\t Dump database without schema (data only) to a file
 --import [..]\t\t Import data from a file
 --migrate [..]\t\t Migrate data (from an old database) from a file
 -v --verbose\t\t Verbose
 -h --help\t\t Show this help screen
"; }

log () { 
	if [[ -n $verbose ]]; then
		echo "$@"
	else
		echo "$@" >&2
	fi
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	 -h|--help)
		show_help; exit 0;
		;;
	 -v|--verbose)
		verbose="true"
		log "Verbose mode..."
		;;
	 --*)
		method="$1"; shift
		case "$1" in
		 -*)
			log "Invalid argument for method [$method]"
			show_help; exit 1
			;;
		 *)
			method_arg="$1"
			;;
		esac
		;; 
	 *)
		# In future this defaults to a TUI
		log "Method value defaulted"
		method="--setup"
		;;
	esac; shift
done

case "$method" in
 --dump*)
	log " - Dumping to [$method_arg]"
	# Open database and output to file
	;;
 --import)
	log " - Importing data from [$method_arg]"
	# Open file and import data into database
	;;
 --migrate)
	log " - Migrating data from [$method_arg]"
	# Do some migration process on the old data
	;;
 --setup)
	log " - Setting up database"
	# Run the database schema setup
	# Run the database data setup
	# Run tests
	;;
 :)
	log "No method given"
	show_help; exit 1
	;;
 *)
	log "Chosen method does not exist"
	show_help; exit 1
	;;
esac
