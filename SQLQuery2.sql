CREATE DATABASE Charlies_Chocolate_Factory;
Use Charlies_Chocolate_Factory;
--CREATE SCHEMA Product;
--CREATE SCHEMA Supplier;
--CREATE SCHEMA Component;

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

	PRIMARY KEY ([supp_id], [comp_id])

	--foreign key (supp_id) references product (supp_id),
	--foreign key [comp_id] references component ([comp_id])
);


ALTER TABLE Prod_Comp ADD CONSTRAINT FK_product FOREIGN KEY (prod_id) REFERENCES Product (prod_id)
ON UPDATE NO ACTION
ON DELETE CASCADE;
ALTER TABLE Prod_Comp ADD CONSTRAINT FK_component FOREIGN KEY (comp_id) REFERENCES Component (comp_id)
ON UPDATE NO ACTION
ON DELETE CASCADE;

ALTER TABLE Comp_Supp ADD CONSTRAINT FK_supplier FOREIGN KEY (supp_id) REFERENCES Supplier (supp_id)
ON UPDATE NO ACTION
ON DELETE CASCADE;

ALTER TABLE Comp_Supp ADD FOREIGN KEY (comp_id) REFERENCES Component (comp_id);


DROP TABLE IF EXISTS [Prod_Comp];
DROP TABLE IF EXISTS [Comp_Supp];
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Component;
DROP TABLE IF EXISTS Product;


