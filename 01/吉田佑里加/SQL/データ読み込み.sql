/**  �e�[�u���폜  **/
drop table ro_data;
/**  �e�[�u���쐬  **/
CREATE TABLE ro_data (
user_id int,
order_date date,
order_amount int
);

/**  �t�@�C���̃C���|�[�g  **/
copy ro_data
from 'C:\Program Files\PostgreSQL\9.4\ojt_data\ro_data.csv'
with (format csv, header true)
;

