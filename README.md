# pcap_gz2csv
A tiny bash script to parser .pcap.gz files to a CSV.

This scripto was created for help to parse the info collected on the Teleco LAN Party.


Features:
- Autofile split to avoid rows overflow in excel/libreoffice.
- Some randoms timestamp to see how much time loose parsing A LOT of packages


Usage:
1. Place on folder where pcap.gz is.
2. Give execution permissions (like 755 or something).
3. Run the scriptoo (./pcap2csv.sh)
4. When the scripto finish, we will see the new csv files.
