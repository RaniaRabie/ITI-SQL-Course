use Company_SD

/*
-- cross join 
---- cartesian product: 
	resulting table from a CROSS JOIN will have a number of rows equal to
	the product of the number of rows in each of the joined tables
	For example, if TableA has 5 rows and TableB has 10 rows,
	a CROSS JOIN between them will produce a result set with 50 rows.
*/
select Fname , Dname
from Employee , Departments

/*
  * microsoft تجويدة *
		comma(,)	 بدل من استخدام -
	 => cross join	
*/
select Fname , Dname
from Employee cross join Departments


------------------------------------------------------------------------


/*
-- inner join
---- Equi join
	 اللي شغال فيه كل عامل dept ب اسماء العمال مع اسم الlist احنا عايزين نطلع
	 pk , fk عشان نساوي بين where فهنستخدم  
	 where pk = fk 

*/

select Fname , Dname
from Employee , Departments
where Dnum = Dno

/*
-- tables ب اسماء access فشعان نفرق بينهم هنعملهم table بتبقي هيا هيا في كذا col ساعات اسماء ال
	=> Departments.Dnum, Employee.Dno
  * microsoft تجويدة *
	تسهيلا يعني tables لل alias name ممكن نعمل - 
	 => Employee E, Departments D  
		comma(,)	where بدل من استخدام -
	 => inner join	on
*/
select Fname , Dname
from Employee E inner join Departments D  
on D.Dnum = E.Dno


--------------------------------------------------------------------------


/*
-- outer join
	table عادية وجزء زيادة من join عبارة عن  
	مثلا عايزة اعرض كل الناس سواء عندهم اقسام ولا لا
	left => from القريب من  table ال 
	right => البعيد table ال

	-> LEFT OUTER JOIN (or LEFT JOIN):
		This returns all rows from the left table and the matching rows from the right table. 
		If there is no match in the right table, 
		NULL values are returned for the columns of the right table.

	-> RIGHT OUTER JOIN (or RIGHT JOIN): 
		This returns all rows from the right table and the matching rows from the left table. 
		If there is no match in the left table, 
		NULL values are returned for the columns of the left table.

	-> FULL OUTER JOIN (or FULL JOIN): 
		This returns all rows when there is a match in either the left or the right table. 
		It includes all records from both tables, 
		with NULL values in columns where there is no match in the corresponding table.


*/


--------------------------------------------------------------------------


/*
-- self join (unary relationship)
*/

--////////////////////////////////////////////////////////////////////////////

use ITI
ALTER AUTHORIZATION ON DATABASE::ITI TO sa;

-- cross join
select St_Fname, Dept_Name
from Student , Department

select St_Fname, Dept_Name
from Student cross join Department

--------------------------------------------------------------------------

-- inner join
select St_Fname , Dept_Name
from Student , Department
where Department.Dept_Id = Student.Dept_Id
--			PK					FK
	
select St_Fname , Dept_Name, D.Dept_Id
from Student S inner join Department D
on D.Dept_Id = S.Dept_Id

-- اللي هو فيه dept عايزة اعرض اسم الطالب وكل بيانات ال
-- two tables علي star لو عملت كده هيعمل  
select St_Fname , *
from Student, Department
where Department.Dept_Id = Student.Dept_Id

-- star اللي عايزة عليه table لازم احدد ال
select St_Fname , Department.*
from Student, Department
where Department.Dept_Id = Student.Dept_Id

-- conditions, orderby, ... ممكن ازود كل الحاجات بتاع امبارح 
-- single col ونتعامل مع الناتج كانه table لكذا join الفكرة احنا بنعمل 

-- St_Fname ويرتب الطلاب ب join هيعمل
select St_Fname , Department.*
from Student, Department
where Department.Dept_Id = Student.Dept_Id 
order by St_Fname

-- فقط cairo ويجيب الطلاب اللي في St_Fname ويرتب الطلاب ب join هيعمل
select St_Fname , Department.*
from Student, Department
where Department.Dept_Id = Student.Dept_Id  and Dept_Location = 'cairo'
order by St_Fname

--------------------------------------------------------------------------

-- outer join

	-- left outer join
		-- عايزة اطلع كل الطلبة سواء عندهم اقسام او لا
select St_Fname , Dept_Name
from Student left outer join Department
on Department.Dept_Id = Student.Dept_Id

	-- right outer join
		-- عايزة اطلع كل الاقسام سواء فيها طلبة او لا
select St_Fname , Dept_Name
from Student right outer join Department
on Department.Dept_Id = Student.Dept_Id

	-- full outer join
		-- عايزة اطلع كل الاقسام وكل الطلبة
select St_Fname , Dept_Name
from Student full outer join Department
on Department.Dept_Id = Student.Dept_Id


--------------------------------------------------------------------------

-- self join
select X.St_Fname as Std_Name, Y.St_Fname as Super_name
from Student X, Student Y
where Y.St_Id = X.St_super

------------------------------------------------------------------

-- join Multi tables
 -- ب 1 tables اقل من عدد join القاعدة بتقول عدد شروط


select St_Fname, Grade, Crs_Name
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and
	  C.Crs_Id = SC.Crs_Id

-- 2 tables مبتشتغلش الا علي inner join بس inner join اللي فوق ده query عايزين نحول
select St_Fname, Grade, Crs_Name
from Student S inner join Stud_Course SC
	 on s.St_Id= SC.St_Id
	 inner join Course C
	 on c.Crs_Id = Sc.Crs_Id
 
-- زي ما انت عايز tables هيا الطريقة دي اصعب في الكتابة شوية بس سهل تقراها وسهل جدا تزود 
select St_Fname, Grade, Crs_Name, Dept_Name
from Student S inner join Stud_Course SC
	 on s.St_Id= SC.St_Id
	 inner join Course C
	 on c.Crs_Id = Sc.Crs_Id
	 inner join Department D
	 on D.Dept_Id = S.Dept_Id

--------------------------------------------------------------------------

-- join with DML(Inser, Update, Delete)
	-- join with update

-- درجات كل الطلبة ب 10 update عايزة ا
-- join عادية مفيهاش query دي 
update Stud_Course
set Grade += 10

--  درجات الطلبة اللي عايشين في القاهرة بس مثلا update عايزة ا 
--	  => ده condition علي check الاول عشان اقدر اعمل join تاني فلازم اعمل table موجود في add اصلا

-- update وحط select فيقولك خلاص شيل update ده هيعرض مش query بس ال 
select St_Fname, St_Address, Grade
from Student S, Stud_Course SC
 where S.St_Id= SC.St_Id and St_Address = 'cairo'

-- update => from => where
-- join اللي راجعة من rows ال update بقوله
update SC
set grade += 10
from Student S, Stud_Course SC
 where S.St_Id = SC.St_Id and St_Address = 'cairo'

-- search join with insert
-- search join with delete

--*********************************************************************************


-- when this query run => null values appears
select St_Fname
from Student

-- this query remove the whole row that contains a null value in St_Fname
select St_Fname
from Student 
where St_Fname is not null

/*
-- مهمة row بتاع data بس باقي ال null طب ما ممكن يكون في قيمة معينة ب 
-- دي تظهر null بس في نفس الوقت مش عايزة 
		الحل؟
-- isnull(col you want to check, replacement value)
*/

select isnull(St_Fname,'No Name')
from Student 


--تاني col بتاع value ب replace ممكن كمان ن
-- St_Lname اعرض St_Fname هنا مثلا بقوله لو ملقتش
select isnull(St_Fname,St_Lname)
from Student 

/*
 برضو null هيظهر St_Lname بس برضو في مشكلة ما لو الطالب معندوش
		الحل؟
 coalesce () => allow multiple replacements
 لو ملقتش ده اعرض ده وهكذا
*/
select coalesce(St_Fname,St_Lname, 'No Name')
from Student

--  مفيش مشكلة ليه؟
--  بينهم عاديconcat فاقدر اعمل data type عندهم نفس St_Lname, St_Fname لان
select St_Fname + ' ' + St_Lname
from Student

/*
 -- St_Age => int , St_Fname => varchar انما هنا مش هينفع لان
select St_Fname + ' ' + St_Age XXXXXXXX
from Student
*/

select St_Fname + ' ' + CONVERT(varchar(2),St_Age)
from Student
-- null كله هيبقي select ناتج St_Age او St_Fname سواء فيnull value بس برضو هتظهر مشكلة لما يبقي في 
-- replace بحيث اللي ميلاقيهوش يعمله isnull هنعمل 
-- performance بس شايفة الموضوع بقي معقد ازاي واكيد هيأثر علي 
select isnull(St_Fname,' ' ) + ' ' + CONVERT(varchar(2), isnull(St_Age,' ' ))
from Student

-- هتعمل نفس اللي بتعمله الهيصة اللي فوق دي concat يجي الحل باستخدام
-- concat() => '' تحط مكانه (null) واللي متلاقيهوش string ل data type تحول ال
select concat(St_Fname , ' ' , St_Age) 
from Student

select * from Student
where St_Fname = 'ahmed'
--  (=) ممكن نشيل 
--  وهيطلعو نفس الناتج like ونحط مكانها
select * from Student
where St_Fname like 'ahmed'

-- طب اي الفرق ؟
-- like => ممكن استخدمها لو عارف جزء من الكلمة اللي انت بتدور عليها
--         معين من الكلمة اللي بدور عليها pattern عارف 

/*
	_ => one char
	% => zero or more char
*/

select * from Student
where St_Fname like 'a%' -- a هات كل الاسماء اللي بتبدأ بحرف 

select * from Student
where St_Fname like '%a' -- a هات كل الاسماء اللي تنتهي بحرف 

select * from Student
where St_Fname like '%a%' -- في اي مكان a هات كل الاسماء اللي تحتوي علي حرف 

select * from Student
where St_Fname like '_a%' -- مش مهم بتبدأ ب اي a هات كل الاسماء اللي تاني حرف فيها حرف

/*
	'a%h'	  => h واخرها a اولها string 
	'%a_'	  => a قبل الاخير فيها حرف string
	'ahm%'    => ahm تبدأ ب string
	'[ahm]%'  => a or h or m تبدا ب  string
	'[^ahm]%' => a or h or m لا يبدأ ب string
	'[a-h]%'  => a-h (a, b, c, d,...) تبدأ ب اي حرف بينstring 
	'[^a-h]%' => a-h لا يبدأ بحروف بين string  عكس اللي فوق
	'[346]%'  => 3 or 4 or 6 يبدأ ب string
	'%[%]'    => ex 'aaaa%'   => (%) percentage	 تبدأ ب اي حاجة واخرها string 
	'%[_]%'   => ex aaaaa_aaa => (_) underscore تحتوي علي  string 
	'[_]%[_]' => ex _aaaaaaa_ => (_) underscore تبدأ وتنتهي ب string 
*/


-- select اللي عملتلها columns هتقولي ازاي ده مش موجود في St_Address ب order ده هيشتغل عادي ويعمل query ال
-- St_Address كله وهو جواه Student table هقولك لا عادي لاننا بنتعامل مع
select St_Fname, Dept_Id, St_Age
from Student
order by St_Address

select St_Fname, Dept_Id, St_Age
from Student
order by 1 -- St_Fname اللي هو select في column يعني رتبه ب اول

select St_Fname, Dept_Id, St_Age
from Student
order by 3 -- St_Age اللي هو select في column يعني رتبه ب تالت

-- St_Age ولو في طلبة موجودة في نفس الاقسم هيرتبها ب Dept_Id هنا هيرتب ب
select St_Fname, Dept_Id, St_Age
from Student
order by Dept_Id, St_Age


-- عمره ما بيتكرر St_Id الاول اللي بنرتب بيه مش بيتكرر زي هنا مثلا ال column لو كان ال
-- ملوش لازمة St_Age يبقي اضافة الترتيب ب 
select St_Fname, Dept_Id, St_Age
from Student
order by St_Id, St_Age