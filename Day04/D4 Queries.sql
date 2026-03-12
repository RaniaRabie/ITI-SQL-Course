use ITI

select Salary
from Instructor

-- Aggregate Functions
--	*Sum()
select Sum(Salary)
from Instructor

--	*Min(), Max()
select min(Salary), max(Salary)
from Instructor

-- Note => alias name ملهاش اسم ف ممكن احنا نديلها agg fun اللي راجعة من columns ال 
select min(Salary) as MinSalary, max(Salary) as MaxSalary
from Instructor

--	*Count()
-- معاها في الاعتبار null مبتاخدش ال agg fun ال
select count(*), count(St_Id), count(St_Lname), count(St_Age)
from Student

--	*Avg()
-- age = null معاه لان في طلاب null لان هنا مش هياخد ال
select avg(St_age)
from Student
-- هيطلع ناتج مختلف query اللي فوق الا ان كل query اللي تحت هيا معني ال query علي الرغم من ان المفروض ال 
-- انما هنا هو اجبره يقسم علي عدد الطلاب كامل 
select sum(St_age)/ count(*)
from Student

-- 0 حطيت مكانها null كامل لاني شيلت اي قيمة rows انها تقسم علي عدد avg هنا اجبرت
-- ده واللي فوقه يدو نفس الناتج بس خلي بالك اللي فوق ابطأ query وبالتالي، حاليا ال
-- agg fun لانه مستخدم اتنين
select avg(isnull(St_age, 0))
from Student

--------------------------------------------------------------------------------------------

-- Aggregate Functions With Grouping
--	دي cols ال group by او اكتر لازم تعمل col معينة مع agg fun لو مستخدم * 

/* 
	-- ERROR XXXXXXX -- 
select sum(Salary), Dept_Id
from Instructor
*/

-- انما كده بقي ليها معني بقوله طلع مجموع المرتبات لكل قسم
select sum(Salary), Dept_Id
from Instructor
group by Dept_Id

-- مختلف table كل واحد في Dept_Name, Salary لان join اولا: عملنا 
-- التانية دي cols كل ال group by تانية لازم نعمل cols و agg fun وفيها select ثانيا: بما اننا عاملين
select sum(Salary), D.Dept_Id, Dept_Name
from Instructor I inner join Department D
on D.Dept_Id = I.Dept_Id
group by D.Dept_Id, Dept_Name

-- دي؟ col اكتر من group by ولكن يبقي السؤال الاهم: يعني اي 
--  الاثنين مع بعض group by الإجابة انه بي 
-- وهكذا alex, dept 20 مثلا وجروب تاني ل dept 10 وفي alex بمعني هيبقي عندنا جروب للناس اللي عايشة في
select avg(St_Age), St_Address, Dept_Id
from Student
group by St_Address, Dept_Id


/*
-- حاجة مبتتكررش group by مبيتكررش فمفيش معني اني اعمل PK ملوش معني لان query ده 
-- زي ما هيا عادي rows  هتطلع كل 
select avg(St_Age), St_Id
from Student
group by St_Id

*/


-- Aggregate Functions With Grouping, where
--	where => اللي راجعة مع كل جروب value بتأثر علي groups مبتأثرش علي 

select sum(Salary), Dept_Id
from Instructor
group by Dept_Id

select sum(Salary), Dept_Id
from Instructor
where Salary > 1000
group by Dept_Id

-- Aggregate Functions With Grouping, having
--	having => condition ممكن تشيل جروبي او اكتر حسب groups بتأثر علي 
select sum(Salary), Dept_Id
from Instructor
group by Dept_Id
having sum(Salary) > 100000

-- having تكون هيا هيا اللي في select اللي في agg fun مش لازم
select sum(Salary), Dept_Id
from Instructor
group by Dept_Id
having count(Ins_Id) < 6

------------------------------------------------------------------------------------

-- subQueries 
------ اخر query ل as an input معين query بتاع output اخد ،query جوا query استخدم 
--------- not only used with select, it can be also used with insert, update, delete

-- ده ميرنش ليه؟؟ query طبيعي جدا ومتوقع ان
-- لوحده row بتطبق علي كل where لان where ميتجيش مع agg fun لان برضو احنا عارفين ان
select * 
from Student
where St_Age < avg(St_Age) -- avg(St_Age) المشكلة هنا في الجزء ده

-- لوحده query طب ما اي رأيك نقلبه 
-- outer query, inner query جوه بعض queries بس كده بقي عندنا اتنين
-- outer query بتتنفذ الاول وكأننا بنعوض بالنتيجة بتاعتها لل inner query ال
select * 
from Student -- outer query
where St_Age < (select avg(St_Age) from student) -- inner query

-- another ex: count هنا انا عايزة اعرض كل الصفوف ومع كل صف 
--  1 of 10, 2 of 10 لما يظهرلك quiz زي مثلا في 
-- group by * بس مينفعش نعمل  group by بس تظل المشكلة ان لازم نعمل 
select *, count(St_Id)
from Student

-- subquery ل count(St_Id) الحل اننا نحول الجزء ده
select *, (select count(St_Id) from Student)
from Student

-- note: 1* we can write subquery anywhere, with select, where, from, having, ... 
--		 2* table يكونو علي نفس inner query, outer query مش لازم خالص 
--		 3* ده مش معناه انهم بيستخدمو عشان يحلو مشاكلهم بس agg func في subqueries ومش عشان ذكرنا

-- هات اسماء الاقسام اللي فيها طلبة
select Dept_Name
from Department
where Dept_Id in(select distinct (Dept_Id)
				 from Student
				 where Dept_Id is not null)

-- join اللي فوق ده يتعمل ب  query بس خلي بالك ال
/*
	؟subquery ليه عملتها join طب اما هيا تنفع   
	؟performanc لا عادي ممكن نفس الحاجة نكتبها بكذا طريقة بس الفكرة مين افضل من ناحية 
	join => اسرع
	subquery => مش احسن حاجة خالص performanc بطيئة فبالتالي من ناحية
	join هيحاول قبل ما يرن يحولها ل subquery كده لما لاقاني بعتاله optimizer عنده engine كمان ال 
	engine لو نفعت يرن وممكن منفعتش يبقي انا كده في الحالتين اجهدت
	الاستفادة من كل الهري ده؟
	subquery => اخر حاجة تفكري فيها
*/

select distinct D.Dept_Name
from Student S inner join Department D
on D.Dept_Id = S.Dept_Id


-- subquery + DML(insert, update, delete)

-- Stud_Course table بس المعلومة دي مش موجودة في cairo درجات الطلبة اللي عايشة في delete عايزة ا
-- Stud_Course table اللي موجود في id بتاعهم وقارناه ب id يجيب الsubquery فعملنا
delete 
from Stud_Course
where St_Id in (select St_Id from Student where St_Address = 'Cairo')


------------------------------------------------------------------------------------------------
-- union Family => قوق بعض two table بيتطلع الناتج بتاع
----- *union all	*union	*intersect	*except

-- union all
-- هيطلعلي شيت واحد فيه اسامي الطلبة وتحتهم اسامي المعيدين
/* 
Notes:
	- relationship يكون بينها وبين بعض tables مش لازم
	- زي ما عملت كده alias name لو عايزة اغيره اديله St_Fname الاول col الناتج بيبقي واخد اسم ال
	- التاني table اللي بجيبها من rows تساوي عدد table اللي بجيبها من اول rows لازم عدد 
	- convset والا هنحتاج ت data type يكونو من نفس union عشان اعملهم table اللي بحددها من كل columns لازم
*/
select St_Fname as Names
from Student
union all
select Ins_Name
from Instructor

-- union => (distinct) ولكن بترتب وتشيل المتكرر union all اخت
select St_Fname as Names
from Student
union 
select Ins_Name
from Instructor

-- intersect => الموجود هنا وهنا tables المتقاطع بين 
--				ترتب وتشيل المتكرر (distinct) وبرضو بتعمل
--  ده: هاتلي اسماء الطلبة اللي شبه اسماء المعيدين query معني ال
select St_Fname as Names
from Student
intersect 
select Ins_Name
from Instructor

-- المعني اختلف two columns خلي بالك لما استخدمت
-- بتاع معيد عندنا id بتاعها شبه اسم و id بقي معناه هاتلي الطلبة اللي اسمها و
-- شبه بعض في نفس الوقت مش كل واحد علي حدي values لو كل result هيطلع cloumn اذن القاعدة هتقول لو بستخدم اكتر من 
select St_Fname as Names, St_Id as id
from Student
intersect 
select Ins_Name, Ins_Id
from Instructor


-- except => هات الموجود في الا
--			 ترتب وتشيل المتكرر (distinct) وبرضو بتعمل
-- ده: هاتلي اسامي الطلبة اللي مش شبه اسامي المعيدين query معني ال
select St_Fname as Names
from Student
except 
select Ins_Name
from Instructor

---------------------------------------------------------------------------------

-- كله table لانه كده كده شايف ال St_Address هيعرض الداتا مترتبة ب 
select St_Fname, St_Age, Dept_Id
from Student
order by St_Address

-- St_Fname اللي هو هنا select في column هيرتب ب اول
select St_Fname, St_Age, Dept_Id
from Student
order by 1

-- St_Age ولو في طلبة في نفس القسم يرتبهم ب Dept_Id هرتب ب  
select St_Fname, St_Age, Dept_Id
from Student
order by Dept_Id, St_Age

-- مش بيتكرر St_Id لان كده كده order التاني ده اللي حطاه في  column ملوش معني ال
select St_Fname, St_Age, Dept_Id
from Student
order by St_Id, St_Age

delete 
from Department
where Dept_Id = 20
-- childs ليه parent ل updata او delete مينفعش اعمل
-- 20 الحل ان عشان اعرف اعمل كده لازم اعدي علي كل الناس اللي في قسم 
-- انقلهم في قسم تاني او امسحهم المهم ان القسم اللي همسحه يكون فاضي محدش مرتبط بيه
update Department 
set Dept_Id = 4000 
where Dept_Id = 20


-- built in functions
----- *Aggregate Functions(sum, min, max, avg, count)
----- *getdate()
----- *isnull()
----- *coalesce()
----- *concat()
----- *convert()
----- *year()
select year(GETDATE())

----- *month()
select month(GETDATE())

----- *SUBSTRING(string_expression, start_position, length)
select SUBSTRING(st_fname,2,3) --> return first 3 char of st_fname
from Student

----- *db_name() => retuen name of data base that i use
select DB_NAME()

----- *suser_name() => return name of the user who logsin the server
select suser_name()
