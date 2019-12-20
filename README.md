# DDOS Attack Detection and Mitigation


<!--
.,-:::::/    .,-:::::/  
,;;-'````'   ,;;-'````'   
[[[   [[[[[[/[[[   [[[[[[/
"$$c.    "$$ "$$c.    "$$ 
`Y8bo,,,o88o `Y8bo,,,o88o
`'YMUP"YMM   `'YMUP"YMM
-->

Run the Attack file in the attacker machine

Run the Mitigation file in the target machine

# Output Screenshots

## Attacker PC:

### UDP Flood
![UDP Flood](./images/NTAL_1.png)

### TCP ACK Flood
![TCP ACK Flood](./images/NTAL_2.png)

### TCP RST Flood
![TCP RST Flood](./images/NTAL_3.png)

### ICMP Echo Reply
![ICMP Echo Reply](./images/NTAL_4.png)

### ICMP Destination Unreachable and Source Quench
![ICMP Destination Unreachable and Source Quench](./images/NTAL_5.png)

### ICMP Router advertisement and Traceroute
![ICMP Router advertisement and Traceroute](./images/NTAL_6.png)

## Victim PC

### Detection and Mitigation
![Detection and Mitigation](./images/NTAL_7.png)

### TCPDUMP file
![TCPDUMP file](./images/NTAL_8.png)

### Restore Network
![Restore Network](./images/NTAL_9.png)
