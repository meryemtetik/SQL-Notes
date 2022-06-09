CREATE DATABASE Manufacturer;
Use Manufacturer;

CREATE TABLE Product(
	prod_id int PRIMARY KEY identity(1,1) not null,
	prod_name nvarchar(50) null,
	quantity int null
);
CREATE TABLE Supplier(
	supp_id int PRIMARY KEY,
	supp_name nvarchar(50),
	supp_location nvarchar(50),
	supp_country nvarchar(50),
	is_active bit
);
CREATE TABLE Component(
	comp_id int PRIMARY KEY,
	comp_name nvarchar(50),
	[description] nvarchar(50),
	quantity_comp INT
);
CREATE TABLE [Prod_Comp](
	[prod_id] int foreign key references product (prod_id),
	[comp_id] int foreign key references component ([comp_id]),
	quantity_comp int,
	PRIMARY KEY ([prod_id], [comp_id])
);
	
CREATE TABLE [Comp_Supp](
	[supp_id] int ,
	[comp_id] int ,
	order_date date,
	quantity int,
	PRIMARY KEY ([supp_id], [comp_id]),
	foreign key (supp_id) references Supplier (supp_id),
	foreign key (comp_id) references component (comp_id)
);



DROP TABLE IF EXISTS [Prod_Comp];
DROP TABLE IF EXISTS [Comp_Supp];
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Component;
DROP TABLE IF EXISTS Product;