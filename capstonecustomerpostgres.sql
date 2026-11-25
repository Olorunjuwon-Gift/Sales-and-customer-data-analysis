CREATE TABLE capstonecustomer_data (
    customerid text,
    customername text,
    region text,
    subscriptiontype text,
    subscriptionstart text,
    subscriptionend text,
    canceled text,
    revenue text,
    duration text
)

ALTER TABLE CAPSTONECUSTOMER_DATA
ALTER COLUMN customerid TYPE INT USING CUSTOMERID::INT,
ALTER COLUMN CUSTOMERNAME TYPE VARCHAR (100),
ALTER COLUMN region TYPE VARCHAR (50),
ALTER COLUMN subscriptiontype TYPE VARCHAR (50),
ALTER COLUMN subscriptionstart TYPE DATE USING TO_DATE (subscriptionstart, 'mm/dd/yyyy'),
ALTER COLUMN subscriptionend TYPE DATE USING TO_DATE (subscriptionend, 'mm/dd/yyyy'),
ALTER COLUMN canceled TYPE BOOLEAN USING canceled::boolean,
ALTER COLUMN revenue TYPE NUMERIC USING revenue::numeric,
ALTER COLUMN duration TYPE INT USING duration::INT;

ALTER TABLE CAPSTONECUSTOMER_DATA
ALTER COLUMN revenue TYPE NUMERIC USING replace(revenue, ',', '') ::numeric;

---total number of customers from each region---
select region, count(customerid) as totalno_ofcustomers from postgres.capstonesales_data
group by region

---most popular subscription type by the number of customers--- 
select region, count (customerid) as totalcustomers from capstonecustomer_data
group by region
order by totalcustomers desc

---most popular subscription type by the number of customers---
select subscriptiontype, count(customerid) as customerbysbs
from capstonecustomer_data 
GROUP by subscriptiontype
order by customerbysbs desc

---customers who canceled their subscription within 6 months---
select count (customerid) from capstonecustomer_data where canceled = 'true' 
and duration > 180 

--- average subscription duration for all customers---
select customerid, customername, avg (duration) as avgduration from capstonecustomer_data 
group by customerid, customername
order by avgduration 

---customers with subscriptions longer than 12 months---
select customerid, customername, duration from capstonecustomer_data
   where duration > 366 

---total revenue by subscription type---
select sum (revenue) as totalrevenue, subscriptiontype from capstonecustomer_data
group by subscriptiontype
order by totalrevenue desc

--- top 3 regions by subscription cancellations---
select distinct region 
from capstonecustomer_data where canceled ='true'
limit 3

select distinct region 
from capstonecustomer_data where canceled ='false'
limit 3

---total number of active and canceled subscriptions---
select count (customerid) as customers from capstonecustomer_data
where canceled = 'false'
select count (customerid) as customers from capstonecustomer_data
where canceled = 'true'







