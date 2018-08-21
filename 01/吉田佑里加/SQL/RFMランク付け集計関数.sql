/****  ���_RFM�����N�t���֐�  ****/
drop function if exists fnc_rfm(in date, out user_id text, out rfm text);
create or replace function fnc_rfm(in date, out user_id text, out rfm text) 
returns setof record as $$

    with users01 as
    (
        select    -- 2. ���[�U���Ƃɓ����A�����A���z���Z�o
            user_id
          , $1-max(order_date) as days
          , count(user_id)
          , sum(order_amount)
        from 
          ( select *    -- 1. ���Ԏw��
            from ro_data
            where order_date <= $1    /* ���_ */
          )as period
        group by user_id
    )
    
    select    -- 3. RFM�����N�t��
        user_id
      , case when days<=30 and count>=7 and sum>=50000 then '�����NA'
             when days<=60 and count>=5 and sum>=30000 then '�����NB'
             when days<=120 and count>=3 and sum>=10000 then '�����NC'
        else '�����ND' end as RFM
    from users01
    
    ;

$$ language sql;



/****  RFM�����N���ƏW�v�֐�  ****/
drop function if exists fnc_rfm_cnt(in date, out rfm text, out count bigint);
create or replace function fnc_rfm_cnt(in date, out rfm text, out count bigint) 
returns setof record as $$

    select    -- 4. �����N���Ƃ̐l���W�v
        rfm
      , count(*)
    from     /*  �֐��Ăяo�� */
        (select * from fnc_rfm($1)) as fnc
    group by rfm 
    order by rfm  
    ;
    
$$ language sql;



/****  �֐��Ăяo����  ****/
select *
from fnc_rfm_cnt('201-01-01');