create table if not exists anyconnect
(
    id serial not null
        constraint anyconnect_pk
            primary key,
    starttime timestamp not null,
    endtime timestamp not null,
    username varchar(50) default 'None'::character varying not null,
    connectionstate integer default 2 not null,
    sensorip varchar(15) default '0.0.0.0'::character varying not null,
    realipaddr varchar(15) default '0.0.0.0'::character varying not null,
    assignedipv4 varchar(15) default '0.0.0.0'::character varying not null,
    country varchar(50) default ''::character varying not null,
    city varchar(50) default ''::character varying not null,
    coords varchar(50) default ''::character varying not null,
    sessionid varchar(28) default '0000000000000000000000000000'::character varying not null,
    sessionfullid varchar(28) default '0000000000000000000000000000'::character varying not null,
    vpnprotocol varchar(50) default ''::character varying not null,
    grouppolicy varchar(50) default ''::character varying not null,
    tunnelgroup varchar(50) default ''::character varying not null
);

create table if not exists syslog
(
    id serial not null
        constraint syslog_pk
            primary key,
    addedtime timestamp not null,
    datefrommsg varchar(15) ,
    timefrommsg varchar(15) ,
    senderip varchar(15) default '0.0.0.0'::character varying not null,
    severity integer,
    facility integer,
    headertext text,
    msgbody text
);

create table if not exists portdata
(
    id serial not null
        constraint portdata_pk
            primary key,
    addedtime timestamp not null,
    removedtime timestamp not null,
    macaddress char(12) default 'None'::character not null,
    current integer default 1 not null,
    vendor varchar(50) default ''::character varying not null,
    switchipaddr varchar(15) default '0.0.0.0'::character varying not null,
    ipaddr varchar(15) default '0.0.0.0'::character varying not null,
    coords varchar(50) default ''::character varying not null,
    portifindex int default 0 not null,
    portname varchar(28) default ''::character varying not null,
    vlanid int default 1 not null
);

create table if not exists portdatahistory
(
    id serial not null
        constraint portdatahistory_pk
            primary key,
    addedtime timestamp not null,
    removedtime timestamp not null,
    macaddress char(12) default 'None'::character not null,
    current integer default 1 not null,
    vendor varchar(50) default ''::character varying not null,
    switchipaddr varchar(15) default '0.0.0.0'::character varying not null,
    ipaddr varchar(15) default '0.0.0.0'::character varying not null,
    coords varchar(50) default ''::character varying not null,
    portifindex int default 0 not null,
    portname varchar(28) default ''::character varying not null,
    vlanid int default 1 not null
);


CREATE OR REPLACE FUNCTION syslog_time()
    RETURNS trigger AS $syslog_create_time$
BEGIN
    NEW.addedtime := current_timestamp;
    RETURN NEW;
END;
$syslog_create_time$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION anyconnect_create_time()
    RETURNS trigger AS $anyconnect_create_time$
BEGIN
    NEW.starttime := current_timestamp;
    NEW.endtime := current_timestamp;
    RETURN NEW;
END;
$anyconnect_create_time$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION anyconnect_end_time()
    RETURNS trigger AS $anyconnect_end_time$
BEGIN
    IF (NEW.connectionstate = 3) THEN
        NEW.endtime := current_timestamp;
    end if;
    RETURN NEW;
END;
$anyconnect_end_time$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION portdta_time()
    RETURNS trigger AS $portdta_time$
BEGIN
    NEW.addedtime := current_timestamp;
    NEW.removedtime := current_timestamp;

    RETURN NEW;
END;
$portdta_time$ LANGUAGE 'plpgsql';

create unique index if not exists syslog_addedtimedesc_uindex
    on syslog (addedtime DESC);

create trigger anyconnect_before_insert
    before insert
    on anyconnect
    for each row
execute procedure anyconnect_create_time();

create trigger anyconnect_before_update
    before update
    on anyconnect
    for each row
execute procedure anyconnect_end_time();

create trigger syslog_before_insert
    before insert
    on syslog
    for each row
execute procedure syslog_time();

create trigger portdata_before_insert
    before insert
    on portdata
    for each row
execute procedure portdta_time();



alter table anyconnect owner to netflow;
alter table syslog owner to netflow;


