-- if owns table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'owns')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table owns
GO

-- if workson table already exists, remove the tablema
if exists
    (select *
     from sysobjects
     where id = object_id(N'workson')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table workson
GO

-- if files table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'flies')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table flies
GO

-- if maintain table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'maintain')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table maintain
GO

-- if service table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'service')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table service
GO

-- if pilot table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'pilot')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table pilot
GO

-- if employee table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'employee')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table employee
GO

-- if corporation table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'corporation')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table corporation
GO

-- if person table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'person')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table person
GO

-- if airplane table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'airplane')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table airplane
GO

-- if planetype table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'planetype')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table planetype
GO

-- if hangar table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'hangar')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table hangar
GO

-- create a new empty table hangar
create table hangar
( hnumber int not null,
  capacity int not null,
  location varchar(15) not null,
  constraint hangpk
    primary key(hnumber)
);

-- create a new empty table planetype
create table planetype
( model varchar(15) not null,
  capacity int not null,
  weight decimal(10,2) not null,
  constraint planepk
	primary key(model)
);

-- create a new empty table airplane
create table airplane
( reg# int not null,
  hnumber int not null,
  model varchar(15) not null,
  constraint airpk
    primary key(reg#),
  constraint airhnfk
    foreign key (hnumber) references hangar(hnumber),
  constraint airtyfk
	foreign key (model) references planetype(model)
);

-- create a new empty table person
create table person
( ssn char(9) not null,
  address varchar(30),
  phone int not null,
  name varchar(30) not null,
  constraint personpk
	primary key(ssn)
);

-- create a new empty table corporation
create table corporation
( name varchar(30) not null,
  address varchar(30),
  phone int not null,
  constraint corppk
	primary key(name)
);

--create a new empty table employee
create table employee
( ssn char(9) not null,
  salary decimal(10,2),
  shift varchar(10),
  constraint emppk
	primary key(ssn),
  constraint empfk
	foreign key (ssn) references person(ssn)
);

--create a new empty table pilot
create table pilot
( ssn char(9) not null,
  lic_num int not null,
  restr varchar(15),
  constraint pilotpk
	primary key(ssn),
  constraint pilotfk
	foreign key (ssn) references person(ssn)
);

--create a new empty table service
create table service
( reg# int not null,
  date char(10) not null,
  workcode varchar(15) not null,
  hours int not null,
  constraint serpk
	primary key (reg#, date, workcode),
  constraint serfk
	foreign key (reg#) references airplane(reg#)
);

--create a new empty table maintain
create table maintain
( ssn char(9) not null,
  date char(10) not null,
  workcode varchar(15) not null,
  reg# int not null,
  constraint mtpk
	primary key (ssn, date, workcode, reg#),
  constraint mtfk
	foreign key (reg#, date, workcode) references service(reg#, date, workcode),
  constraint mtsfk
    foreign key (ssn) references person(ssn),

);

--create a new empty table flies
create table flies
( model varchar(15) not null,
  ssn char(9) not null,
  constraint flipk
	primary key (model, ssn),
  constraint flisfk
    foreign key (ssn) references person(ssn),
  constraint flismfk
    foreign key (model) references planetype(model)
);

--create a new empty table flies
create table workson
( model varchar(15) not null,
  ssn char(9) not null,
  constraint workpk
	primary key (model, ssn),
  constraint worksfk
    foreign key (ssn) references person(ssn),
  constraint workmfk
    foreign key (model) references planetype(model)
);

--create a new empty table owns
create table owns
( reg# int not null,
  name varchar(30),
  ssn char(9),
  pdate char(10) not null,
  constraint ownspk
    primary key(reg#),
  constraint ownrfk
    foreign key(reg#) references airplane(reg#),
  constraint ownnfk
    foreign key(name) references corporation(name),
  constraint ownsfk
    foreign key(ssn) references person(ssn)
);