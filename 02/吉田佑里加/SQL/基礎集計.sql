/** film_idごとの言語とカテゴリー **/
select film.film_id, lang.name as lang_name, c.name as cate_name
from film
inner join film_category as fc
  on film.film_id = fc.film_id
inner join category as c
  on fc.category_id = c.category_id
inner join language as lang
  on film.language_id = lang.language_id
;




/**  顧客idごとの街と国  **/
with address as 
  (  select address_id, city, country
     from (select city_id, city, country 
           from city
           left join country as country
             on city.country_id = country.country_id
          )as city
     right join address as add
       on city.city_id = add.city_id
   )
   
select customer_id, city, country
from customer
left join address as add
  on customer.address_id = add.address_id

;




/**  言語ごとの本数  **/
select
    l.name
  , count(f.language_id)
from
    language as l
left join
    film as f
  on 
    l.language_id = f.language_id
group by
    l.name
;




/**  日付けごとのレンタル点数、顧客数、合計金額  **/
select
  cast(rental_date as date)
  ,count(rental_date) as cnt_num -- 点数
  ,count(distinct rental.customer_id) as cnt_cust -- 顧客数  
  ,sum(amount)
from
  rental
left join payment as pay
  on rental.rental_id = pay.rental_id
group by cast(rental_date as date)
order by cast(rental_date as date) desc
;




/**  一日の平均顧客数と、全ての期間の合計金額  **/
select avg(cnt_cust), sum(total_amount)
from 
  ( select
      cast(rental_date as date)
      ,count(distinct rental.customer_id) as cnt_cust
      ,sum(amount) as total_amount
    from
      rental
    left join payment as pay
      on rental.rental_id = pay.rental_id
    group by cast(rental_date as date)
    order by cast(rental_date as date) desc
   )as cust
;



/** カテゴリ別の在庫数 **/
select cate_name, count(*)
from
  (
    select film.film_id, c.name as cate_name, inventory_id
    from film
    inner join film_category as fc
      on film.film_id = fc.film_id
    inner join category as c
      on fc.category_id = c.category_id
    inner join inventory as inv
      on film.film_id = inv.film_id
   )as film_cate
   
group by cate_name      
order by count(*)

;





