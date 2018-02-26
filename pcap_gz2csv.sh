#!/bin/bash

###########################################################
### Parser PCAP.GZ to CSV 								   		       
### Uso: 				  								   		          
### 1. Poner en la carpeta donde estén todas las capturas  		 
### 2. Darle permisos de ejecución. (chmod 755 pcap2csv.sh)  	 
### 3. Ejecutar este script. (./pcap2csv.sh)				   	    
### 4. En la misma carpeta que estamos aparece nuestro CSV 			
### 															                														
#######################################################################################################
###	Columnas del CSV resultante													   					          
###	| Fecha | timestamp | IP Origen | IP Destino | ID Protocolo | Puerto Origen | Puerto Destino |
###														   											                   
###														   											                   
#######################################################################################################
# Editar path si de verdad es necesario
cap_files='*.pcap.gz'

# Editar para cambiar cuando se crea el nuevo archivo para no llegar al maximo de filas.
split=1048574

echo "Teleco LAN Party Feb-2018"
echo "Parser para las capturas de Wireshark a CSV"
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

   ### Evitar sobrepasar el max de filas admitido por excel/libreoffice
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
