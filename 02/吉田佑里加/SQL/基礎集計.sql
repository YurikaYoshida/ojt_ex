/** film_id‚²‚Æ‚ÌŒ¾Œê‚ÆƒJƒeƒSƒŠ[ **/
select film.film_id, lang.name as lang_name, c.name as cate_name
from film
inner join film_category as fc
  on film.film_id = fc.film_id
inner join category as c
  on fc.category_id = c.category_id
inner join language as lang
  on film.language_id = lang.language_id
;




/**  ŒÚ‹qid‚²‚Æ‚ÌŠX‚Æ‘  **/
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




/**  Œ¾Œê‚²‚Æ‚Ì–{”  **/
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




/**  “ú•t‚¯‚²‚Æ‚ÌƒŒƒ“ƒ^ƒ‹“_”AŒÚ‹q”A‡Œv‹àŠz  **/
select
  cast(rental_date as date)
  ,count(rental_date) as cnt_num -- “_”
  ,count(distinct rental.customer_id) as cnt_cust -- ŒÚ‹q”  
  ,sum(amount)
from
  rental
left join payment as pay
  on rental.rental_id = pay.rental_id
group by cast(rental_date as date)
order by cast(rental_date as date) desc
;




/**  ˆê“ú‚Ì•½‹ÏŒÚ‹q”‚ÆA‘S‚Ä‚ÌŠúŠÔ‚Ì‡Œv‹àŠz  **/
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



/** ƒJƒeƒSƒŠ•Ê‚ÌİŒÉ” **/
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





