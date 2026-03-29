-- types of Insert Statement
--	1. simple Insert
--	2. insert Constructor => insert many rows at the same time
--	3. Insert based on select => اخر table في insert اعمل بيها table اني اخد داتا من
--	4. Insert based on execute => SP اللي بستخدمها مع
--	5. bluk Insert => هنتكلم عنها النهارده

/*		 <<<<<... bluk Insert ...>>>>>> */
Use TestBulkInsert

--  bluk Insert => table ارميها في file يعني اخد داتا من 

bulk insert Student
from 'E:\.Net ITI Training\Backend\Database ITI - SQL Server ITI - eng-rami\myDBs\BulkInsert.txt'
with(fieldterminator = ',')

