/****  ユーザID抜き出し  ****/
select user_id
from ro_data
group by user_id
order by user_id;


/****  受注日抜き出し  ****/
select order_date as order_date_2
from ro_data
group by order_date
order by order_date;


/****  日付ごとにランク付け  ****/
select 
    *
  , case when days<=30 and order_num>=7 and amount_acc>=50000 then 'ランクA'
         when days<=60 and order_num>=5 and amount_acc>=30000 then 'ランクB'
         when days<=120 and order_num>=3 and amount_acc>=10000 then 'ランクC'
    else 'ランクD' end as RFM_2
from
  (
      select *
          , order_date - lag(order_date, 1, order_date) over(partition by user_id order by order_date) as days
          , row_number() over(partition by user_id order by order_date) as order_num
          , sum(order_amount) over(partition by user_id order by order_date) as amount_acc
      from ro_data
      order by user_id, order_date
    )as users
;