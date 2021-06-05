#!/bin/bash
input=$1
# declare a array which will hold transaction list
# read the input file to get transaction list

# Adds a newline character at the end
echo "" >> $input

declare -a transArray
i=0;
while IFS=$'\r' read -r var
do
	transArray[$((i))]=$var
	i=$((i+1))
done < "$input"

declare -A bugList

for trans in ${transArray[@]}
do 
	echo "Processing Transaction : $trans"
	# cache transaction details in a file
	ade describetrans $trans -properties_only > tempOutput.txt
	input="tempOutput.txt"
	while IFS= read -r var
	do
		if [[ $var == *"BUG_NUM"* ]]; then
			echo $var
			if [[ $var == *":"* ]]; then
				IFS=':' read -r -a array <<< "$var"
				IFS=' ' read -r -a array <<< "${array[1]}"
				IFS=',' read -r -a array <<< "${array[0]}"
				for element in "${array[@]}"
				do
					bugList["$element"]=$element
				done
			fi
		fi
	done < "$input"	
done

declare -A userList

for trans in ${transArray[@]}
do
	SUBSTRING=${trans%_*}
	userList["$SUBSTRING"]=$SUBSTRING
done

finalFile="/scratch/jakishan/easecommontask/storage/TransactionAnalyserBugReport.html"
echo "<html !DOCTYPE><head><title>Bug Info</title>
<style>
table, th, td {
  border: 1px solid black;
}
tr:nth-child(even) {background-color: #f2f2f2;}
thead {
	background-color: #e9f2df;
}
</style></head><body>
<table>
<thead>
   <th style='width:150px;'>Bug Number</th>
</thead>
<tbody>" > $finalFile
for bugNumber in ${!bugList[@]}
do
	echo "<tr align='center' valign='top'><td style='width:150px;'><span style='color:#a32a91;'> $bugNumber </span></td>" >> $finalFile
done
i=0;
cmd=""
bugInfoSql=""
for bugNumber in ${!bugList[@]}
do
	if [ "$i" = 0 ]
	then
		cmd="ade settransproperty -p BUG_NUM -v $bugNumber"
		bugInfoSql="select RPTNO, STATUS, SUBJECT from RPTHEAD where RPTNO in ($bugNumber"
	else
		cmd="$cmd,$bugNumber"
		bugInfoSql="$bugInfoSql,$bugNumber"
	fi
	i=$((i+1))
done
bugInfoSql="$bugInfoSql);"

echo "</tbody></table>" >> $finalFile

echo "<table style='margin-top:10px;'>
<thead>
   <th>Set Property Command</th>
</thead>
<tbody>" >> $finalFile
echo "<tr align='center' valign='top'><td><span style='color:#a32a91;'> $cmd </span></td>" >> $finalFile
echo "</tbody></table>" >> $finalFile

# Bug Info Sql Query
echo "<table style='margin-top:10px;'>
<thead>
   <th>Bug Information</th>
</thead>
<tbody>" >> $finalFile
echo "<tr align='center' valign='top'><td><span style='color:#a32a91;'> $bugInfoSql </span></td>" >> $finalFile
echo "</tbody></table>" >> $finalFile

# User Info Sql Query
userQuery=""
i=0
for user in ${!userList[@]}
do
	if [ "$i" = 0 ]
	then
		userQuery="SELECT BUG_USERNAME, FULL_EMAIL FROM BUG_USER where lower(BUG_USERNAME) in ('$user'"
	else
		userQuery="$userQuery,'$user'"
	fi
	i=$((i+1))
done
userQuery="$userQuery);"

echo "<table style='margin-top:10px;'>
<thead>
   <th>User Information</th>
</thead>
<tbody>" >> $finalFile
echo "<tr align='center' valign='top'><td><span style='color:#a32a91;'> $userQuery </span></td>" >> $finalFile
echo "</tbody></table>" >> $finalFile

echo "</body></html>" >> $finalFile