use TestIdentity

create table dbo.T1(column_1 int, 
					column_2 varchar(30),
					column_3 int identity primary key)

select * from T1

insert T1 values (100, 'Row#1')
-- then I insert many values using Wizard


delete from T1
where column_3 between 3 and 7

select * from T1

-- 10 رقم id هيدخل ال insert واكيد لو عملنا 
-- بيزيد identity لان دايما ال
-- لان بقي في فراغ بين 2,8 identity gap بس بينتج عن الكلام ده 
insert T1 values (1000, 'Row#10')

select * from T1


-- ب ايدي؟ identity طب هل اقدر اكتب جوه
-- insert لا مينفعش وحتي لو حاولت مش هتشتغل ومش هيعمل 
insert into T1 values (300, 'Row#10', 3) -- error

-- on, off فقدر اعملها property هي identity بس ممكن نعمل حاجة تاني بيقولك ان
-- by default identity insert is off => we can't insert
-- but we can make it on => so we can insert

set identity_insert T1 off -- => default
set identity_insert T1 on 

insert into T1(column_1, column_2, column_3) values
(300, 'Explict identity Value', 3)

-- تاني off وبعدين اخليها gaps بحيث املي on اخليها identity_insert فممكن استخدم
insert into T1(column_1, column_2, column_3) values
(400, 'Explict identity Value', 4), 
(500, 'Explict identity Value', 5), 
(600, 'Explict identity Value', 6),
(400, 'Explict identity Value', 7)



-- يرجعها تقف عند رقم معين انت بتحدده reset identity بي
dbcc checkident (T1, RESEED, 3) -- هنا مثلا هترجع عند رقم 3

set identity_insert T1 off

insert T1 values (1100, 'Row#11')
-- عملنا ليها رن query بس بيتأثر باخر identity بيجيبلي اخر
-- null كانت مرجعة select @@IDENTITY ل run وجيت عملت  identity_insert => on يعني لما كنا عاملين
select @@IDENTITY

-- IDENT_CURRENT() => اللي واقف عليه كام identity ويرجعلي ال table بياخد اسم
select IDENT_CURRENT('T1')