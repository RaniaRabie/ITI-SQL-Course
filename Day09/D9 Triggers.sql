use ITI

/*
	3. Triggers => special type of Stored Procedure
			 	   parameter ولا ابعتلها call مقدرش اعملها
				   اما هستخدمها ازاي؟
				   server اللي بتحصل عندنا في  actions علي listen بي server موجود جوه ال implict code هو عبارة عن 
				   بتتكريت علي مستوي اي triggers طب ال
				   server, database, table في علي مستوي 
*/

/*
	notee => حاجة عندنا بتتكريت علي مستوي معين بمعني
			 column => table
			 constraints => table
			 table, function, SP => schema
			 schema, users => database
			 logins => server
*/

-- 1. triggers on table => listen to actions done on tables (insert, update, delete)


-- sql اللي بيظهر دي مسدج خاصة ب result set دي مفيش حاجة بتظهر في query لما بنرن ال
insert into Student(St_Id, St_Fname)
values (777, 'ali')


-- user طب لو عايزة حاجة تظهر لل
-- table اللي بتحصل علي مستوي  trigger عندنا نوعين من
------ 1. after => query كود يرن بعد ال
create trigger ti              -- to create trigger
on student                     -- trigger اللي هنكريت عليه table ال
after insert                   -- اللي هيتنفذ بعدها query وال trigger نوع
as
	select 'Welcome to ITI'    -- تتنفذ query اللي هيتنفذ لما ال

	-- اللي كريته فين trigger هلاقي ال
	-- trigger اللي كريت عليه table جوه

ti -- error => can't call triggers

insert into Student(St_Id, St_Fname)
values (778, 'ali')


create trigger t1            
on student                    
after update     -- for == after           
as
	select getDate()

update Student
	set St_Age += 1



------ 2. instead of => query كود يرن بدل

create trigger t2              
on student                     
instead of  delete                   -- اللي هيوقف تنفذيها query وال trigger نوع
as
	select 'Not Allowed for user: ' + suser_name()            --  student table علي delete الكود اللي هيتنفذ لو حد حاول يعمل

delete from Student 
where St_Id = 777


-- table => read only لو عايزين نخلي  trigger ممكن برضو نستخدم 

create trigger t3
on tab4
instead of insert, update, delete
as 
	select 'Not Allowed'

update tab4
set st_fname = 'user'

-- enable, disable ممكن نعمله trigger ل drop لو عايزة اشغله تاني ف بدل ما نعملtab4 انا وقفت الشغل علي t3 في
-- لسه موجود ولكن وقفنا شغله بس t3 
alter table tab4 disable trigger t3


 -- Noteeeeee => 1.  او لا rows بتاعك اثر في query سواء ال call كده كده هيتعمله  trigger ال

--			     2.	 اوتوماتيك object بتاع  schema بياخد اسم trigger ال 
CREATE SCHEMA sales;

create table sales.student
(
    id int,
    name varchar(20)
);

create trigger t7
on sales.student
after update
as
	select 'hi'

update sales.student
set id = 4
where id = 7

Alter trigger t7 -- should be witten => sales.t7
on sales.student
after update
as
	select 'hi'


--				3. لحاجة معينة update ميتنفذش الا لما اعمل trigger ان ال condition ممكن استغل الموضوع ده اني اعمل functioin الوحيدة المتلونة بالاحمر فده معناه انها keyword هيا update ال
Alter trigger sales.t7 -- should be witten => sales.t7
on sales.student
after update
as
	if update (name)
		select 'hi'

-- هنا ميتنفذش
update sales.student
set id = 4
where id = 7

-- كده يتنفذ
update sales.student
set name = 'ali'
where id = 7

/*
	 trigger اللي متكريت عليه table شبه ال  two tables بيتكريت trigger لل fire مع كل 
	  - inserted
	  - deleted
	  مهمة جدا Nooteee :
				--	insered, deleted الداتا كده كده هتتسجل في after/ instead of سواء
	  -- : لو بنعمل
	 insert => inserted table filled with data i insert, deleted table is empty
	 delete => deleted table filled with data i delete, inserted table is empty
	 update => inserted contain new data, deleted contain old data
*/
create trigger t8
on test222
after update 
as	
	select * from inserted
	select * from deleted

update test222
	set name = 'nour', age = 22
where id = 1


alter trigger t9
on test222
instead of delete 
as	
	select name from deleted -- delete هيعرض الاسم اللي كنت بحاول اعمله

delete from test222
where id = 1

-- معين يوم الجمعة table من delete بيمنع الناس انها ت trigger عايزين نعمل
create trigger t10
on table2
after delete
as
	if format(getdate(), 'dddd') = 'Friday'
		begin
			select 'Can not delete'
			-- rollback

			insert into table2
			select * from deleted
		end

alter trigger t10
on table2
instead of delete
as
	if format(getdate(), 'dddd') != 'Friday'
		begin
			delete from table2 
			where St_Id = (select St_Id from deleted)
		end
	
delete from table2
where St_Id = 1


-- عليه لحد هنا تمام update معين وعايزة امنع الناس انها ت table عندي 
-- بالاخص نسجل الداتا تاعتهم مين بيعمل الابديت وامتي والقيمة القديمة والجديدة id علي update ولكن لو حاولو يعملو
-- database انا عايزة حاجة ثابتة ليا في volatile فقط لانهم inserted, updated  طبعا مش هينفع نستخدم 

create table history
(
	_userName varchar(20),
	_date date,
	_oldId int,
	_newId int, 
)

create trigger t11
on tab3
instead of update
as
	if(update(id))
		begin
			declare @new int, @old int
			select @old = id from deleted
			select @new = id from inserted
			insert into history
			values(suser_name(), GETDATE(), @old, @new)

		end
------------------------------------------------------------

-- output => بس يعني اي؟ query وقت تنفيذ runtime اثناء trigger بتعمل

-- trigger كنت لازم اعمل delete اللي بعمله  row عادي ولو عايزة اعرف اي معلومة عنdelete هيعمل 
delete from Topic 
where Top_Id = 334

-- trigger دي بس لان فعليا مفيش query قدرت اجيب الوقت والشخص اللي بحاول امسجه ولكن ده هيبنفذ علي ال output لما زودت
delete from Topic 
output GETDATE(), deleted.Top_Name
where Top_Id = 6

-- insert, update ممكن كمن اعمله مع

update Topic
set Top_Name = 'IT'
output suser_name(), inserted.Top_Name
where Top_Id = 9

insert into Topic
output 'Insert success'
values(10, 'V')