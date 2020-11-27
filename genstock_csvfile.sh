#!/bin/bash
set -vx
dos2unix stocks_raw_robinhood_data.txt stocks_raw_robinhood_data.txt
now=`date +"%m_%d_%Y"`
outfile=output_${now}.csv
touch $outfile temp.txt rawlines.txt
rm $outfile temp.txt rawlines.txt
touch $outfile temp.txt rawlines.txt

cat stocks_raw_robinhood_data.txt | tr -d "," | tr -s " " "_" | awk '{gsub(/US\$/,"")}1' >> rawlines.txt
lines=`cat rawlines.txt`
n=0
content="";
for line in $lines; do
	echo "Line No. $n : $line"
	n=$((n+1))
	if [ $(( n % 7 )) -eq 0 ]; then
		content=`echo $content","$line|tr -s "\r" " "`;
		echo $content 
		echo $content >> temp.txt
		#echo "/n" >> output.txt
		content="";
	else
		content=`echo $content","$line`;
		echo $content 
	fi
done 
echo "Symbol,Shares,Price,Average Cost,Total Return,Equity" > $outfile
cat temp.txt | cut -c 2-  | cut -d "," -f2,3,4,5,6,7>> $outfile
