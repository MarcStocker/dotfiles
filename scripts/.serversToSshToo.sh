############################################################
#    Add list of all servers to ./serversToSshToo.sh. 
#    Must follow following format:
#
#       server_SERVERNAME_name=
#       server_SERVERNAME_user=
#       server_SERVERNAME_port=
#       server_SERVERNAME_addr=
#       servers+=('SERVERNAME')
#
#       server_SERVERNAME_2_name=Display Name
#       server_SERVERNAME_2_user=user2
#       server_SERVERNAME_2_port=22
#       server_SERVERNAME_2_addr=10.0.0.2
#       servers+=('SERVERNAME_2')
#
############################################################

servers+=('rokian')
server_name[$servers[-1]]="Rokian Server"
server_user[$servers[-1]]="roki"
server_port[$servers[-1]]="42"
server_addr[$servers[-1]]="192.168.1.229"

servers+=('rokian2')
server_name[$servers[-1]]="Rokian Server2"
server_user[$servers[-1]]="roki2"
server_port[$servers[-1]]="42"
server_addr[$servers[-1]]="192.168.1.229"

#server_rokian_name="Rokian Server2"
#server_rokian_user="roki2"
#server_rokian_port="42"
#server_rokian_addr="192.168.1.229"
#servers+=('rokian2')
#
#server_rokian_name="Rokian Server3"
#server_rokian_user="roki3"
#server_rokian_port="42"
#server_rokian_addr="192.168.1.229"
#servers+=('rokian3')
#
#server_rokian_name="Rokian Server4"
#server_rokian_user="roki4"
#server_rokian_port="42"
#server_rokian_addr="192.168.1.229"
#servers+=('rokian4')
