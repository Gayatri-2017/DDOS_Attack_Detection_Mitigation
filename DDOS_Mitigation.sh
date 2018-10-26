<<<<<<< HEAD
echo -e "\n"
figlet -f standard "GG"
echo -e "\n"
=======
echo "\n"
figlet -f cosmic "GG"
echo "\n"
>>>>>>> 3e25120f85af5bd0fd34ee152013a8beef64256c
echo "Packet information stored in output.log"
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

file=output.log
flag=0
minimumsize=3000000 # 3 MB
#tcpdump -G 5 -W 1 -w $file -i en0 'port 8080'
count=5

while [ "$count" > 5 ] ; do
	#timeout 5 tcpdump -i en0 -w $file
	#tcpdump -G 5 -W 1 -w $file -i en0 -nni udp
	#tcpdump -G 5 -W 1 -nni en0 udp -w $file
	#tcpdump -nni en0 udp -G 5 -W 1 > $file
    ((count--))
	gtimeout 5 tcpdump -U -nni en0 > $file #runs for 5 sec
    actualsize=$(wc -c <"$file")
    echo "File size is " $actualsize
    if [ $actualsize -ge $minimumsize ]; then
        echo "size is over " $minimumsize bytes
        flag=1
    fi
    if [ $flag -eq 1 ] ; then
        flag=0
    	echo "DDOS attack suspected. Mitigation begins."
    	sudo ifconfig en0 down
    	#echo "Network is down now."
    	#give options to open tcpdump file or restart network
        PS3="What will you like to do next?"$'\n'

		options=("View tcpdump file" "Restore your network" "Continue Detection?")
		select opt in "${options[@]}"
		do
    		case $opt in
        		"View tcpdump file")
            		echo "you chose to View tcpdump file"
            		open $file
            		
            	;;
       			 "Restore your network")
            		echo "you chose Restore your network"
            		sudo ifconfig en0 down
            		sudo ifconfig en0 up
            		networksetup -setairportpower en0 off
            		networksetup -setairportpower en0 on
            	;;
        		"Continue Detection?")
            		break
            	;;
        		*) 
					echo "invalid option $REPLY";;
    		esac
		done
	fi
	#echo "Do you want to Quit the program"
    if [ "$count" = 0 ] ; then
        read -p "Continue? (Y/N): " confirm
        if [[ $confirm =~ ^([yY][eE][sS]|[yY])$ ]] ; then
            count=5;
        else
        	sudo kill -9 $(ps -e | pgrep tcpdump)
            exit 1;
        fi
    fi
done

#echo "Size of $FILENAME = $FILESIZE bytes."
#echo "DDOS attack suspected. Mitigation begins"
#sudo ip link set en0 down
