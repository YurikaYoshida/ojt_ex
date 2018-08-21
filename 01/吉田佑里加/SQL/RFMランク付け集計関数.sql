/****  時点RFMランク付け関数  ****/
drop function if exists fnc_rfm(in date, out user_id text, out rfm text);
create or replace function fnc_rfm(in date, out user_id text, out rfm text) 
returns setof record as $$

    with users01 as
    (
        select    -- 2. ユーザごとに日数、件数、金額を算出
            user_id
          , $1-max(order_date) as days
          , count(user_id)
          , sum(order_amount)
        from 
          ( select *    -- 1. 期間指定
            from ro_data
            where order_date <= $1    /* 時点 */
          )as period
        group by user_id
    )
    
    select    -- 3. RFMランク付け
        user_id
      , case when days<=30 and count>=7 and sum>=50000 then 'ランクA'
             when days<=60 and count>=5 and sum>=30000 then 'ランクB'
             when days<=120 and count>=3 and sum>=10000 then 'ランクC'
        else 'ランクD' end as RFM
    from users01
    
    ;

$$ language sql;



/****  RFMランクごと集計関数  ****/
drop function if exists fnc_rfm_cnt(in date, out rfm text, out count bigint);
create or replace function fnc_rfm_cnt(in date, out rfm text, out count bigint) 
returns setof record as $$

    select    -- 4. ランクごとの人数集計
        rfm
      , count(*)
    from     /*  関数呼び出し */
        (select * from fnc_rfm($1)) as fnc
    group by rfm 
    order by rfm  
    ;
    
$$ language sql;



/****  関数呼び出し例  ****/
select *
from fnc_rfm_cnt('201-01-01');