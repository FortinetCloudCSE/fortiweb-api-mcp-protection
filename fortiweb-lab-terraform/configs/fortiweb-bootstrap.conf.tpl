Content-Type: multipart/mixed; boundary="===============fortiweb-lab-bootstrap=="
MIME-Version: 1.0

--===============fortiweb-lab-bootstrap==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system global
set hostname "Fweb-Fweb-Training"
end
config system interface
edit "port1"
set type physical
set allowaccess ping ssh snmp http https FWB-manager
set mode dhcp
config classless_static_route
edit 1
set gateway 10.10.2.1
next
edit 2
set dest 168.63.129.16/32
set gateway 10.10.2.1
next
edit 3
set dest 169.254.169.254/32
set gateway 10.10.2.1
next
end
next
edit "port2"
set type physical
set ip 10.10.1.100/24
set allowaccess ping http https
next
end
config system vip
edit "virt-1"
set vip 10.10.2.150/32
set interface port1
set index 1
next
edit "virt-2"
set vip 10.10.2.151/32
set interface port1
set index 2
next
edit "virt-3"
set vip 10.10.2.152/32
set interface port1
set index 3
next
edit "virt-4"
set vip 10.10.2.153/32
set interface port1
set index 4
next
end
config server-policy vserver
edit "virt-1"
config vip-list
edit 1
set vip virt-1
next
end
next
edit "virt-2"
config vip-list
edit 1
set vip virt-2
next
end
next
edit "virt-3"
config vip-list
edit 1
set vip virt-3
next
end
next
edit "virt-4"
config vip-list
edit 1
set vip virt-4
next
end
next
end
config server-policy server-pool
edit "MCP"
config pserver-list
edit 1
set ip 10.10.1.200
set port 9001
next
end
next
edit "DVWA"
config pserver-list
edit 1
set ip 10.10.1.200
set port 8080
next
end
next
edit "JUICESHOP"
config pserver-list
edit 1
set ip 10.10.1.200
set port 3000
next
end
next
edit "crAPI"
config pserver-list
edit 1
set ip 10.10.1.201
set port 8888
next
end
next
edit "petstore"
config pserver-list
edit 1
set ip 10.10.1.201
set port 8081
next
end
next
end
config router static
edit 1
set gateway 10.10.2.1
set device port1
next
edit 2
set dst 10.10.3.0/24
set gateway 10.10.2.101
set device port1
next
end
config system admin
edit "lab-student"
set access-profile prof_admin
set password "${lab_student_password}"
set trusthost1 10.10.3.0 255.255.255.0
next
end

--===============fortiweb-lab-bootstrap==--
