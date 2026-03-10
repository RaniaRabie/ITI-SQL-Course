use SD

/* --DDL */
select * from Employee
insert into Employee(ssn)
values(125)
create table location
(
Dnum int,
location varchar(50) 
)
-- test اسمه table عملت كريت ل 
create table test(
testId int primary key,
testName int
)

select * from test

/* جديد column ضيفت table عملت تعديل ف ال */
alter table test add sal int

/* testName بتاع datatype عدلت في  table عملت تعديل في ال  */
alter table test alter column testName varchar(50)

/* خالص sal column هنا مسحت ال */
alter table test drop column sal
/* 
	بتاعته ومبقاش ليه وجود خالص metadat نفسه خالص هو وال table مسحت ال
	structure ب table مسحت ال 
*/
drop table test

-------------------------------------

/* --DML     */
-- insert, update, delete

-- لازم هنا احط كل القيم بالترتيب
insert into Employee 
values(128, 'ahmed' , 'rabie', null, null, null, null, null)

-- لقيم معينة بالترتيب اللي تحبه insert  بالطريقة دي ممكن اعمل 
insert into Employee ( fName, lName, ssn)
values('mahmoud' , 'rabie', 129)

-- insert constructor --> مع بعض row لكذا insert بتعمل
insert into Employee ( fName, lName, ssn)
values
('mahmoud' , 'rabie', 132),
('amal' , 'rabie', 130),
('mohammed' , 'rabie', 131)

-- omar ب rows  في كل lname هنا هيخلي كل 
update Employee 
set lname = 'omar'

-- 125 بتاعخ ب ssn الل emp لل update عشان اعمل where هنا هستخدم
update Employee 
set fname = 'omar' where ssn = 125

/* 
	بس يكون ليها معني where من غير update ممكن عادي نعمل 
	ب 1 Employee يعني هنا زود كل اعمار 
*/
update Employee 
set age+=1


/* 
	rows بتمسح delete المفروض 
	كله table بتاع rows بالظبط فهو مسح كل ال rows فبما اني مقولتلوش تمسح انهي
	لسه موجودين structure, table بس
*/
delete from Employee

--  ssn = 132 اللي row مسحنا 
delete from Employee 
where ssn=132



-- **DQL

-- employee اللي في columns يعرض كل 
select * 
from Employee

-- ssn, fName, lName معينة cloumns يعرض 
select ssn, fName, lName 
from Employee

-- where معينة عايزة اعرضها باستخدام rows حددت 
select ssn, fName, lName, age 
from Employee 
where age>=22

/* 
	pk بترتيب hard disk بتتخرن علي by defualt الداتا 
	معين column عشان ارتب الدتا وانا بعرضها ب order by ممكن استخدم 
	وهيا بتتعرض بس memory لا هيا اترتبت في hard disk وخلي بالك مش معني كده انها اترتبت علي 
*/
select * 
from Employee
order by age --desc

/*
	hard disk ملهاش اي تأثير عل select        
	alias name => fullName واحد واديتله column ك fName, lName ففي المثال اللي تحت ده انا عرضت 
	لا كل ده حصل مؤقت في الميوري وقت الرن fullName اسمه hard disk علي column مش معني كده ان بقي في   
*/

select fName + ' ' +  lName as fullName
from Employee 

-- select fullName from Employee   XXXXXXXXX

select * 
from Employee

-- كتير بتظهر معايا  null values  في 
-- طب لو مش عايز اعرضها؟

/*
select *
from Employee 
where age != NUll	XXXXXXXX
-- وبتقارن بيها value كأنها null طبعا ده مينفعش لانك اعتبرت ال
-- null is not a value وده مينفعش ومش موجود لان values < null , values > null وان ينفع نقول هات 
*/

-- is null, is not null => null values اللي هنستخدمها عشان نتعامل مع key words دول ال
select *
from Employee 
where age is null

-- distinct =>  (show unique values only) المتكرر remove و order بتعمل
-- او اللي مش مكررين unique ال firstName هعرض ال
select distinct fName
from Employee

-- لوحده row بتطبق علي كل where غلط لان lgically ده مش هيطلع ناتج لانه query ال run لما نيجي ن
-- ومفيش حد هيبقي اسمه امل ومحمود في نفس الوقت 
select *
from Employee
where fName = 'amal' and fName = 'mahmoud'

-- ليها معني logically في حاجات and الصح استخدام
-- هنا مثلا بقوله هات الناس االلي اسمها احمد وسنها فوق 25 سنة
select *
from Employee
where fName = 'ahmed' and age > 25

-- display rage of values using and
select *
from Employee
where age > 22 and age <= 31 

-- between => display rage of values 
select *
from Employee
where age between 22 and 31 -- 22, 31 included

-- or 
select *
from Employee
where fName = 'amal' or fName = 'mahmoud'

-- in(val1, val2, ..., valn) => كتير values علي or ولو عايزين نعمل
select *
from Employee
where fName in('amal', 'mahmoud', 'omar')