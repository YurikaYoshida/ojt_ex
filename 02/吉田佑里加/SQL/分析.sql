/**  データ抜き出し条件  **/
select *
from rental
where cast(rental_date as date) != cast('2006-02-14' as date)
;




/**  売り上げが下がる日とそれ以外の日の借りられるカテゴリランキング  **/
with a as(
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
), over_50 as(

select *
from a
where cnt_num >= 50

), film_cate as(

select film.film_id, c.name as cate_name, cast(rental.rental_date as date)
from film
inner join film_category as fc
  on film.film_id = fc.film_id
inner join category as c
  on fc.category_id = c.category_id
inner join inventory as inv
  on film.film_id = inv.film_id
inner join rental as rental
  on inv.inventory_id = rental.inventory_id
  
)

select cate_name, count(*), rank() over(order by count(*) desc)
from film_cate
inner join over_50 as over_50
  on film_cate.rental_date = over_50.rental_date
group by cate_name
order by count(*) desc


;




/**  日付けごとのレンタル点数、顧客数、合計金額  **/
/**  一人当たりの消費金額  **/
/**  顧客50人以下の日に顧客が平均になった時の合計金額  **/
with data as(
  select *, sum/cnt_cust as pro
  from
    ( select
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
    )as cust
)

select *, pro*after as after_sum
from
  ( select *,
        case when cnt_cust < 50 then 266
        else cnt_cust end as after
    from data
  )as pro

;

