use DB1

create table emp(
	id int identity(1,1),
	ename varchar(50),
	address varchar(50) default 'cairo',
	gender varchar(1),
	DoB date,
	age as(year(getdate()) - year(DoB)), -- قيمتها اصلا بتتغير fun لانه معتمد علي persisted وهنا مينفعش
	hireDate date default getDate(),
	salary int,
	overtime int,
	netSalary as (isnull(salary, 0) + isnull(overtime, 0)) persisted,
	hourRate int,
	dno int unique,

	-- to add constraint
	constraint c1 primary key (id, ename), -- composite PK
	constraint c2 unique(salary),
	constraint c3 unique(overtime),
	-- 19,20  لوحده زي  col اعمل كل unique يبقو column لو عايزة اضيف اكتر من
	/*
	   الاثنين مع بعض ميتكرروش salary, overtime انما هنا هيفهم اني بقوله 
	   ex: sal 3000, overtime: 4 
	   تاني فيه نفس القيمتين row يبقي ملاقيش 
	   sal 3000, overtime: 4 XXXXX | sal 3000, overtime: 5 oK | sal 3500, overtime: 4 ok
	*/
	constraint c4 unique(salary, overtime),

	-- check constraint
	constraint c5 check(salary > 1000),

	-- notee: check constraint تكون من ضمن default value لازم ال
	constraint c6 check(address in('alex', 'cairo')),
	constraint c7 check(gender = 'F' or gender = 'M'),
	constraint c8 check(overtime>0),

	-- FK constraint
	-- بتاعتها properties وكمان عدلنا relationship عملنا digram كأنه بديل عن
	constraint c9 foreign key(dno) references Department(dept_id)
		on delete set null on update cascade
)
-- noteee: if you want to add table in specific schema during creation
--			>> create table schema_name.table_name
/*
	table بعد ما اكريت constraint ممكن اضيف 
	هيتطبق علي الداتا القديمة والجديدة constraint لان table المشكلة تظهر لو انا عندي داتا في ال
	مش هيتكريت constraint اللي حطيته فبالتالي ال constraint ال violate فممكن يكون في داتا قديمة بت
	constraint فيه داتا ان الداتا القديمة تكون بتحقق table علي constraint فلازم تاخد بالك لما تحط 
*/
alter table emp add constraint c100 check(year(DoB) > 1970)

-- constraint ل drop ممكن كمان اعمل
alter table emp drop constraint c8

------------------------------------------------------------------------------------------------

--						>>>> Rules <<<


/*
	يتطبق علي الداتا الجديدة بس ملوش دعوة بالداتا القديمة constraint افرض انا عايزة اعمل- 
	table بين كذا shared يكون constraint او عايزة اعمل -
	constraint, default value جديد يكون عليه datatype او عايزة اعمل -
	constraint, default value automatic ده لحد يكون عليه datatype ولما ادي -
*/

-- هيتعمل بحاجة جديدة  constraints كل ده مينفعش ب 
--         ----- >> Ruels << -----
-- schema او بمعني اصح database ولكن بتتكريت علي مستوي constraints دي حاجة شبه

/*
         -- to create rule
	@x >> variable
	programmability >> rules اللي كريتها دي في rule هلاقي ال
*/
create rule r1 as @x > 1000

/*
		--  rule عشان اشغل
	 employee.salary >> rule اللي هتتطبق عليه column ال 
	 employee.salary column وحطيت @x كأني شيلت 
*/
sp_bindrule r1, 'employee.salary'

-- diff table في col دي علي rule وممكن اشغل 
sp_bindrule r1, 'emp.hourRate'


-- how to delete a rule
-- 1. unbindrule from columns it applied to
sp_unbindrule 'emp.hourRate'

-- 2. drop rule
drop rule r1

-- NOTEEEE >> constraint واحدة بس ممكن اكتر من rule بيبقي عليه column ال


---------------------------------------------------------------------------------------------

/*
	default اخرج كمان table بره ال constraint ممكن زي ما خرجت ال
	 rules بكريتها بنفس طريقة 
	 programmability >> Defaults اللي كريتها دي في default هلاقي ال
*/

create default def1 as 5000

-- emp.salary بتاع column علي default value عملت 
sp_bindefault def1, 'emp.salary'

sp_unbindefault  'emp.salary'

drop default def1

-------------------------------------------------------------------------------------------

--				>>>> Create Datatype <<<<
-- for ex: complexDT(int	> 1000		default = 5000)

-- 1. create rule
create rule r1 as @x > 1000

-- 2. create default
create default def1 as 5000

-- 3. add datatype
-- هلاقيه فين؟
-- 	programmability >> Types >> User-Defined Data Types
sp_addtype complexDT, 'int' -- >> complexDT اسمه sql جوه datatype وبقي عندي int ل copy كأني عملت

-- 4. newDT ب default و newDT ب rule اربط ال
sp_bindrule r1, complexDT
sp_bindefault def1, complexDT

create table test(
id int, 
name varchar(50),
sal complexDT
)

--	*NOTESSSS
--	1. rule يبقي عليه اكثر من column عشان كده ميتنفعش نفس DT انها تتربط ب rule هدف ال
--	2. المهم ميتعارضوش مع بعض constraints, rule يبقي عليه  column ممكن ال
--	3. rule بتتطبق الاول بعدين constraint 
--  4. create rule r1 as @x > 1000 and ... >> condition ممكن اضيف اكثر من create rule وانا ب