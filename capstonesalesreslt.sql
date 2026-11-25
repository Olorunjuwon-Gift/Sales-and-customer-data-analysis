CREATE TABLE capstonesales_data (
 	orderid integer,
    customerid text,
    product text,
    region text,
    orderdate date,
    quantity numeric,
    unitprice numeric,
    sales numeric)

select * from capstonesales_data
---total sales for each product category---
select sum (sales) as totalsales, product from capstonesales_data
group by product
order by totalsales DESC

---number of sales transactions in each region---
select region, count (sales) as numberofsales from capstonesales_data
group by region
order by numberofsales

---highest-selling product by total sales value---
select product, sum (sales) as totalsales from capstonesales_data
group by product
order by totalsales
limit 1

---total revenue per product---
select product, sum (sales) as totalrevenue
from capstonesales_data 
group by product
order by totalrevenue desc

---monthly sales totals for the current year---
select extract (month from orderdate) as month,
to_char (orderdate, 'month') as monthname,
sum (sales) as monthlysalestotal
from capstonesales_data where extract (year from orderdate) = '2024'
group by month, monthname
order by month asc

---top 5 customers by total purchase amount---
select customerid, sum (sales) as totalpurchaseamt from capstonesales_data
group by customerid
order by totalpurchaseamt desc
limit 5

---percentage of total sales contributed by each region---
select region, sum (sales) as totalsales, round (
sum (sales) * 100 / sum (sum(sales)) over (),2) as percentagetotal
from capstonesales_data
group by region
order by percentagetotal desc

---products with no sales in the last quarter---
select distinct product from capstonesales_data
where product not in (select product from capstonesales_data 
                      where orderdate >= '2023-05-31'
                       and orderdate <= '2024-08-31')
order by product

|| (select  distinct orderdate from postgres.capstonesales_data order by orderdate asc)
		
		---OR---
select distinct product from capstonesales_data 
where product not in (select distinct product from capstonesales_data 
where orderdate>= date_trunc ('quarter', (select max(orderdate) from capstonesales_data) ) )
                
				---OR---
select product, max(orderdate) as lastsalesdata from capstonesales_data
group by  product 
having max(orderdate) < date_trunc ('quarter', (select max(orderdate) from capstonesales_data))
order by lastsalesdata desc;
