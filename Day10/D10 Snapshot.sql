/*		 <<<<<... snapshot ...>>>>>> */

-- snapshot =>  ولكنها اخف بكتير backup حاجة تشبه
--			- read only database

/*
	؟filename مين
	   وده منطقي ليه؟ .mdf, .ldf files ولكن ملهاش HD علي file ليها database زيها زي اي snapshot ال 
	   insert, update, delete ف مش هيحصل عليها readonly database لانها .ldf file الطبيعي ان ميبقاش ليها
	   .ss عندها فايل واحد بس snapshot وبالتالي ال 

	   ؟name مين
			HD اللي عندك علي .mdf file اسم
			ايوه اجيب منين؟
				right click on database name(for ex: TestBackup) => properties => files => .mdf, .ldf files بيظهر اسم
			؟.mdf file ليه بنحتاج  اسم
				يشاور عليه snapshot عشان نخلي .mdf علي الداتا الاصلية ف احنا بنحتاج اسم pointer بتعمل snapshot مش احنا قولنا ان
*/


create database test_backup_snap
on
(
    name = TestBackup,
    filename = 'E:\.Net ITI Training\Backend\Database ITI - SQL Server ITI - eng-rami\myDBs\test_backup_snap.ss'
)
as snapshot of TestBackup;

-- اللي فوق ده عمل حاجتين query ال
-- file on HD => test_backup_snap.ss
-- database in folder Database Snapshots => test_backup_snap


-- هيطلعو نفس الناتج 
-- امتي هيختلفو لو روحت للداتابيز الاصلية وعدلت فيها
use TestBackup
select * from Employee

use test_backup_snap
select * from Employee

-- وعدلت فيها TestBackup بعد ما روحت ل
use TestBackup
select * from Employee

use test_backup_snap
select * from Employee

/*
 ؟backup عشان ارجع بيها الداتا تاني زي snapshot السؤال هنا ينفع استخدم
	تاني واقول عايزة ارجع الداتا server علي snapshot انما مينفعش انقل ال server ينفع لو احنا علي نفس ال
	not corrupted ولازم تكون الداتا بيز الاصلية 
	ازاي؟
*/
use master

restore database TestBackup
from database_snapshot = 'test_backup_snap'

