T-SQL

1、对T-SQL的简单介绍：
	->T-SQL即Transact-SQL，是SQL在SQL Server上的增强化语言,即T-SQL是对SQL进行了一些扩展之后的版本。(对与现在主流的几大数据库来说，它们都对SQL有各自的一些扩充和截取)。
2、对T-SQL语言的分类：
	1)数据定义语言(Data Definition Language)
	  -->CREATE(新建)
	  -->DROP(删除)
	  -->ALTER(修改)
	2)数据操作语言(Data Manipulation Language)
	  -->INSERT(插入)
	  -->DELETE(删除)
	  -->SELECT(查询)
	  -->UPDATE(修改)
	3)数据控制语言(Data Control Language)
	  -->GRANT(授权)
	  -->DENY(拒绝)
	  -->REVOKE(取消授予或删除的权限)
	4)事务控制语言(TCL)
	  -->COMMIT(提交)
	  -->ROLLBACK(回滚)

3、数据定义语言
	-->数据定义语言(DDL)：负责数据结构定义和数据库对象定义;
	其主要使用到的关键字为：CREATE(新建)、DROP(删除)、ALTER(修改)

4、数据库
		-->对数据库的简介：
	     数据库是数据存储的仓库，用户在利用数据库管理系统提供的功能时，是将数据或数据的修改保存到用户指定的数据库中。数据库中存储的对象主要有：表、索引和视图。
		 (SQL Server支持在一个实例中创建多个数据库文件，且这些数据库在物理和逻辑上都是相互独立的)
		-->数据库文件(数据文件和日志文件)：
			--->数据文件可以有多个，但是主数据文件只能有一个；
			--->日志文件也可以声明多个；
			--->数据库文件的属性(文件逻辑名及其位置、初始大小、增长方式、最大大小)
		-->数据库的分类:
		在SQL Server中数据库可以分为两类：系统数据库和用户数据库。(以下只简单的介绍一下系统数据库)
			--->系统数据库(master、msdb、model、tempdb)
			master:是SQL Server中最重要的数据库，用于记录系统级信息(该数据库损坏则SQL Server将无法正常工作)；
			msdb:保存关于调度报警、作业、操作员等信息；
			model:用户数据库模板，当用户创建一个数据库时，会将model数据库的全部内容复制到新建数据库中；
			tempdb:是临时数据库，用于存储用户创建的临时表(查询操作的表即存储其中)、用户声明的变量以及用户定义的游标数据等。


-->创建、修改、删除数据库
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->创建数据库(创建数据库主要使用CREATE TABLE语句)

--创建数据库的语法
CREATE DATABASE <Db_name>
[ON [PRIMARY]
(
	[NAME = <logical_file_name>,]			--文件逻辑名称
	FILENAME = <file_name>					--文件物理名称
	[, SIZE = <size>]
	[, MAXSIZE = <max_size>]
	[, FILEGROWTH = <growth_size|percentage>]
)]
[LOG ON
(
	[NAME = <logical_file_name>,]
	FILENAME = <file_name>
	[, SIZE = <size>]
	[, MAXSIZE = <max_size>]
	[, FILEGROWTH = <growth_size|percentage>]
)]
[ COLLATE <collation_name> ]
[ FOR ATTACH [WITH <service_broker>]| FOR ATTACH_REBUILD_LOG| WITH DB_CHAINING {ON|OFF } | TRUSTWORTHY { ON|OFF }]
[AS SNAPSHOT OF <source_database_name>]
[;]

--语法参数说明
--1、CREATE DATABASE <Db_name>：为创建数据库的主要语法，其中Db_name为数据库的名称；
--2、PRIMARY：标识该mdf文件为主文件(系统默认第一个为主数据文件)；
--3、NAME：文件的逻辑名称（在同一个数据库中该值必须唯一）；
--4、FILENAME：文件的具体存储路径（必须完整且存在）；
--5、SIZE：设置数据文件的初始大小（单位：M、G等）；
--6、MAXSIZE：设置数据文件的最大容量（单位：M、G等）；
--7、FILEGROWTH：设置数据文件的增长量(可以为具体的存储量亦可以为一个百分数)；
--8、COLLATE：可应用于数据库定义或列定义以定义排序规则，或应用于字符串表达式以应用排序规则投影；(可以不加默认为系统的排序规则)；
--9、FOR ATTACH：将已存在的数据库文件附加到当前服务器上；
--10、WITH DB_CHAINING {ON|OFF }：如果该选项为ON,则跨数据库的所有权链有效；否则全链无效；
--11、TRUSTWORTHY { ON|OFF }：控制访问的安全性(默认情况下为关闭状态)；
--12、AS SNAPSHOT OF <source_database_name>：指定要创建的数据库为source_database_name指定的源数据库的数据库快照(快照和源数据库必须位于同一实例中)。


--创建数据库(CREATE DATABASE语句)

--1)创建系统默认的数据库
CREATE DATABASE Demo
GO
--代码说明：
--该语句为创建数据库的最简单形式，所有的参数都为系统默认(数据库文件存储在默认位置)

--2)创建指定的数据库(单数据库、单事务日志)
CREATE DATABASE Demo
ON PRIMARY                 --PRIMARY指主数据文件（为系统的默认值，可以省略）
(						--在这里设置主数据文件mdf                        
	NAME='Demo_db',							     --主数据文件的逻辑名称
	FILENAME='F:\sql\Demo_db.mdf',					 --文件的具体存储路径(路径必须完整存在)
	SIZE=3MB,								     --设置文件的初始大小
	MAXSIZE=100MB,								 --设置文件最大容量（UNLIMITED为不限制大小）
  --filegrowth=1MB								 --设置文件的增长量(可以为字节，也可以为百分数)
	FILEGROWTH=10%
)
LOG ON						--创建数据事务(也可以添加多个事务日志)
(						--在这里设置事务日志文件                
	NAME='Demo_log',							--日志的名称
	FILENAME='F:\sql\Demo_log.ldf',				--日志的完整路径(路径必须完整存在)
	SIZE=1MB,									--日志文件的初始大小
	MAXSIZE=UNLIMITED,							--日志文件的最大容量,不设最大限制
	FILEGROWTH=1MB								--增长速量为1MB
)
GO

--3)创建指定的数据库(多数据库、多事务日志)
CREATE DATABASE DemoTest
ON PRIMARY                 --PRIMARY指主数据文件（为系统的默认值，可以省略）
(						--在这里设置主数据文件mdf                        
	NAME='DemoTest1',							 --主数据文件的逻辑名称
	FILENAME='F:\sql\DemoTest1.mdf',			 --文件的具体存储路径(路径必须完整存在)
	SIZE=3MB,								     --设置文件的初始大小
	MAXSIZE=100MB,								 --设置文件最大容量      UNLIMITED为不限制大小
	FILEGROWTH=10%
),										
(						--在这里设置次数据文件mdf                        
	NAME='DemoTest2',							 --数据文件的逻辑名称
	FILENAME='F:\sql\DemoTest2.mdf',			 --文件的具体存储路径(路径必须完整存在)
	SIZE=3MB,								     --设置文件的初始大小
	MAXSIZE=100MB,								 --设置文件最大容量      UNLIMITED为不限制大小
    FILEGROWTH=1MB								 --设置文件的增长量为1MB
)
LOG ON		--创建数据事务
(						--在这里设置事务日志文件                
	NAME='DemoTest1_log',							--日志的名称
	FILENAME='F:\sql\DemoTest1_log.ldf',			--日志的完整路径(路径必须完整存在)
	SIZE=1MB,								    	--日志文件的初始大小
	MAXSIZE=20MB,						        	--日志文件的最大容量,其最大容量为20M
	FILEGROWTH=1MB								    --增长速量为1MB
),
(						--在这里设置事务日志文件                
	NAME='DemoTest2_log',							--日志的名称
	FILENAME='F:\sql\DemoTest2_log.ldf',			--日志的完整路径(路径必须完整存在)
	SIZE=1MB,									    --日志文件的初始大小
	MAXSIZE=UNLIMITED,							    --日志文件的最大容量,不设最大限制
	FILEGROWTH=10%								    --增长速量为10%
)
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--修改数据库（ALTER DATABASE 数据名称）

EXEC sp_renamedb Test5,Test55				--使用存储过程修改数据库的名称
--语法抽象:EXEC sp_renamedb 旧数据库名称,新数据库名称

	常用的 ALTER DATABASE语句
	ADD FILE						--添加数据文件
	ADD LOG FILE					--添加日志文件
	MODIFY FILE						--修改数据\日志文件(必须指明其逻辑名称)
	REMOVE FILE						--移除数据\日志文件(必须指明其逻辑名称)

--修改数据库的语法
ALTER DATABASE <database_name>
{
   MODIFY NAME = <new_database_name>
   | ADD FILE <filespec> [ ,...n ] [ TO FILEGROUP {  <filegroup_name> } ]
   | ADD LOG FILE <filespec> [ ,...n ] 
   | REMOVE FILE <logical_file_name>
   | MODIFY FILE <filespec>
}
  <filespec>::=
   (
     NAME = <logical_file_name>
     [,NEWNAME = <new_login_name> ]
     [,FILENAME = {'<os_file_name>' | '<filestream_path>'} ]
     [,SIZE = <size>[ KB | MB | GB | TB]  ] 
     [,MAXSIZE  = {<max_size> [ KB | MB |GB |TB] | UNLIMITED}  ] 
     [,FILEGROWTH  = <growth_increment> [ KB  | MB  |GB  | TB  | %] ] 
);
语法参数说明：
--database_name:要修改的数据库的名称（必须内容）；
--MODIFY NAME:指定新的数据库名称；
--ADD FILE:向数据库中添加文件。
--TO FILEGROUP{filegroup_name}:将指定文件添加到文件组。filegroup_name为文件组名称.
--ADD LOG FILE:将要添加的日志文件添加到指定的数据库
--REMOVE FILE logical_file_name:从SQL Server的实例中删除逻辑文件并不删除物理文件。除非文件为空，否则无法删除文件。logical_file_name是在Sql Server 中引用文件时所用的逻辑名称。
--MODIFY FILE:指定应修改的文件，一次只能更改一个<filespec>属性。必须在<filespec>中指定name,以标识要修改的文件。如果指定了size，那么新大小必须比文件当前大小要大。

--向已创建的数据中添加文件
ALTER DATABASE Test5
ADD FILE									--向数据库中添加数据文件
(
	NAME = "Test5_data1",					--数据文件的逻辑名称
	FILENAME = "F:\sql\Test5_data1.mdf",	--数据文件的物理位置
	SIZE = 10MB,							--初始容量
	MAXSIZE = 50MB,							--最大容量
	FILEGROWTH = 10%						--增长量
)
ALTER DATABASE Test5
ADD LOG FILE								--向数据库中添加日志文件
(
	NAME = "Test5_log1",					--日志文件的逻辑名称
	FILENAME = "F:\sql\Test5_log1.mdf",		--日志文件的物理存储位置(完整性)
	SIZE = 10MB,							--初始容量
	MAXSIZE = 40MB,							--最大容量
	FILEGROWTH = 10%						--增长量
)

--修改数据库中已经定义好的文件属性
ALTER DATABASE Test5
MODIFY FILE						--修改指定数据库中的数据文件
(
	NAME = "Test5_data",			--文件的逻辑名称(必须项)
	SIZE = 10MB,					--修改文件的大小
	MAXSIZE = 50MB,					--修改文件的最大容量
	FILEGROWTH = 10%				--修改文件的增长量
)

ALTER DATABASE Test5
MODIFY FILE						--修改数据库中的日志文件
(
	NAME =  "Test5_log",		--日志文件的逻辑名称(必须项)
	SIZE = 5MB,					--修改日志文件的初始大小
	MAXSIZE = 10MB,				--修改文件的最大容量
	FILEGROWTH = 10%			--修改文件的增长量
)

ALTER DATABASE Test5
REMOVE FILE Test5_data1			--移除数据库中的数据文件
GO

ALTER DATABASE Test5
REMOVE FILE Test5_log1			--移除数据库中的日志文件
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--删除数据库
DROP DATABASE Test5,Test							--删除数据库(将数据库连根拔起)
GO

DELETE FROM Staff							--主要用来删除数据表中的数据记录(一条数据会生成一行日志)
GO

TRUNCATE TABLE Test5						--清空表中的数据(只产生一行的日志记录)
GO

--查看数据库信息
--		查询数据库的信息有很多方式：使用目录视图、函数、存储过程等

--1）使用目录视图
SELECT * FROM sys.database_files
GO
--代码说明：
--		查询有关数据库文件的信息

SELECT * FROM sys.filegroups
GO
--代码说明：
--		查看有关数据库组的信息

SELECT * FROM sys.master_files
GO
--代码说明：
--		查看数据库文件的基本信息和状态信息（对系统中所有的数据库）

SELECT * FROM sys.databases
GO
--代码说明：
--		查看系统中所有数据库的基本信息

--2）使用函数
SELECT DATABASEPROPERTYEX('<database_name>','<property>')
--参数说明：
--<database_name>：数据库名称
--<property>：属性名称

--SELECT DATABASEPROPERTYEX('Demo','Status') as '数据库的状态信息'
--GO

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--数据表

--数据表的创建(CREATE TABLE语句)
--创建数据库的语法：
CREATE TABLE 表名称
(
	<列名称1> <数据类型> [列级完整性约束定义]
	[,<列名称2> <数据类型> [列级完整性约束定义]]
	[,<列名称3> <数据类型> [列级完整性约束定义]...]

	[,表级完整性约束定义]
)

--数据类型

--约束
CONSTRAINT 约束名 CHECK约束 | DEFAULT约束 | UNIQUE约束 | PRIMARY KEY约束 | FOREIGN KEY约束

约束的分类：(以约束定义的位置为分类的依据，可以将约束分为列级约束和表级约束)
列级约束：NOT NULL约束、DEFAULT约束；
表级约束：UNIQUE月俗话、CHECK约束、PRIMARY KET约束、FOREIGN KEY约束。
注：列级约束只能在列定义处进行定义

约束语法：
CONSTRAINT 约束名称 约束类型及其条件
简介约束语法：
NOT NULL约束：(列级)
CONSTRAINT NN_XXX NOT NULL;

DEFAULT约束:(列级)
CONSTRAINT DF_XXX DEFAULT 默认值 FOR 列名称;
UNIQUE约束：
CONSTRAINT UN_XXX UNIQUE 列名称;

CHECK约束:
CONSTRAINT CK_XXX CHECK(条件)

PRIMARY KEY约束：
CONSTRAINT PK_XXX PRIMARY KEY(列名)

FOREIGN KEY约束：
CONSTRAINT FK_XXX FOREIGN KEY(列名) REFERENCES 表名(列名)

----------------------------------------------------------------
--创建数据表
USE DemoTest
GO
CREATE TABLE Class											--创建班级表
(
	C_id INT,												--班级编号
	C_name NVARCHAR(16) NOT NULL,							--班级名称、非空
	C_des NVARCHAR(64) NULL CONSTRAINT DF_C_des DEFAULT N'无',--班级描述(默认描述为无)
	CONSTRAINT PK_C_id PRIMARY KEY(C_id),					--表级定义主键约束
	CONSTRAINT UN_C_name UNIQUE(C_name),					--表级定义唯一约束
	CONSTRAINT CK_C_id CHECK(C_id > 0)						--表级定义CHECK约束
)
CREATE TABLE Student											--创建学生表
(
	S_id INT CONSTRAINT PK_S_id PRIMARY KEY,					--学号、列级主键约束
	S_name NVARCHAR(4) NOT NULL CONSTRAINT UN_S_name UNIQUE,	--学生姓名、非空且唯一
	S_age TINYINT NOT NULL CONSTRAINT CK_S_age CHECK(S_age > 20),--年龄、非空且必须大于20
	S_gender BIT CONSTRAINT DF_S_gender DEFAULT 0,				--性别，默认为0(女)
	C_id INT NOT NULL CONSTRAINT FK_C_id_C_id FOREIGN KEY(C_id) REFERENCES Class(C_id)--学生所在班级(外键约束)
)
GO

--数据表的修改(ALTER TABLE)
--修改数据表(ALTER TABLE语句)

EXEC sp_rename 'Student','ss'								--修改表的名称
EXEC sp_rename 'Student.S_gender','nn','column'			--修改数据表的列名
GO
--语法抽象：EXEC sp_rename 旧名称，新名称，类型(表类型默认为空，列类型为column)

ALTER TABLE Student				--向数据表添加多个新列
 ADD SS INT,XX INT
GO
--语法抽象：ALTER TABLE 数据表名称 ADD 列名 数据类型

ALTER TABLE Student				--删除数据表中的指定列
 DROP COLUMN SS,XX
GO
--语法抽象：ALTER TABLE 数据表名称 DROP COLUMN 列名

 ALTER TABLE Student			--删除数据表中定义的约束
  DROP CONSTRAINT [UN_S_name]
GO
--语法抽象： ALTER TABLE 数据表名称 DROP CONSTRAINT 约束名称

ALTER TABLE Student				--修改数据表中的列定义
 ALTER COLUMN S_age INT
GO
--语法抽象： ALTER TABLE 数据表名称 ALTER COLUMN 列名称 数据类型



--数据表删除(DROP TABLE)
DROP TABLE Student
GO

DELETE FROM Student1
GO
--删除表中所有的数据记录，并产生多条操作记录

TRUNCATE TABLE Student1
GO
--清空表中的数据，但只产生一条操作记录


---------------------------------------------------------------------------------------------
--数据操作
对于数据库中的数据操作主要有增删查改这四种操作，下面将分别从这四个方面进行说明

-----增-------

1、增加操作：
	向数据库中添加数据主要使用(INSERT INTO 语句)

	INSERT语法：
	INSERT INTO table_name (list_column) VALUES (list_value)

	--语法说明：
	--table_name:要添加数据的表名称
	--list_column:列名称集，要为那些列添加数据
	--list_value:值集，将该值添加到数据库中
--注意事项：
--1、注意语句的完整性(在下面的例子中将会展示一个特殊的insert语句)
--2、列项的个数与值集合个数必须一致
--3、列项的顺序与值集合的顺序必须一致
--4、对于数据类型为datetime和字符类型的列项在插入数据时注意要使用单引号将数据包含在内
--5、对于数据类型为bit的列项在插入数据时，注意使用0和1进行插入操作(1代表true、0代表false)
--(在高版本的SQL Server中向表中插入中文时，要注意以“N'张三'”的形式进行插入，但当你向数据表中插入一些不常用的字符时，必须要使用该形式)

--创建测试数据表
CREATE TABLE Student
(
	stu_Id INT NOT NULL PRIMARY KEY,
	stu_Name NVARCHAR(4) NOT NULL,
	stu_Gender BIT DEFAULT 0,
	stu_Age INT NULL
)
GO

代码展示：
1)、完整的INSERT语句
INSERT INTO Student
 (stu_Id,stu_Name,stu_Gender,stu_Age)
 VALUES(111,N'张三',0,12)
GO
--代码说明：所有的列项都要添加新的数据，

2)、不完整的INSERT语句(insert语句的简写形式)
INSERT INTO Student
 (stu_Id,stu_Name,stu_Age)
 VALUES(101,N'李四',12)
 --代码说明：虽然stu_Gender的设置是NOT NULL，但是也对其进行了默认值设置，当不为其添加数值时，数据库系统会将默认值赋给它
 --			但是对于另一些为NOT NULL的项，若没有为其设置默认值，则不能这样简写(除非该项被设为NULL)
 --即上面的插入代码等同于
 INSERT INTO Student
 (,stu_Name,stu_Gender,stu_Age)
 VALUES(111,N'张三',DEFAULT,12)
GO

 INSERT INTO Student
 VALUES(102,N'王五',0,13)
 GO
 --代码说明：对于这种省略列项的表达，值集合必须包含全部的列项(即使有项已经设置了默认值也不可以省略)

 3)、进行批量插入操作
INSERT INTO Student
 (stu_Name,stu_Gender,stu_Age)
 SELECT stu_Name,stu_Gender,stu_Age 
  FROM Student
GO
--代码说明：将从一个表中查询到的数据批量的插入到表中

SELECT * INTO Student1
 FROM Student 
 WHERE 1<>1
GO
--代码说明：复制一张表的结构信息，但是里面的内容没有复制

SELECT * INTO Student2
 FROM Student 
GO
--代码说明：复制一张表中结构，并将该表中的数据信息也拷贝了一份(可以用来备份单个表)

-----删-------

 2、删除操作
 删除操作主要使用删除数据表中的数据

 常用语法：
 DELETE FROM table_name WHERE语句
 
 1)、删除该数据表中的所有数据
 DELETE FROM Student
 GO
 --代码说明：delete语句没有添加where语句时，将会删除整个数据表中的数据

 2）、删除数据表中指定条件的数据
 DELETE FROM Student WHERE stu_Id = 111
 GO

 3）、三种清空表的比较
 TRUNCATE TABLE Student
 --代码说明：清空整张数据表，只产生一行日志信息
 DELETE FROM Student
 --代码说明：删除整张表中的数据，每删除一行数据就会产生一条日志信息
 DROP TABLE Student
 --代码说明：将该数据表彻底删除,(破坏了数据表的结构)

 -----改-------

 3、修改操作
 修改操作就是对数据表中的某一行或某些行进行修改操作

 常用语法：
 UPDATE table_name SET 条件 WHERE语句
 --代码说明：
 --table_name:想要修改的数据表的名称
 --STE语句：为列项设置新的值
 --WHERER语句：进行条件选择

 1）、修改指定的数据
 UPDATE Student 
  SET stu_Age=0  
  WHERE stu_Id = 101
GO
--代码说明：设置学号为101的学生的年龄为0

2）、修改全部的数据信息
 UPDATE Student 
  SET stu_Age=0 
GO
--代码说明:设置该数据表中的学生的年龄全部为0(该操作不可控，一般情况下不使用)

3)、其他形式的修改语句、
UPDATE Student
 SET stu_Age += 1
GO 
--代码说明：数据表中学生的年龄全部加一

UPDATE Student 
 SET stu_Age = 19
 WHERE stu_Age IS NULL
GO
--代码说明：将数据表中年龄为NULL的值设置为19

UPDATE Student
 SET stu_Age = 19
  WHERE stu_Age IS NULL AND stu_Id = 101
GO
--代码说明：若学号为101的学生的年龄为NULL则将其设置为19 

--关于WHERE语句只做了简单的描述，详细的描述将放到select语句中


-----查-------

4、查询操作
查询语句是在做项目中使用次数最多的数据操作语句，其主要为SELECT语句

1、通用的查询方式：
SELECT * 
 FROM Student
GO
--代码说明：查询Student表中的所有数据列，得到的数据集可能及其庞大，因此不太常用

2、简略的查询方式
SELECT stu_Id,stu_Name,stu_Gender,stu_Age
 FROM Student
GO
--代码说明：查询Student表中的部分数据列，相对的查询到的数据量有一定的减少

--补充知识：
--对于只查询数据表中的部分信息时，有时会看到许多重复的信息，这是因为SQL默认会显示所有的满足条件的信息，若不想要重复的数据可以使用DISTINCT关键字来实现

SELECT ALL stu_Gender
 FROM Student
GO
--代码说明：显示所有满足条件的信息（默认不删除重复项）

SELECT DISTINCT stu_Gender
 FROM Student
GO
--代码说明：显示满足条件的信息（删除重复项）

3、where指定条件查询方式
SELECT * 
 FROM Student
 WHERE stu_Id = 101
GO
--代码说明：在Student表中查询学号为101的学生的全部信息

SELECT stu_Name,stu_Gender
 FROM Student
 WHERE stu_Id = 101
GO
--代码说明：在Student表中查询学号为101的学生的部分信息

--补充信息
--WHERE语句的使用方法
where语句是一个条件判断语句，只会对满足where语句条件的数据进行数据操作
（1）、单关系条件的where语句
	1)常在where语句中使用条件判断符号：
		<(小于)、>(大于)、(>=)不小于、(<=)不大于、=(等于)、(!=、<>)(不等于)
	2)空值条件判断
		使用 IS NULL 或 IS NOT NULL
（2）、多关系条件的where语句
	1)常在where中使用到的逻辑符号：
	AND、OR、NOT
	2)between...and...条件判断
		使用between and 语句执行的效率要优于实现相同功能的逻辑条件语句
	3)属性域的判断条件
	IN关键字指定属性的值域

--示例代码：
SELECT *
 FROM Student
 WHERE stu_age < 5
GO
--代码说明：查询表中年龄小于5的学生的所有信息

SELECT * 
 FROM Student
 WHERE stu_age > 5
GO
--代码说明：查询表中年龄大于5的学生的所有信息

SELECT *
 FROM Student
 WHERE stu_age <= 5
GO
--代码说明：查询年龄小于等于5的学生的所有信息

SELECT * 
 FROM Student
 WHERE stu_age >= 5
GO
--代码说明：查询年龄大于等于5的学生的所有信息

SELECT *
 FROM Student 
  WHERE stu_age = 1
GO
--代码说明：查询年龄等于1的学生的所有信息

SELECT * 
 FROM Student 
 WHERE stu_age <> 5
GO
--代码说明：查询年龄不等于5的学生的所有信息

SELECT *
 FROM Student
 WHERE stu_age != 5
GO
--代码说明：查询年龄不等于5的学生的所有信息

SELECT *
 FROM Student 
 WHERE stu_age IS NULL
GO
--代码说明：查询表中学生的年龄为NULL的学生的所有信息

SELECT *
 FROM Student 
 WHERE stu_age IS NOT NULL
GO
--代码说明：查询表中学生年龄不为NULL的学生的所有信息

SELECT *
 FROM Student
  WHERE stu_age <> 5 AND stu_Id = 101
GO
--代码说明：查询表中学生年龄不为5并且学号为101的学生的所有信息

SELECT *
 FROM Student
 WHERE stu_age <> 5 OR stu_Id = 101
GO
--代码说明：查询表中学生年龄不为5或者学号为101的学生的所有信息

SELECT *
 FROM Student 
 WHERE not stu_age = 5
GO
--代码说明：查询表中学生年龄不满足年龄为5条件的学生的所有信息

SELECT *
 FROM Student
 WHERE stu_age BETWEEN 0 AND 20
GO
--代码说明：查询表中学生年龄在0-20之间(包含0和20)学生的所有的信息

SELECT *
 FROM Student
 WHERE stu_age IN(1,2,5)
GO
--代码说明：查询表中学生年龄为1或2或5学生的所有信息
--注：域值的数据类型必须与属性的数据类型一致

--注意：
--1、关系判断条件默认将会自动屏蔽掉查询条件值为NULL的数据信息

4、有序查询方式
SELECT * 
 FROM Student 
 WHERE stu_age <> 5
 ORDER BY stu_age
GO
--代码说明：将查询到的学生信息安默认排序规则进行排序(正序)

SELECT *
 FROM Student
 WHERE stu_age <> 5
 ORDER BY stu_age DESC
GO
--代码说明：将查询到的学生信息按倒序规则进行排序

SELECT *
 FROM Student
 WHERE stu_age <> 5
 ORDER BY stu_age ASC
 --代码说明：将查询到的学生信息按正序规则进行排序

5、模糊查询方式
	模糊查询就是查询的条件和查询的结果可以不完全匹配

常使用的通配符：
_:表示一个占位符，可以任何字符
%:表示零个或多个占位符，可以是任何字符
[]:表示只要满足中括号内一个字符就可以
[^]:表示不包含中括号内的任意一个字符

SELECT *
 FROM Student
 WHERE stu_Name LIKE N'%刘%'
GO
--代码说明：查询学生信息数据表中所有学生姓名中含有刘的学生信息

SELECT *
 FROM Student
 WHERE stu_Id LIKE '10_'
GO
--代码说明：查询学生信息表中学号以10开头的学生的信息

SELECT *
 FROM Student
 WHERE stu_Id LIKE '10[1-2]'
GO
--代码说明：查询学生信息表中学号为101或102的学生的信息

SELECT *
 FROM Student
 WHERE stu_Id LIKE '10[^1-2]'
GO
--代码说明：查询学生数据表中学号不为101或102的学生的信息

--注意：
--当查询的数据中含有通配符时的处理办法
方式一：将数据中的"通配符"放到[]中
SELECT * 
 FROM Student
 WHERE stu_Name LIKE '%[%]%'
GO
--代码说明：查询姓名中含有%号的学生信息

SELECT *
 FROM Student
 WHERE stu_Name LIKE '%[_]%'
GO
--代码说明：查询姓名中含有_的学生信息

SELECT *
 FROM Student 
 WHERE stu_Name LIKE '%[[]%'
GO
--代码说明：查询姓名中含有【的学生信息

SELECT *
 FROM Student 
 WHERE stu_Name LIKE '%[]]%'
GO
--代码说明：查询姓名中含有】的学生信息

SELECT * 
 FROM Student 
 WHERE stu_Name LIKE '%^%'
GO
--代码说明：查询姓名中含有^的学生信息
-^不用放到[]中，因为只有当^位于[]中才是通配符

方式二：
使用ESCAPE关键字来定义一个转义符

SELECT * 
 FROM Student 
 WHERE stu_Name LIKE '%\%%' ESCAPE '\'
GO
--代码说明:定义\为转义字符

6、分组查询方式：
 SELECT stu_gender AS 性别, AVG(stu_Age) 
  FROM Student
  GROUP BY stu_gender
GO
--代码说明：按性别将表中的学生分类
--AS :为查询的列定义一个别名
--AVG：计算一组中学生的平均年龄（聚合函数）

--补充信息：
1)、为查询列定义别名的方式：
方式一：
SELECT stu_gender AS 性别
 FROM Student

方式二：
SELECT stu_gender 性别
 FROM Student

 方式三：
 SELECT 性别=stu_gender
  FROM Student

2）、聚合函数：
	经常使用的聚合函数有：
	MAX():得到数据中的最大值；
	MIN():得到数据中的最小值 
	COUNT():得到数据的条数
	SUM():得到整性数据的和(必须为整形)
	AVG():得到数值类型数据的平均数

示例代码：
SELECT MAX(stu_Age) AS 最大值
 FROM Student
GO 

SELECT MIN(stu_Age) AS 最小值
 FROM Student
GO

SELECT COUNT(*) AS 总数
 FROM Student
GO

SELECT SUM(stu_Age) AS 求和
 FROM Student
GO

SELECT AVG(stu_Age) AS 求平均s
 FROM Student
GO

--注意：
--1、在MIN() MAX() AVG() SUN 中会自动屏蔽掉NULL值，，但是在COUNT()中不会屏蔽掉NULL

7、分组过滤查询方式
使用having语句来过滤不符合条件的分组信息

SELECT stu_Gender AS 性别,AVG(stu_Age)
 FROM Student
 GROUP BY stu_Gender
 HAVING stu_Gender IS NOT NULL
GO
--代码说明：先按性别对学生进行分组，剔除性别为NULL的分组，最后求各个分组年龄的平均值

--注意：
--1、where子句用在from语句后，having子句用在group by语句后；where语句是对整个表进行筛选，而having是对分组进行筛选
--2、having子句中可以使用统计函数，而where子句中不能使用；group by子句中也不能使用统计函数，必须是原始列
--3、必须在group by子句中列出select查询字段中所有的非集合字段

8、连接查询方式
当两个或多个表中的数据存在联系时（外键关系），对数据的查询操作可能需要将两个数据表根据外键关系连接起来再进行查询操作

方式一：在where语句中通过外键将两个数据表连接起来
SELECT stuName,cName,score
 FROM Course,Score,Student
 WHERE Score.stuId = Student.stuId AND Score.cId = Course.cId
GO
--代码说明：where子句执行之后，将Course,Score,Student这三个数据表连接依据外键关系进行连接操作，创建一个新的临时表（含有三个表所有信息）
--			from子句指定查询数据所在的数据表
--			select子句将要查询展示的列名，当列名在多个表中都存在时，必须要指定查询哪个表中的列（若为某个表所特有的可以不加）

方式二：使用JOIN子句进行连接查询
SELECT stuName,cName,score
 FROM Score
 JOIN Student ON Score.stuId = Student.stuId
 JOIN Course ON Score.cId = Course.cId
GO
--代码说明：SELECT子句指示将要显示的信息
--			from子句要进行连接的一个子表
--			（inner）join子句进行两个表之间的链接只有满足条件的记录才会被保留

--注：1、使用JOIN子句进行数据表的链接时，一次只能链接两张表
--	  2、INNER JOIN子句：内连接，只有满足条件的记录才会被保留
--		 LEFT JOIN子句：左连接，保留左表中的全部数据记录
--		 RIGHT JOIN子句：右连接，保留右表中的全部数据记录
--		 FULL JOIN子句：只要其中一个表中存在匹配就返回行
--		 CROSS JOIN子句：返回笛卡尔积


9、联合查询方式
联合查询将查询到的多张表的结果联合到一张表中
SELECT * 
 FROM Student
 UNION ALL
 SELECT * 
 FROM Student
GO
--代码说明：select子句查询表的数据信息
--	        union子句进行结果的联合，（ALL显示全部的信息，默认是去除重复记录）

--注：连接两个结果集的条件
--1.	两个集合必须具有相同的列数
--2.	列具有相同的数据类型（至少能隐式转换的）
--3.	最终输出的集合的列名由第一个集合的列名来确定
--4.	使用的默认的排序规则对得到的结果进行排序(若要手动进行排序则将order by子句写入第二个select子句中)





