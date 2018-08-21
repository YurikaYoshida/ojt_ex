/**  テーブル削除  **/
drop table ro_data;
/**  テーブル作成  **/
CREATE TABLE ro_data (
user_id int,
order_date date,
order_amount int
);

/**  ファイルのインポート  **/
copy ro_data
from 'C:\Program Files\PostgreSQL\9.4\ojt_data\ro_data.csv'
with (format csv, header true)
;

