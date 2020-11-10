RU: Тестовая третья версия. Статистика пользователей AnyConnect + UI с базой на Postgre SQL

Установка (на докер сервер):<br>
git clone https://github.com/OlegPowerC/anyconnectusers3.git<br>
Зайти в папку и запустить файл initdb.sh<br>
<br>
cd anyconnectusersandsyslog<br>
chmod 777 initdb.sh<br>
./initdb.sh<br>
<br>
Дождаться готовности PSQL сервера<br>
Не должно быть сообщений об ошибках и вывод должен быть примерно следующий:<br>
server started<br>
<br>
/usr/local/bin/docker-entrypoint.sh: sourcing /docker-entrypoint-initdb.d/1_createdb.sh<br>
CREATE ROLE<br>
CREATE DATABASE<br>
GRANT<br>
<br>
/usr/local/bin/docker-entrypoint.sh: sourcing /docker-entrypoint-initdb.d/2_createtabledb.sh<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE INDEX<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
ALTER TABLE<br>
ALTER TABLE<br>
...........<br>
PostgreSQL init process complete; ready for start up.<br>
...........<br>
...........<br>
LOG:  database system is ready to accept connections<br>
<br>
После этого остановить запущеный контейнер - ctrl+c<br>
<br>
Затем можно запускать все контейнеры: docker-compose up<br>
<br>
По умолчанию интерфейс будет доступен по адресу HTTP://<ваш docker сервер>:8181 SyslogUI HTTP://<ваш docker сервер>:8182<br>
SQL порт TCP снаружи 5442 (можно выключить) Порт TCP 7002 слушает Call-Home сообщения от Cisco ASA<br>
<br>
Со стороны Cisco ASA:<br>
<br>
logging list SSLUSERS2 level informational<br>
logging list SSLUSERS2 message 605005<br>
logging list SSLUSERS2 message 611103<br>
logging list SSLUSERS2 message 113039<br>
logging list SSLUSERS2 message 722051<br>
logging trap SSLUSERS2<br>
logging host inside<br>
<br>
event manager applet StartSession<br>
&nbsp;event syslog id 722051 occurs 1<br>
&nbsp;action 0 cli command "call-home send alert-group snapshot profile VPNSH"<br>
&nbsp;output none<br>
<br>
event manager applet EndSession<br>
&nbsp;event syslog id 113019 occurs 1<br>
&nbsp;action 0 cli command "call-home send alert-group snapshot profile VPNSH"<br>
&nbsp;output none<br>
<br>
service call-home<br>
&nbsp;call-home alert-group-config snapshot<br>
&nbsp;&nbsp;add-command "show vpn-sessiondb anyconnect"<br>
&nbsp;profile VPNSH<br>
&nbsp;&nbsp;destination transport-method http destination address http http://:7002/vpnsession msg-format xml destination transport-method http subscribe-to-alert-group snapshot periodic interval 1440<br>
<br>
Для геолокации по IP адресу используется сервис https://ipstack.com/
Необходимо получить API ключ и указать его в docker-compose.yml
параметер GEOLOCATIONAPIKEY:

===================================================================================================================
EN: Betta version 3. AnyConnect users statistics + UI common Postgre SQL database

Install (on docker host): git clone https://github.com/OlegPowerC/anyconnectusersandsyslog.git

Run initdb.sh for create database and tables

cd anyconnectusersandsyslog
chmod 777 initdb.sh
./initdb.sh

Wait for PSQL complete initial work and start, 
log must be like:
server started<br>
<br>
/usr/local/bin/docker-entrypoint.sh: sourcing /docker-entrypoint-initdb.d/1_createdb.sh<br>
CREATE ROLE<br>
CREATE DATABASE<br>
GRANT<br>
<br>
/usr/local/bin/docker-entrypoint.sh: sourcing /docker-entrypoint-initdb.d/2_createtabledb.sh<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE TABLE<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE FUNCTION<br>
CREATE INDEX<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
CREATE TRIGGER<br>
ALTER TABLE<br>
ALTER TABLE<br>
...........<br>
PostgreSQL init process complete; ready for start up.<br>
...........<br>
...........<br>
LOG:  database system is ready to accept connections<br>
<br>
then exit - ctrl+c

Now You can start all containers: docker-compose up

By default: HTTP://:8181 SyslogUI HTTP://:8182 AnyConnect Users UI Port UDP 514 accept Syslog message SQL server accessible by port TCP 5442 (You can disable it) Port TCP 7002 accept Call-Home message from Cisco ASA

On Cisco ASA You must configure next:

<br>
logging list SSLUSERS2 level informational<br>
logging list SSLUSERS2 message 605005<br>
logging list SSLUSERS2 message 611103<br>
logging list SSLUSERS2 message 113039<br>
logging list SSLUSERS2 message 722051<br>
logging trap SSLUSERS2<br>
logging host inside<br>
<br>
event manager applet StartSession<br>
&nbsp;event syslog id 722051 occurs 1<br>
&nbsp;action 0 cli command "call-home send alert-group snapshot profile VPNSH"<br>
&nbsp;output none<br>
<br>
event manager applet EndSession<br>
&nbsp;event syslog id 113019 occurs 1<br>
&nbsp;action 0 cli command "call-home send alert-group snapshot profile VPNSH"<br>
&nbsp;output none<br>
<br>
service call-home<br>
&nbsp;call-home alert-group-config snapshot<br>
&nbsp;&nbsp;add-command "show vpn-sessiondb anyconnect"<br>
&nbsp;profile VPNSH<br>
&nbsp;&nbsp;destination transport-method http destination address http http://:7002/vpnsession msg-format xml destination transport-method http subscribe-to-alert-group snapshot periodic interval 1440<br>
<br>

Gelolocation data get by https://ipstack.com/
You must get API key and provide it ib: docker-compose.yml
parameter - GEOLOCATIONAPIKEY: