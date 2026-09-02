create database amazon;

-- Task 1 
-- ER Diagram

-- Task 2
-- Primary Key and Foreign Key

-- Task 3 
-- Retrieve all customers from a specific city.  
-- Fetch all products under the "Fruits" category. 

select * from amazon.customers
where city like "Lucasfurt"; 

select * from amazon.products
where category ="Fruits";

-- task 4 Write DDL statements to recreate the Customers table with the following  constraints:  
-- CustomerID as the primary key.  
-- Ensure Age cannot be null and must be greater than 18.  
-- Add a unique constraint for Name.  

alter table amazon.customers change customerid customerid varchar(150) primary key;
alter table amazon.customers modify age int not null check (age>18);
alter table amazon.customers add Name varchar(100) unique;

-- Task 5: Insert 3 new rows into the Products table using INSERT statements. 

insert into amazon.products(ProductID,productName,Category,SubCategory,PricePerUnit,StockQuantity,SupplierID)
values("P1001","Cream Bun","Bakery","Sub-Bakery-1",300,359,"S1001"),
("P1002","Butter Bun","Bakery","Sub-Bakery-2",500,550,"S1002"),
("P1003","Fruit Bun","Bakery","Sub-Bakery-3",140,345,"S1003");

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID.

SELECT*FROM amazon.products;

select * from amazon.products;
set sql_safe_update=0;
update amazon.products SET StockQuantity=600
where productID="0006853b-74cb-44a2-91ed-699aa31c5b5b";

-- Task 7 : Delete a supplier from the Suppliers table where their city matches a specific value.

select * from amazon.suppliers;
delete from amazon.suppliers
where city="South_Tyler";

-- Task 8: Use SQL constraints to:
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").

select * from amazon.reviews;
alter table amazon.reviews add check(rating between 1 and 5);

select * from amazon.customers;
alter table amazon.customers modify primemember varchar(100) default"10";

-- Task 9: Write queries using:
-- 1. WHERE clause to find orders placed after 2024-01-01.
select * from amazon.orders
where orderdate>"2024-01-01";

-- 2. HAVING clause to list products with average ratings greater than 4.
select p.ProductName,r.productID,avg(r.Rating) from amazon.reviews as r
right join amazon.products as p
on p.productID=r.productID
group by p.ProductName,r.productID
having avg(r.Rating)>4;

-- 3. GROUP BY and ORDER BY clauses to rank products by total sales.
select OrderID,CustomerID,sum(OrderAmount) as totalsale from amazon.orders
group by OrderID,CustomerID
order by sum(OrderAmount)desc;

-- Task 10: Identifying High-Value Customers
-- Amazon Fresh wants to identify top customers based on their total spending. We will:
-- 1. Calculate each customer's total spending.
select c.name, o.CustomerID,sum(o.orderAmount) as total_amount from amazon.orders as o
right join amazon.customers as c
on o.CustomerID=c.CustomerID
group by c.Name,o.CustomerID;

-- 2. Rank customers based on their spending.
select CustomerID,sum(OrderAmount+DeliveryFee),Rank()
over(order by sum(OrderAmount+DeliveryFee)desc) as total_amount from amazon.Orders
group by CustomerID;

-- 3. Identify customers who have spent more than ₹5,000.
select c.Name,c.CustomerID,sum(o.OrderAmount) as totalamount
from amazon.customers as c
left join amazon.orders as o
on c.CustomerID=o.CustomerID
group by c.Name,c.CustomerID
having sum(o.OrderAmount)>5000
order by sum(o.OrderAmount)desc;

-- Task 11: Use SQL to:
-- Join the Orders and OrderDetails tables to calculate total revenue per order.
select c.orderID,o.CustomerID,sum(o.orderAmount) from amazon.orders as o
right join amazon.order_details as c
on o.OrderID=c.OrderID
group by c.OrderID,o.CustomerID;

-- Identify customers who placed the most orders in a specific time period.
select * from amazon.orders;
select c.Name,o.CustomerID,COUNT(o.customerID)as most_orders from amazon.orders as o
 right join amazon.customers as c
 on c.CustomerID=o.CustomerID
 Where Orderdate="2025-01-01"
 group by c.Name,o.CustomerID
 order by most_orders desc;

-- Find the supplier with the most products in stock.
select SupplierID,sum(Stockquantity) as total_stock from amazon.products
group by SupplierID
order by total_stock desc
limit 1;

-- Task 12: Normalize the Products table to 3NF:
-- Separate product categories and subcategories into a new table.

create table amazon.categories(ProductID VARCHAR(100),ProductName text,Category text);
insert into amazon.categories(ProductID,ProductName,Category)
values("0006853b-74cb-44a2-91ed-699aa31c5b5b","Particularly Baker","Bakery"),
("0219aafa-5dbc-4d92-acd9-8a78b4158651","Enter Dair","Dairy"),
("0297061c-1241-4540-ac99-ac6a44fa507e","We Bake","Bakery"),
("02c7c358-da33-4586-8e32-5e459b7394f","Early Snack","Snacks"),
("030ff542-d5f3-4387-9654-90ae0e38702c","Western Mea","Meat");

create table amazon.sub_categories(ProductID VARCHAR(100),SubCategory text);
insert into amazon.sub_categories(ProductID,SubCategory)
values("0006853b-74cb-44a2-91ed-699aa31c5b5b","Sub-Bakery-1"),
("0219aafa-5dbc-4d92-acd9-8a78b4158651","Sub-Dairy-3"),
("0297061c-1241-4540-ac99-ac6a44fa507e","Sub-Bakery-4"),
("02c7c358-da33-4586-8e32-5e459b7394f","Sub-Snacks-1"),
("030ff542-d5f3-4387-9654-90ae0e38702c","Sub-Meat-4");

-- Create foreign keys to maintain relationships.

-- Task 13: Write a subquery to:
-- Identify the top 3 products based on sales revenue.

select p.productID,s.total_sales from amazon.order_details as p
join(select productID,SUM(PricePerUnit*stockQuantity) as total_sales
from amazon.products
group by ProductID) as s
on p.ProductID=s.ProductID
order by s.total_sales desc
limit 3;

-- Find customers who haven’t placed any orders yet.
select (select CustomerID from amazon.orders
where OrderID is null),name from amazon.customers;

-- Task 14: Provide actionable insights:
-- Which cities have the highest concentration of Prime members?
select distinct city,count(PrimeMember) as count from amazon.customers
group by city
order by count desc;

-- What are the top 3 most frequently ordered categories?
select category,count(productID) AS ORDER_COUNT FROM amazon.products
group by Category
ORDER BY COUNT(ProductID)DESC
limit 3;
