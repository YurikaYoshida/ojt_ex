/** film_id���Ƃ̌���ƃJ�e�S���[ **/
select film.film_id, lang.name as lang_name, c.name as cate_name
from film
inner join film_category as fc
  on film.film_id = fc.film_id
inner join category as c
  on fc.category_id = c.category_id
inner join language as lang
  on film.language_id = lang.language_id
;




/**  �ڋqid���Ƃ̊X�ƍ�  **/
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




/**  ���ꂲ�Ƃ̖{��  **/
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




/**  ���t�����Ƃ̃����^���_���A�ڋq���A���v���z  **/
select
  cast(rental_date as date)
  ,count(rental_date) as cnt_num -- �_��
  ,count(distinct rental.customer_id) as cnt_cust -- �ڋq��  
  ,sum(amount)
from
  rental
left join payment as pay
  on rental.rental_id = pay.rental_id
group by cast(rental_date as date)
order by cast(rental_date as date) desc
;




/**  ����̕��όڋq���ƁA�S�Ă̊��Ԃ̍��v���z  **/
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



/** �J�e�S���ʂ̍݌ɐ� **/
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





