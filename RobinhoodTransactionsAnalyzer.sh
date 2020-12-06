#!/bin/bash
set -vx
dos2unix RobinhoodTransactions_Raw.txt
now=`date +"%m_%d_%Y"`
outfile=output_${now}.csv
touch $outfile Split_Lines.txt RobinhoodTransactions_Raw_Tilda_Line.txt Joint_Lines.txt RobinhoodTransactions_Raw_Empty_Line.txt
rm $outfile Split_Lines.txt RobinhoodTransactions_Raw_Tilda_Line.txt Joint_Lines.txt RobinhoodTransactions_Raw_Empty_Line.txt
touch $outfile Split_Lines.txt RobinhoodTransactions_Raw_Tilda_Line.txt Joint_Lines.txt RobinhoodTransactions_Raw_Empty_Line.txt

dos2unix RobinhoodTransactions_Raw.txt
awk '!NF{$0="|"}1' RobinhoodTransactions_Raw.txt >> RobinhoodTransactions_Raw_Empty_Line.txt
sed 's/$/ ~/' RobinhoodTransactions_Raw_Empty_Line.txt > RobinhoodTransactions_Raw_Tilda_Line.txt
awk '{printf $0;}' RobinhoodTransactions_Raw_Tilda_Line.txt >> Joint_Lines.txt
cat  Joint_Lines.txt | tr "|" "\n" >> Split_Lines.txt
cat Split_Lines.txt | grep "shares at US" | awk '{gsub(/ shares at US/,"|")}1' | awk '{gsub(/ ~US\$/,"|")}1' | awk '{gsub(/ Market Sell ~/,"|Sell|")}1' | awk '{gsub(/ Market Buy ~/,"|Buy|")}1' | awk '{gsub(/ Limit/,"|")}1' | tr -s "~" "|" |sort >> $outfile

rm Split_Lines.txt Joint_Lines.txt RobinhoodTransactions_Raw_Tilda_Line.txt RobinhoodTransactions_Raw_Empty_Line.txt