drop table "SYSTEM"."COUNTRY" cascade CONSTRAINTS;
drop table "SYSTEM"."LANG" cascade CONSTRAINTS;
drop table "SYSTEM"."ACTIONS" cascade CONSTRAINTS;
drop table "SYSTEM"."MAIL_DOMAIN" cascade CONSTRAINTS;
drop table "SYSTEM"."CLIENT_ADMIN" cascade CONSTRAINTS;
drop table "SYSTEM"."MAIL_USER" cascade CONSTRAINTS;
drop table "SYSTEM"."MAIL_FORWARDING" cascade CONSTRAINTS;
drop table "SYSTEM"."CLIENT_CONTROL_DOMAIN" cascade CONSTRAINTS;
drop table "SYSTEM"."MAIL_CONTENT_FILTER" cascade CONSTRAINTS;
drop table "SYSTEM"."FILTERS" cascade CONSTRAINTS;





create table COUNTRY(
    countryID int not NULL UNIQUE,
    country_name varchar(50) not NULL,
    primary key (countryID)
);

create table LANG(
    langID int not NULL UNIQUE,
    lang_name varchar(50) not NULL,
    primary key (langID)
);

create table ACTIONS(
    actionID int not null UNIQUE,
    action_Name varchar(256) not null,
    primary key(actionID)
);

create table MAIL_DOMAIN(
    domainID int not NULL UNIQUE,
    domain_Name varchar(50) not NULL UNIQUE,
    active varchar(2) DEFAULT 'y',
    countryID int not NULL,
    foreign key(countryID) references COUNTRY(countryID),
    primary key(domainID),
    check (active='y' or active='n')
);

create table CLIENT_ADMIN(
    clientID int not NULL UNIQUE,
    username varchar(255) not NULL UNIQUE,
    password varchar(255) not NULL,
    recovery_mail varchar(255) default NULL UNIQUE,
    langID int not NULL,
    foreign key (langID) references LANG(langID),
    primary key(clientID)
);

create table MAIL_USER(
    mailuserID int not null UNIQUE,
    domainID int not null,
    email varchar(255) not null UNIQUE,
    password varchar(255) not null,
    name varchar(255),
    usid int default 5000,
    gid int default 5000,
    maildir varchar(255) not null UNIQUE,
    maildir_format varchar(255) default 'maildir',
    langID int not NULL,
    quota numeric(38) default 0,
    cc varchar(1024) default null,
    homedir varchar(255),
    autoresponder varchar(1) default 'n',
    autorespond_startdate DATE,
    autorespond_enddate DATE,
    autorespond_subj varchar(255) default 'OOF reply',
    autorespond_text varchar(1024) default NULL,
    disableimap varchar(1) default 'n',
    disablepop3 varchar(1) default 'n',
    disabledelivery varchar(1) default 'n',
    disablesmtp varchar(1) default 'n',
    disablequota varchar(1) default 'n',
    mail_access varchar(1) default'y',
    foreign key (langID) references LANG(langID),
    foreign key (domainID) REFERENCES MAIL_DOMAIN(domainid),
    primary key (mailuserID),
    check (autoresponder='y' or autoresponder='n'),
    check (disableimap='y' or disableimap='n'),
    check (disablepop3='y' or disablepop3='n'),
    check (disabledelivery='y' or disabledelivery='n'),
    check (disablesmtp='y' or disablesmtp='n'),
    check (disablequota='y' or disablequota='n'),
    check (mail_access='y' or mail_access='n')
);

create table MAIL_FORWARDING(
    forwardID int not NULL UNIQUE,
    sourceID int not NULL,
    destination varchar(256) not NULL,
    active varchar(1) default 'y',
    check(active='y' or active='n'),
    primary key (forwardID),
    foreign key (sourceID) references MAIL_USER(mailuserID)
);



create table FILTERS(
    filterID int not NULL UNIQUE,
    filterName varchar(256) not NULL,
    Headers varchar(1) default 'y',
    Subject varchar(1) default 'y',
    Text varchar(1) default 'y',
    attachments varchar(1) default 'y',
    primary key(filterID)
);

create table MAIL_CONTENT_FILTER(
    contentfilterID int not NULL UNIQUE,
    pattern varchar(1024) not NULL,
    domainID int not NULL,
    filterID int not NULL,
    clientID int not NULL,
    actionID int not null,
    foreign key(actionID) references ACTIONS(actionID),
    foreign key(clientID) references CLIENT_ADMIN(clientID),
    foreign key(filterID) references FILTERS(filterID),
    foreign key(domainID) references MAIL_DOMAIN(domainID),
    primary key(contentfilterid)
);

create table CLIENT_CONTROL_DOMAIN(
    controlID int not NULL UNIQUE,
    clientID int not NULL,
    domainID int not NULL,
    canchange_admins varchar(1) default 'y',
    canchange_domainstatus varchar(1) default 'n',
    canchange_users varchar(1) default 'y',
    foreign key (clientID) REFERENCES CLIENT_ADMIN(clientID),
    foreign key (domainID) REFERENCES MAIL_DOMAIN(domainID),
    check (canchange_admins='y' or canchange_admins='n'),
    check (canchange_domainstatus='y' or canchange_domainstatus='n'),
    check (canchange_users='y' or canchange_users='n')
);
