# 1---what is the total amount each customer spent on zomato?
SELECT s.userid,sum(p.price) as total_expenditure FROM sale
as s left join product as p on s.product_id=p.product_id
group by s.userid  order by s.userid;
# 2---how many days has each customer visited zomato?
select userid,count(distinct created_date) from sale group by userid;
# 3---what is the first product purchased by each customer after signup?
select * from sale as s left join users as u 
on s.created_date=u.signup_date;
# conclusion( no customer purchased on the day they have created account  on the app)
with cte1 as (
select * ,rank() over(partition by userid order by created_date ) as first_purchase_date from sale)
select cte1.userid,p.product_name
from cte1 left join product as p on cte1.product_id=p.product_id
where cte1.first_purchase_date=1;

# 4---what is the most purchased item on the menu and ahow many times it is purchased by all customers
with star as (select product_id
 from sale group by product_id order by count(product_id) desc limit 1)
 select userid,count(product_id) as no_of_times_purchased from sale where product_id in (select * from star)
 group by userid  ;
 
 # 5----which item is favourite for each customer?
with star as  (
select userid,product_id,count(product_id) as m from sale group by userid,product_id)
,star2 as (select * ,rank() over(partition by userid order by m desc) as fav_product 
 from star) select userid,product_id,m from star2  where fav_product=1;
 
 # 6---which item was first purchased by a customer after becoming gold memeber?
with star as (select s.*,g.gold_signup_date from sale as s inner join goldusers_signup as g
on (s.userid=g.userid) and (s.created_date>=g.gold_signup_date))
select userid , product_id from (
select * ,rank() over(partition by userid order by created_date) as t from  star )x
where t=1;

# 7--- which item was purchased just b4 becoming a member?
with star as (select * ,rank() over(partition by userid order by created_date desc ) as t
from (select * from (select s.*,g.gold_signup_date from sale  as s inner  join goldusers_signup as  g  on 
s.userid=g.userid and s.created_date<g.gold_signup_date)x) y)
select userid,product_id from star where  t=1;

# 8- what is the total orders and amount spent
#  by each customer before they became a member
with star as (select s.*,p.price from sale as s join goldusers_signup as g on  (s.userid=g.userid) and
(s.created_date<=g.gold_signup_date) join product as p on s.product_id=p.product_id)
select userid , count(distinct created_date) as total_orders,
sum(price)  as total_food_expenditure from star group by userid;
# ********************************
/*Q--9 calculate points collected by each customers and for which product 
 most points have been given till now*/
 with x as(select id,product_id ,sum(price) ,round(sum(price*point)) as total from (select s.userid as id  , p.* from sale as s  join  product as p on
 s.product_id=p.product_id)t 
group by id, product_id order by id ,total desc)
select id  , product_id  ,total_collected_points from (
 select * ,rank() over(partition by id order by total desc) as r,
sum(total) over(partition by id) as total_collected_points from x)y where r=1;
###########
/*Q .10---in the first one year after a customer joins the gold progrma (including their join date) irrespective of what the customer has purchasd they earn 5 zomato points for every 10 rs spent who earned more  1  or 3 and what was theiir points earnings in their first year
*/
select s.*  ,P.PRICE*0.5 from sale as s  join goldusers_signup as g on s.userid=g.userid
and s.created_date>=g.gold_signup_date 
and s.created_date<= DATE_ADD(g.gold_signup_date ,INTERVAL 1 YEAR)
join product as p on s.product_id=p.product_id;
##########
# Q .11-Rank all the transaction of the customers
SELECT * , RANK() OVER(PARTITION BY USERID ORDER BY CREATED_DATE ) AS RT FROM SALE 