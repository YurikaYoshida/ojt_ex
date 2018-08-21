/****  日付間ランクごとユーザ推移関数  ****/
drop function if exists fnc_rfm_trans(in date, in date, out rfm1 text, out rfm2 text, out count bigint);
create or replace function fnc_rfm_trans(in date, in date, out rfm1 text, out rfm2 text, out count bigint) 
returns setof record as $$

    with join_rank as
    (
        select    -- 1. 関数を呼び出して２つの結果結合
            fnc1.user_id
          , fnc1.rfm as rfm1
          , fnc2.rfm as rfm2
        from (select * from fnc_rfm($1)) as fnc1
        inner join (select * from fnc_rfm($2)) as fnc2
        on fnc1.user_id = fnc2.user_id
    )
    
    select    -- 2. ユーザ推移算出
        rfm1
      , rfm2
      , count(*)
    from join_rank
    group by rfm1, rfm2
    order by rfm1, rfm2
    ;
    
$$ language sql;



/****  関数呼び出し例  ****/
select *
from fnc_rfm_trans('2017-01-01', '2017-07-01');