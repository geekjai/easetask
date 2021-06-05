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

# transArray is having transaction list
# to print all array elements > echo ${transArray[*]}

# declare file name list
declare -A fileNameList

# iterate through transaction list array
for trans in ${transArray[@]}
do 
	echo "Processing Transaction : $trans"
	# cache transaction details in a file
	ade describetrans $trans > tempOutput.txt
	input="tempOutput.txt"
	while IFS= read -r var
	do
		# parse every line and build a map based on file name
		# echo $var
		if [[ $var == "fusionapps/hcm/components"* || $var == "fusionapps/hcm/hrt"* ]]; then
			if [[ $var == *"@"* ]]; then
				SUBSTRING=${var%@*}
				# remove last character
				SUBSTRING=${SUBSTRING%?}
			fi
			# echo $SUBSTRING
			# if a variable has NULL
			if [ -z "${fileNameList[$SUBSTRING]}" ]; then
				# yes null
				# echo "yes +++++++++++++++++++++++++++"
				fileTrans=$trans
				fileNameList["$SUBSTRING"]=$fileTrans
			else
				# not null
				# echo "no ---------------------------------"
				fileTrans=${fileNameList[$SUBSTRING]}
				fileTrans="$fileTrans $trans"
				fileNameList["$SUBSTRING"]=$fileTrans
				# echo $fileTrans
			fi
			# echo $SUBSTRING
		fi
	done < "$input"
done
# end of describetrans input
# echo ${fileNameList[*]}
# iterate trough all key and transaction having file changes
finalFile="/scratch/jakishan/easecommontask/storage/TransactionAnalyserReport.html"
echo "<html !DOCTYPE><head><title>Transaction Info</title>
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
   <th style='width:70%'>File Name</th>
   <th style='width:30%'>Transactions</th>
</thead>
<tbody>" > $finalFile
for fileName in ${!fileNameList[@]}
do
	echo "<tr align='center' valign='top'><td style='width:70%'><span style='color:#a32a91;'> $fileName </span></td>" >> $finalFile
	echo "<td style='width:30%'><span style='color:#a32a91'> ${fileNameList[$fileName]} </span></td></tr>" >> $finalFile
done
echo "</body></html>" >> $finalFile
# firefox "TransactionResult.html"