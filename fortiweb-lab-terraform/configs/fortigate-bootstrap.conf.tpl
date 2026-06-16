Content-Type: multipart/mixed; boundary="===============fortiweb-lab-bootstrap=="
MIME-Version: 1.0

--===============fortiweb-lab-bootstrap==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system global
set hostname "FG-Fweb-Lab"
set timezone "US/Pacific"
end
config system interface
edit "port1"
set vdom "root"
set mode dhcp
set allowaccess ping https ssh http
next
edit "port2"
set vdom "root"
set ip 10.10.2.101 255.255.255.0
set allowaccess ping https http
next
end
config system admin
edit "lab-student"
set password "${lab_student_password}"
set accprofile "super_admin"
set trusthost1 10.10.3.0 255.255.255.0
next
end
config firewall address
edit "fortiweb"
set subnet 10.10.2.100 255.255.255.255
next
end
config firewall vip
edit "FortiWeb_virt_1"
set extip 10.10.3.150
set mappedip "10.10.2.150"
set extintf "port1"
next
edit "FortiWeb_virt_2"
set extip 10.10.3.151
set mappedip "10.10.2.151"
set extintf "any"
next
edit "FortiWeb_virt_3"
set extip 10.10.3.152
set mappedip "10.10.2.152"
set extintf "any"
next
edit "FortiWeb_virt_4"
set extip 10.10.3.153
set mappedip "10.10.2.153"
set extintf "any"
next
end
config firewall policy
edit 1
set name "App_Access_Virt_1"
set srcintf "port1"
set dstintf "port2"
set srcaddr "all"
set dstaddr "FortiWeb_virt_1"
set action accept
set schedule "always"
set service "ALL"
set logtraffic-start enable
next
edit 2
set name "App_Access_Virt_2"
set srcintf "port1"
set dstintf "port2"
set srcaddr "all"
set dstaddr "FortiWeb_virt_2"
set action accept
set schedule "always"
set service "ALL"
next
edit 3
set name "App_Access_Virt_3"
set srcintf "port1"
set dstintf "port2"
set srcaddr "all"
set dstaddr "FortiWeb_virt_3"
set action accept
set schedule "always"
set service "ALL"
next
edit 4
set name "App_Access_Virt_4"
set srcintf "port1"
set dstintf "port2"
set srcaddr "all"
set dstaddr "FortiWeb_virt_4"
set action accept
set schedule "always"
set service "ALL"
next
edit 5
set name "access Fortiweb"
set srcintf "port1"
set dstintf "port2"
set srcaddr "all"
set dstaddr "fortiweb"
set action accept
set schedule "always"
set service "ALL"
set nat enable
next
end

--===============fortiweb-lab-bootstrap==--
