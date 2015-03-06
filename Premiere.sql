/*
   Author: Nagarajan Prabakar 2/10/06

   Phase 1: Drop all five tables of Premiere database if they exist
    in the correct sequence without violating foreign key constraints
*/

-- if "OrderLine" table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'OrderLine')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table OrderLine
GO

-- if "Part" table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'Part')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table Part
GO

-- if "Orders" table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'Orders')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table Orders
GO

-- if "Customer" table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'Customer')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table Customer
GO

-- if "Rep" table already exists, remove the table
if exists
    (select *
     from sysobjects
     where id = object_id(N'Rep')
           and OBJECTPROPERTY(id, N'IsUserTable') = 1
    )
  drop table Rep
GO


/* Phase 2: Create all five empty tables of Premiere database */

-- create a new empty table Rep
CREATE TABLE Rep
( RepNum CHAR(2) not null,
  LastName CHAR(15),
  FirstName CHAR(15),
  Street CHAR(15),
  City CHAR(15),
  State CHAR(2),
  Zip CHAR(5),
  Commission DECIMAL(7,2),
  Rate DECIMAL(3,2),
  constraint Rep_pk
    primary key(RepNum)
);

-- create a new empty table Customer
CREATE TABLE Customer
( CustomerNum CHAR(3) not null,
  CustomerName CHAR(35) not null,
  Street CHAR(15),
  City CHAR(15),
  State CHAR(2),
  Zip CHAR(5),
  Balance DECIMAL(8,2),
  CreditLimit DECIMAL(8,2),
  RepNum CHAR(2),
  constraint Cust_pk
    primary key(CustomerNum),
  constraint CustRep_fk
    foreign key (RepNum) references Rep(RepNum)
);

-- create a new empty table Orders
CREATE TABLE Orders
( OrderNum CHAR(5) not null,
  OrderDate CHAR(11),
  CustomerNum CHAR(3),
  constraint Orders_pk
    primary key(OrderNum),
  constraint OrdersCust_fk
    foreign key (CustomerNum) references Customer(CustomerNum)
);

-- create a new empty table Part
CREATE TABLE Part
( PartNum CHAR(4) not null,
  Description CHAR(15),
  OnHand DECIMAL(4,0),
  Class CHAR(2),
  Warehouse CHAR(1),
  Price DECIMAL(6,2),
  constraint Part_pk
    primary key(PartNum)
);

-- create a new empty table OrderLine
CREATE TABLE OrderLine
( OrderNum CHAR(5) not null,
  PartNum CHAR(4) not null,
  NumOrdered DECIMAL(3,0),
  QuotedPrice DECIMAL(6,2),
  constraint OLine_pk
    primary key(OrderNum, PartNum),
  constraint OLineOrders_fk
    foreign key (OrderNum) references Orders(OrderNum),
  constraint OLinePart_fk
    foreign key (PartNum) references Part(PartNum)
);


/* Phase 3: Add rows of data to each of these five empty tables of Premiere DB*/

-- Insertion of three Rep rows
INSERT INTO Rep
VALUES
('20','Kaiser','Valerie','624 Randall','Grove','FL','33321',20542.50,0.05);
INSERT INTO Rep
VALUES
('35','Hull','Richard','532 Jackson','Sheldon','FL','33553',39216.00,0.07);
INSERT INTO Rep
VALUES
('65','Perez','Juan','1626 Taylor','Fillmore','FL','33336',23487.00,0.05);

-- Insertion of ten Customer rows
INSERT INTO Customer
VALUES
('148','Al''s Appliance and Sport','2837 Greenway','Fillmore','FL','33336',6550.00,7500.00,'20');
INSERT INTO Customer
VALUES
('282','Brookings Direct','3827 Devon','Grove','FL','33321',431.50,10000.00,'35');
INSERT INTO Customer
VALUES
('356','Ferguson''s','382 Wildwood','Northfield','FL','33146',5785.00,7500.00,'65');
INSERT INTO Customer
VALUES
('408','The Everything Shop','1828 Raven','Crystal','FL','33503',5285.25,5000.00,'35');
INSERT INTO Customer
VALUES
('462','Bargains Galore','3829 Central','Grove','FL','33321',3412.00,10000.00,'65');
INSERT INTO Customer
VALUES
('524','Kline''s','838 Ridgeland','Fillmore','FL','33336',12762.00,15000.00,'20');
INSERT INTO Customer
VALUES
('608','Johnson''s Department Store','372 Oxford','Sheldon','FL','33553',2106.00,10000.00,'65');
INSERT INTO Customer
VALUES
('687','Lee''s Sport and Appliance','282 Evergreen','Altonville','FL','32543',2851.00,5000.00,'35');
INSERT INTO Customer
VALUES
('725','Deerfield''s Four Seasons','282 Columbia','Sheldon','FL','33553',248.00,7500.00,'35');
INSERT INTO Customer
VALUES
('842','All Season','28 Lakeview','Grove','FL','33321',8221.00,7500.00,'20');

-- Insertion of seven Orders rows
INSERT INTO Orders
VALUES
('21608','20-OCT-2007','148');
INSERT INTO Orders
VALUES
('21610','20-OCT-2007','356');
INSERT INTO Orders
VALUES
('21613','21-OCT-2007','408');
INSERT INTO Orders
VALUES
('21614','21-OCT-2007','282');
INSERT INTO Orders
VALUES
('21617','23-OCT-2007','608');
INSERT INTO Orders
VALUES
('21619','23-OCT-2007','148');
INSERT INTO Orders
VALUES
('21623','23-OCT-2007','608');

-- Insertion of ten Part rows
INSERT INTO Part
VALUES
('AT94','Iron',50,'HW','3',24.95);
INSERT INTO Part
VALUES
('BV06','Home Gym',45,'SG','2',794.95);
INSERT INTO Part
VALUES
('CD52','Microwave Oven',32,'AP','1',165.00);
INSERT INTO Part
VALUES
('DL71','Cordless Drill',21,'HW','3',129.95);
INSERT INTO Part
VALUES
('DR93','Gas Range',8,'AP','2',495.00);
INSERT INTO Part
VALUES
('DW11','Washer',12,'AP','3',399.99);
INSERT INTO Part
VALUES
('FD21','Stand Mixer',22,'HW','3',159.95);
INSERT INTO Part
VALUES
('KL62','Dryer',12,'AP','1',349.95);
INSERT INTO Part
VALUES
('KT03','Dishwasher',8,'AP','3',595.00);
INSERT INTO Part
VALUES
('KV29','Treadmill',9,'SG','2',1390.00);

-- Insertion of nine OrderLine rows
INSERT INTO OrderLine
VALUES
('21608','AT94',11,21.95);
INSERT INTO OrderLine
VALUES
('21610','DR93',1,495.00);
INSERT INTO OrderLine
VALUES
('21610','DW11',1,399.99);
INSERT INTO OrderLine
VALUES
('21613','KL62',4,329.95);
INSERT INTO OrderLine
VALUES
('21614','KT03',2,595.00);
INSERT INTO OrderLine
VALUES
('21617','BV06',2,794.95);
INSERT INTO OrderLine
VALUES
('21617','CD52',4,150.00);
INSERT INTO OrderLine
VALUES
('21619','DR93',1,495.00);
INSERT INTO OrderLine
VALUES
('21623','KV29',2,1290.00);

/* End of Premiere database script */
