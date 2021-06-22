#!/usr/bin/env sh
echo "Welcome to the Dima shell"

processCommand() {
	### echo "${message//[0-9]/X}" -replacing multiple times
	### echo "${message/[0-9]/X}" -replacing one time

	local comm=$1
	if [[ ! -z $2 ]]; then
		comm=$(echo -n ${comm//ans/$2})
	fi
	comm=$(echo -n ${comm//\(/\[}) # replacing braces
	comm=$(echo -n ${comm//\)/\]})
	comm=$(echo -n ${comm// /}) # removing spaces
	echo $comm
}


VAR_DECL_PAT="^[a-zA-Z0-9_]+:="

### `-r` - backslash does not act as an escape character
while IFS="" read -r -e -d $'\n' -p '#: ' command; do 
	if [ "$command" == 'exit' ]; then
		break
	elif [ "$command" == 'help' ]; then
		echo "exit - to terminate the shell"
		echo "help - display this help"
		echo "ans - the variable that contains result of the previous computation"
	else
		ecommand=$(processCommand "$command" $ans)

		if [[ $ecommand =~ $VAR_DECL_PAT ]]; then 
			echo "VAR EXPR $ecommand"
			echo $BASH_REMATCH
			continue
		fi

		### echo "C: '$command'"
		ans=$(./dima "$ecommand")
		history -s "$command"

		echo $ans
	fi
done

