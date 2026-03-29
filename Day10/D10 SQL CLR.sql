/* <<<<<... SQL CLR ...<<<<< */ 

-- SQL CLR => SQL Common Language Runtime( C# بتاع )
--			- C# code باستخدام SQL طريقة انك تقدر تعمل الحاجات اللي بتعملها علي

-- 1. enable SQL CLR
sp_configure 'clr_enable', 1
go
reconfigure


-- 1. فعلّي عرض الإعدادات المتقدمة
sp_configure 'show advanced options', 1;
RECONFIGURE;

-- 2. دلوقتي عدّلي clr strict security
sp_configure 'clr strict security', 0;
RECONFIGURE;

/* --------------------- */
use ITI
select dbo.sum2Int(2,3)

create table shapes
(
	_id int,
	_des varchar(20),
	_coord Circle
)

select _des 
from shapes
where _coord.x >= 10

select _id, _des, _coord.x as x, _coord.y as y, _coord.radius as radius
from shapes