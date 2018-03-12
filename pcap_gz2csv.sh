#!/bin/bash

###########################################################
### Parser PCAP.GZ to CSV 								   		       
### Usage: 				  								   		          
### 1. Place on folder where pcap.gz is 		 
### 2. Give execution permissions (like 755 or something).  	 
### 3. Run the scriptoo (./pcap2csv.sh).				   	    
### 4. When the scripto finishes, we will see the new csv files.			
### 															                														
#######################################################################################################
###	Info CSV													   					          
###	| Date | Timestamp | IP Src  | IP Dst | ID Proto | Port Src | Puerto Dst |
###														   											                   
###														   											                   
#######################################################################################################
# Change path if you need it
cap_files='*.pcap.gz'

# Change to split the csv output. 
# Default no split option
split=0

echo "Teleco LAN Party Feb-2018"
echo "Parser pcap.gz Wireshark to CSV"
echo ""

tmpfile='tmp_file.pcap'
numfiles=0

outfile=$numfiles'-'$(date +"%T")'-TLP.csv'

tshark_cmd='tshark'
tshark_options='-n -T fields -E separator=, -e frame.time -e ip.src -e ip.dst -e ip.proto -e tcp.port -e tcp.analysis.ack_rtt'

START=$(date +%s)
timestamp=$(date +"%T")
echo "Started at: $timestamp"
for file in $cap_files
do
   echo "processing file: $file"
   gunzip -c $file > $tmpfile
   #echo "== File:  $file"  >> $outfile
   $tshark_cmd -r $tmpfile $tshark_options >> $outfile

   if [ $( sed -n '$=' $outfile ) -gt $split ] 
   then
    numfiles=$(($numfiles + 1))
    outfile=$numfiles'-'$(date +"%T")'-TLP.csv'
   fi

done
rm $tmpfile

END=$(date +%s)
timestamp=$(date +"%T")
DIFF=$(( $END - $START ))
echo "Results in $numfiles files ... Finish --> $timestamp execution time --> $DIFF ... "
