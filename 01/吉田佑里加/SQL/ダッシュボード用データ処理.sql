/****  ���[�UID�����o��  ****/
select user_id
from ro_data
group by user_id
order by user_id;


/****  �󒍓������o��  ****/
select order_date as order_date_2
from ro_data
group by order_date
order by order_date;


/****  ���t���ƂɃ����N�t��  ****/
select 
    *
  , case when days<=30 and order_num>=7 and amount_acc>=50000 then '�����NA'
         when days<=60 and order_num>=5 and amount_acc>=30000 then '�����NB'
         when days<=120 and order_num>=3 and amount_acc>=10000 then '�����NC'
    else '�����ND' end as RFM_2
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