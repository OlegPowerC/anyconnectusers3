RU: Тестовая версия. Статистика пользователей AnyConnect + UI с базой на Postgre SQL

Установка (на докер сервер): git clone https://github.com/OlegPowerC/anyconnectusers3.git

Зайти в папку и запустить файл initdb.sh

cd anyconnectusersandsyslog ./initdb.sh

Дождаться готовности PSQL сервера и остановить запущеный контейнер - ctrl+c

Затем можно запускать все контейнеры: docker-compose up

По умолчанию HTTP://<ваш docker сервер>:8181 SyslogUI HTTP://<ваш docker сервер>:8182 AnyConnect Users UI Порт UDP 514 слушает Syslog сообщения SQL порт TCP снаружи 5442 (можно выключить) Порт TCP 7002 слушает Call-Home сообщения от Cisco ASA

Со стороны Cisco ASA:

logging list SSLUSERS2 level informational logging list SSLUSERS2 message 605005 logging list SSLUSERS2 message 611103 logging list SSLUSERS2 message 113039 logging list SSLUSERS2 message 722051 logging trap SSLUSERS2 logging host inside

event manager applet StartSession event syslog id 722051 occurs 1 action 0 cli command "call-home send alert-group snapshot profile VPNSH" output none

event manager applet EndSession event syslog id 113019 occurs 1 action 0 cli command "call-home send alert-group snapshot profile VPNSH" output none

service call-home call-home alert-group-config snapshot add-command "show vpn-sessiondb anyconnect" profile VPNSH destination transport-method http destination address http http://:7002/vpnsession msg-format xml destination transport-method http subscribe-to-alert-group snapshot periodic interval 1440

EN: Betta version. AnyConnect users statistics + Syslog collector + UI common Postgre SQL database

Install (on docker host): git clone https://github.com/OlegPowerC/anyconnectusersandsyslog.git

Run initdb.sh for create database and tables

cd anyconnectusersandsyslog ./initdb.sh

Wait for PSQL complete initial work and start, then exit - ctrl+c

Now You can start all containers: docker-compose up

By default: HTTP://:8181 SyslogUI HTTP://:8182 AnyConnect Users UI Port UDP 514 accept Syslog message SQL server accessible by port TCP 5442 (You can disable it) Port TCP 7002 accept Call-Home message from Cisco ASA

On Cisco ASA You must configure next:

logging list SSLUSERS2 level informational logging list SSLUSERS2 message 605005 logging list SSLUSERS2 message 611103 logging list SSLUSERS2 message 113039 logging list SSLUSERS2 message 722051 logging trap SSLUSERS2 logging host inside

event manager applet StartSession event syslog id 722051 occurs 1 action 0 cli command "call-home send alert-group snapshot profile VPNSH" output none

event manager applet EndSession event syslog id 113019 occurs 1 action 0 cli command "call-home send alert-group snapshot profile VPNSH" output none

service call-home call-home alert-group-config snapshot add-command "show vpn-sessiondb anyconnect" profile VPNSH destination transport-method http destination address http http://:7002/vpnsession msg-format xml destination transport-method http subscribe-to-alert-group snapshot periodic interval 1440

