echo "Packet information stored in output.txt"
#sudo tcpdump -A >output.txt
#chmod 777 output.txt
#FILENAME= ~/Desktop/output.txt
#FILENAME= "output.txt"
#FILESIZE=$(stat -c%s "$FILENAME")

#file=output.txt
#minimumsize=90000
#actualsize=$(wc -c <"$file")
#if [ $actualsize -ge $minimumsize ]; then
#echo "size is over " $minimumsize bytes
#echo "File size is " $actualsize
#fi

file=output.txt
flag=0
minimumsize=3000000
#tcpdump -G 5 -W 1 -w output.txt -i en0 'port 8080'

while true ; do
	#timeout 5 tcpdump -i en0 -w output.txt
	tcpdump -G 5 -W 1 -w output.txt -i en0 udp
    actualsize=$(wc -c <"$file")
    echo "File size is " $actualsize
    if [ $actualsize -ge $minimumsize ]; then
        echo "size is over " $minimumsize bytes
        flag=1
    fi
    if [ $flag -eq 1 ] ; then
    	echo "DDOS attack suspected. Mitigation begins"
    	sudo ifconfig en0 down
    	#give options to open tcpdump file or restart network
        PS3='What will you like to do next?'
options=("View tcpdump file" "Restore your network" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "View tcpdump file")
            echo "you chose to View tcpdump file"
            cat $file
            ;;
        "Restore your network")
            echo "you chose Restore your network"
            sudo ifconfig en0 up
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
	fi
done

#echo "Size of $FILENAME = $FILESIZE bytes."
#echo "DDOS attack suspected. Mitigation begins"
#sudo ip link set en0 down
