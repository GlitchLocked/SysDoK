#!/bin/bash
clear

###################################################
#*/=============================================\*#
# ||                      .__                  || #
# ||   ____   ____   ____ |  |   ____   ____   || #
# || _/ __ \_/ __ \ / ___\|  |  /  _ \ /  _ \  || #
# || \  ___/\  ___// /_/  >  |_(  <_> |  <_> ) || #
# ||  \___  >\___  >___  /|____/\____/ \____/  || #
# ||      \/     \/_____/                  2021|| #
#.\=============================================/.#
################################################### 

 #  ___ ___ _____ _   ___ _    ___ ___ 
 # |_ _| _ \_   _/_\ | _ ) |  | __/ __|
 #  | ||  _/ | |/ _ \| _ \ |__| _|\__ \
 # |___|_|   |_/_/ \_\___/____|___|___/
 #  ___ _   _ _    ___ ___ 
 # | _ \ | | | |  | __/ __|
 # |   / |_| | |__| _|\__ \
 # |_|_\\___/|____|___|___/
 #_________________________                         

### start classique rules for firewall ###
echo "Setting $(hostname) Firewall"

# Préciser les helpers utilisés pour les règles RELATED et les paramètres de ceux-ci, et ainsi limiter le spoofing d’addresse.
#modprobe nf_conntrack nf_conntrack_helper=0

 ##############################                           
 #   ___ _    ___   _   _  _  #
 #  / __| |  | __| /_\ | \| | #
 # | (__| |__| _| / _ \| .` | #
 #  \___|____|___/_/ \_\_|\_| #
 #----------------------------#
 ##############################

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

 #############################
 #  ___ _    ___   ___ _  __ #
 # | _ ) |  / _ \ / __| |/ / #
 # | _ \ |_| (_) | (__| ' <  #
 # |___/____\___/ \___|_|\_\ #
 #---------------------------#
 #############################

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

 #######################
 #  ___ ___ _  _  ___  #
 # | _ \_ _| \| |/ __| #
 # |  _/| || .` | (_ | #
 # |_| |___|_|\_|\___| #
 #---------------------#
 #######################

# NOK
# iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP
# iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP
# echo "Ping NOK"

# OK
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
echo "Ping OK"

 ################################################
 #   ___ ___  _  _ _  _ _____  _____ ___  _  _  #
 #  / __/ _ \| \| | \| | __\ \/ /_ _/ _ \| \| | #
 # | (_| (_) | .` | .` | _| >  < | | (_) | .` | #
 #  \___\___/|_|\_|_|\_|___/_/\_\___\___/|_|\_| #                                            
 #----------------------------------------------#
 ################################################

# AUTORISE connexion ouverte pour le trafic en entrée.
# iptables -A INPUT -p ALL  -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

## AUTORISE connexion ouverte pour le trafic en sortie.
iptables -A OUTPUT -m conntrack ! --ctstate INVALID -j ACCEPT

# AUTORISE les connexions sur la machine (127.0.0.1)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

## AUTORISE Multicast / paquets broadcastés.
iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT

 ########################
 #   ___  ___ ___ _  _  #
 #  / _ \| _ \ __| \| | #
 # | (_) |  _/ _|| .` | #
 #  \___/|_| |___|_|\_| #
 #----------------------#
 ########################

echo "Open port :"

# SSH
# iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
# iptables -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
# echo "      - Open 22 : SSH"

# HTTP
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
echo "      - Open 80 : HTTP"

# HTTPS
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
echo "      - Open 443 : HTTPS"

# # NodeJS
# iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 9000 -j ACCEPT
# echo "      - Open NodeJs : 3000,9000"

# IRC
# iptables -A INPUT -p tcp -m tcp --dport 6666 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 6667 -j ACCEPT
# iptables -A OUTPUT -p tcp -m tcp --dport 6666 -j ACCEPT
# iptables -A OUTPUT -p tcp -m tcp --dport 6667 -j ACCEPT
# echo "      - Open 6666 : IRC"
# echo "      - Open 6667 : IRC"

# # FTP
# iptables -A INPUT -p tcp -m tcp --dport 21 -j ACCEPT
# echo "      - Open FTP"

# # SMTP
# echo "      - Open SMTP"
 
# # OpenVpn
# iptables -A INPUT -p udp --dport 913 -j ACCEPT
# echo "      - Open OpenVpn"

# # Video Lan
# iptables -A INPUT -p udp --dport 1234 -j ACCEPT
# echo "      - Open Video Lan"

# # Teamviewer
# iptables -A INPUT -p tcp --dport 5938 -j ACCEPT
# iptables -A INPUT -p udp --dport 5938 -j ACCEPT
# echo "      - Open TeamViewer"

 ##########################                       
 #    _   _  _ _____ ___  #
 #   /_\ | \| |_   _|_ _| #
 #  / _ \| .` | | |  | |  #
 # /_/_\_\_|\_|_|_|_|___| #
 # / __|/ __| /_\ | \| |  #
 # \__ \ (__ / _ \| .` |  #
 # |___/\___/_/ \_\_|\_|  #
 #------------------------#
 ##########################                       

# IPTABLES -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# IPTABLES -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# IPTABLES -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
# IPTABLES -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP

# IPTABLES -A port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
# IPTABLES -A port-scan -j DROP --log-level 6
# IPTABLES -A specific-rule-set -p tcp --syn -j syn-flood
# IPTABLES -A specific-rule-set -p tcp --tcp-flags SYN,ACK,FIN,RST RST -j port-scan

 ####################
 #  _    ___   ___  #
 # | |  / _ \ / __| #
 # | |_| (_) | (_ | #
 # |____\___/ \___| #
 #------------------#
 ####################
 # ls /var/log/

# LOG
iptables -A INPUT -p icmp --icmp-type echo-request -j LOG --log-level info --log-prefix "[ping] "
echo "LOG : "
echo "      - PING"

##paquets en entrée.
iptables -A INPUT -j LOG
echo "      - INPUT"
 
##paquets forward.
iptables -A FORWARD -j LOG 
echo "      - FORWARD"


########
exit 0 #
########