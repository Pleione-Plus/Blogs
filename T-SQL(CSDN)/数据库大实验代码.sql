/************************************************************************
 *九大关系表:
 *[dbo].[bookInfo]
 *[dbo].[bookTypeInfo]
 *[dbo].[commentInfo]
 *[dbo].[lendingInfo]
 *[dbo].[pressInfo]
 *[dbo].[rankInfo]
 *[dbo].[readerInfo]
 *[dbo].[subjectMatterAndBookTypeInfo]
 *[dbo].[subjectMatterInfo]
 *
 *
 *基本触发器(对关系表中属性的限制)：
 *1》读者的证件生效日期大于或等于办证日期							--[TR_readerInfo_readerEffectiveDate]
 *2》读者借阅等级由其借阅量来直接决定	（每借阅100本等级加一）		
 *   读者的欠款金额由其违章次数直接决定	（每违章一次罚款10元）		--[TR_readerInfo_readerBorrowLevelAndreaderDebtMoney]
 *3》当发生借阅时，读者的累计借书量需要发生变化还有应归还日期由系统完成填写，图书的状态信息也同样发生变化	（默认一次插入一条数据、读者信息已存在）--[TR_lendingInfo_readerInfo_readerBookCount]
 *4》当归还图书时，需要判断读者是否发生违章操作而且实际的归还时间必须大于或等于借阅时间，图书的状态信息也同样发生变化	（默认一次插入一条数据、读者信息已存在）		--[TR_lendingInfo_readerInfo_readerViolationCount]
 *
 *
 *主要视图的创建:
 *视图1：显示所有当前仍未归还的图书条码、借阅者姓名、节约真编号、借阅时间和应还时间；
 *视图2：显示所有借阅过的图书的借阅量信息
 *视图3：显示与某主题词相关的所有图书编号和历史总借阅量；			--参数主题词
 *视图4：显示某读者的编号（如20181001）和其当前所有未归还图书的条码、图书名称和应还日期；	--参数读者编号
 *视图5：显示某读者的编号和其对应的历史借阅信息，包括图书条码、图书名称、实际借阅日期和实际归还日期；--参数读者编号
 *视图6：显示某读者编号和其发表的书评内容，包括评论的图书名称、评论时间和评论内容；			--参数读者编号
 *视图7：显示某出版社名称及其出版的所有图书名称，并按年代分组。								--参数出版社名称
 *
 *
 *创建向关系表中插入的数据的存储过程:
 *1》向rankInfo表的数据插入操作								--proc_rankInfo_insert
 *2》向readerInfo关系表中插入数据							--proc_readerInfo_insert
 *3》向pressInfo关系好表中插入数据							--proc_pressInfo_insert 
 *4》向bookTypeInfo关系表中插入数据							--proc_bookTypeInfo_insert
 *5》向commentInfo关系表中插入数据							--proc_commentInfo_insert
 *6》向subjectMatterInfo关系表中插入数据					--proc_subjectMatterInfo_insert
 *7》向subjectMatterAndBookTypeInfo关系表中插入数据			--proc_subjectMatterAndBookTypeInfo_insert
 *8》向bookInfo关系表中插入数据								--proc_bookInfo_insert
 *9》向lendingInfo关系表中插入数据							--proc_lendingInfo_insert
 *10》创建带参数的存储过程用来查询指定视图中的指定信息
 ************************************************************************/


--创建存储图书信息的数据库

CREATE DATABASE LibSystemOfZZULI
ON
(
	NAME = 'LibSystemOfZZULI_data',
	FILENAME = 'F:\sql\LibSystemOfZZULI_data.mdf',
	SIZE = 100MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 5%
)
LOG ON
(
	NAME = 'LibSystemOfZZULI_log',
	FILENAME = 'F:\sql\LibSystemOfZZULI_log.ldf',
	SIZE = 90MB,
	MAXSIZE = 300MB,
	FILEGROWTH = 10MB
)
GO

--跳转到指定的数据库中
USE LibSystemOfZZULI
GO


--关系表的创建
-------------------------------------------------------------------------------------------------------------------------------
--创建等级信息表
CREATE TABLE rankInfo
(
	rankSysId INT IDENTITY(1,1) CONSTRAINT PK_rankInfo_SysId PRIMARY KEY,			--定义系统主键、自增
	readerRank TINYINT NOT NULL CONSTRAINT UN_rankInfo_readerRank UNIQUE,		--唯一约束（候选键）
	maxBorrowBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxBorrowBook CHECK(maxBorrowBook IN(50,80,100)), --CHECK约束
	maxDelegationBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxDelegationBook CHECK(maxDelegationBook IN(0,1)), --CHECK约束
	maxOrderBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxOrderBook CHECK(maxOrderBook IN(0,1)), --CHECK约束
	maxBorrowDate INT NOT NULL CONSTRAINT CK_rankInfo_maxBorrowDate CHECK(maxBorrowDate IN(3,5,6)),	--CHECK约束

	isDelete BIT NOT NULL CONSTRAINT DF_rankInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT CK_rankInfo_readerRank CHECK (readerRank IN(0,1,2))			--(本科生：0、研究生：1、教师：2）
)
GO

--创建读者信息表
CREATE TABLE readerInfo
(
	readerSysId INT IDENTITY(1,1) CONSTRAINT PK_readerInfo_SysId PRIMARY KEY,				--系统主键，自增
	readerName  NVARCHAR(8) NOT NULL,								--读者姓名
	readerGender BIT NOT NULL,										--(0:女、1:男)
	readerNum VARCHAR(12) NOT NULL CONSTRAINT UN_readerInfo_readerNum UNIQUE,		 --证件号
	readerClass NVARCHAR(16) NOT NULL,					--读者所在班级
	readerEmail VARCHAR(32) NOT NULL,					--读者的Email信息
	readerPhone CHAR(11) NOT NULL,						--读者的手机号
	readerRegistrationDate DATE NOT NULL,				--读者办证的日期
	readerEffectiveDate DATE NOT NULL,					--证件生效日期  CHECK约束:必须>=办证日期
	readerBookCount INT NOT NULL CONSTRAINT DF_readerInfo_readerBookCount DEFAULT 0, --累计借书量	默认为0
	readerBorrowLevel TINYINT NOT NULL CONSTRAINT DF_readerInfo_readerBorrowLevel DEFAULT 1, --借阅等级	 默认为1,由累计借书量判断
	readerViolationCount INT NOT NULL CONSTRAINT DF_readerInfo_readerViolationCount DEFAULT 0, --违章次数	默认为0
	readerDebtMoney MONEY NOT NULL CONSTRAINT DF_readerInfo_readerDebtMoney DEFAULT 0, --欠款金额	默认为0

	readerRank TINYINT NOT NULL, --外键(与等级信息表相关联)
	isDelete BIT NOT NULL CONSTRAINT DF_readerInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_readerInfo_readerRank_rankInfo_readerRank FOREIGN KEY(readerRank) REFERENCES rankInfo(readerRank)	--设置外键
)
GO

--创建触发器

--指定证件生效日期必须大于或等于办证日期
CREATE TRIGGER TR_readerInfo_readerEffectiveDate
ON readerInfo
WITH ENCRYPTION			--加密
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @readerEffectiveDate DATE,@readerRegistrationDate DATE
	SET @readerEffectiveDate = (SELECT readerEffectiveDate FROM inserted)
	SET @readerRegistrationDate = (SELECT readerRegistrationDate FROM inserted)
	IF @readerEffectiveDate >= @readerRegistrationDate
	BEGIN
	 INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerBookCount, readerBorrowLevel, readerViolationCount, readerDebtMoney, readerRank)
	 SELECT readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerBookCount, readerBorrowLevel, readerViolationCount, readerDebtMoney, readerRank 
	 FROM inserted
	END
	ELSE
	 PRINT '输入的日期不符合规范'
END
GO

--创建触发器指定借阅等级与借阅量的关系以及欠款金额与违章次数的关系
CREATE TRIGGER TR_readerInfo_readerBorrowLevelAndreaderDebtMoney
ON readerInfo
WITH ENCRYPTION			--加密
AFTER UPDATE
AS
BEGIN
	DECLARE @readerBorrowLevel TINYINT,@readerSysId INT,@readerBookCount INT
	SET @readerBookCount = (SELECT readerBookCount FROM inserted)
	SET @readerBorrowLevel = @readerBookCount / 100 + 1
	SET @readerSysId = (SELECT readerSysId FROM inserted)
	UPDATE readerInfo SET readerBorrowLevel = @readerBorrowLevel WHERE readerSysId = @readerSysId

	DECLARE @readerDebtMoney MONEY,@readerViolationCount INT
	SET @readerViolationCount = (SELECT readerViolationCount FROM inserted)
	SET @readerDebtMoney = @readerViolationCount * 10
	UPDATE readerInfo SET readerDebtMoney = @readerDebtMoney WHERE readerSysId = @readerSysId
END
GO

--创建出版社信息表
CREATE TABLE pressInfo
(
	pressSysId INT IDENTITY(1,1) CONSTRAINT PK_pressInfo_pressId PRIMARY KEY,				--定义出版社编号主键，自增
	pressName NVARCHAR(32) NOT NULL CONSTRAINT UN_pressInfo_pressName UNIQUE,		--出版社名称

	isDelete BIT NOT NULL CONSTRAINT DF_pressInfo_isDelete DEFAULT 0,				--删除标示
)
GO

--创建图书类型信息表
CREATE TABLE bookTypeInfo
(
	bookTypeSysId INT IDENTITY(1,1) CONSTRAINT PK_bookTypeInfo_sysId PRIMARY KEY,			--定义系统主键，自增
	bookTypeMark NVARCHAR(16) NOT NULL CONSTRAINT UN_bookTypeInfo_bookMark UNIQUE,		--索书号
	bookTitleAndAuthor NVARCHAR(32) NOT NULL,										--题名/责任者
	isbnAndPrice NVARCHAR(64) NOT NULL,												--ISBN及定价
	bookTypeMorphological NVARCHAR(32) NOT NULL,										--载体形态项
	bookTypeSeries NVARCHAR(32) NULL,												--丛编项
	bookTypePrintDate DATE NOT NULL,													--印刷时间

	PressSysId INT NOT NULL,				--出版发行项			外键（与出版社信息表相关联）
	isDelete BIT NOT NULL CONSTRAINT DF_bookTypeInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_bookTypeInfo_PressSysId_pressInfo_PressSysId FOREIGN KEY(PressSysId) REFERENCES pressInfo(PressSysId)
)
GO

--创建评论信息表
CREATE TABLE commentInfo
(
	commentSysId INT IDENTITY(1,1) CONSTRAINT PK_commentInfo_sysId PRIMARY KEY,			--系统主键，自增
	comment NVARCHAR(128) NOT NULL,														--评论内容
	commentDate DATE NOT NULL,															--评论日期
	
	bookTypeMark  NVARCHAR(16) NOT NULL,													--图书类型（外键）
	readerSysId INT NOT NULL,															--读者编号（外键）
	isDelete BIT NOT NULL CONSTRAINT DF_commentInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_commentInfo_bookTypeMark_bookTypeInfo_bookTypeMark FOREIGN KEY(bookTypeMark) REFERENCES bookTypeInfo(bookTypeMark),
	CONSTRAINT FK_commentInfo_readerSysId_readerInfo_readerSysId FOREIGN KEY(readerSysId) REFERENCES readerInfo(readerSysId)
)
GO

--创建学科主题信息表
CREATE TABLE subjectMatterInfo
(
	subjectMatterSysId INT IDENTITY(1,1) CONSTRAINT PK_subjectMatterInfo_subjectMatterSysId PRIMARY KEY,	--系统主键，自增
	subjectMatterName NVARCHAR(16) NOT NULL,											--学科主题名称

	isDelete BIT NOT NULL CONSTRAINT DF_subjectMatterInfo_isDelete DEFAULT 0,				--删除标示
)
GO

--创建学科主题信息与图书类型信息表
CREATE TABLE subjectMatterAndBookTypeInfo
(
	subjectMatterAndBookTypeInfoSysId INT IDENTITY(1,1) CONSTRAINT PK_subjectMatterAndBookTypeInfo_subjectMatterAndBookTypeInfoSysId PRIMARY KEY,				--系统主键，自增

	subjectMatterSysId INT NOT NULL,					--学科主题外键
	bookTypeSysId INT NOT NULL,							--图书类型外键
	isDelete BIT NOT NULL CONSTRAINT DF_subjectMatterAndBookTypeInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_subjectMatterAndBookTypeInfo_subjectMatterSysId_subjectMatterInfo_subjectMatterSysId FOREIGN KEY (subjectMatterSysId) REFERENCES subjectMatterInfo(subjectMatterSysId),
	CONSTRAINT FK_subjectMatterAndBookTypeInfo_bookTypeSysId__bookTypeSysId FOREIGN KEY (bookTypeSysId) REFERENCES bookTypeInfo(bookTypeSysId)
)
GO

--图书信息表
CREATE TABLE bookInfo
(
	bookInfoSysId INT IDENTITY(1,1) CONSTRAINT PK_bookInfo_bookInfoSysId PRIMARY KEY,		--系统主键，自增
	bookMark CHAR(7) NOT NULL CONSTRAINT UN_bookInfo_bookMark UNIQUE,						--图书条形码，唯一标示图书
	campusCollection NVARCHAR(64) NOT NULL,													--校区-馆藏地
	bookStatus BIT NOT NULL CONSTRAINT DF_bookInfo_bookStatus DEFAULT 1,					--书刊状态
	bookPosiTion NVARCHAR(32) NULL,														--图书定位

	bookTypeMark NVARCHAR(16) NOT NULL,														--图书类型（外键）
	isDelete BIT NOT NULL CONSTRAINT DF_bookInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_bookInfo_bookTypeMark_bookTypeInfo_bookTypeMark FOREIGN KEY(bookTypeMark) REFERENCES bookTypeInfo(bookTypeMark)
)
GO

--创建借阅信息表
CREATE TABLE lendingInfo
(
	lendingInfoSysId INT IDENTITY(1,1) CONSTRAINT KF_lendingInfo_lendingInfoSysId PRIMARY KEY,		--系统主键，自增
	lendingDate DATE NOT NULL,															--借阅日期
	returnDate DATE NULL,							--根据借阅时间、读者等级计算得到	（该项不能输入）
	actualReturnDate DATE NULL,										-- 实际归还时间>=借阅时间	--可以为空
	returnPosition NVARCHAR(32) NULL,							--实际归还时间		--可以为空

	readerSysId INT NOT NULL,						--外键（与读者信息相关联）
	bookInfoSysId INT NOT NULL,						--外键（与图书信息先关联）

	isDelete BIT NOT NULL CONSTRAINT DF_lendingInfo_isDelete DEFAULT 0,				--删除标示

	CONSTRAINT FK_lendingInfo_readerSysId_readerInfo_readerSysId FOREIGN KEY(readerSysId) REFERENCES readerInfo(readerSysId),
	CONSTRAINT FK_lendingInfo_bookInfoSysId_bookInfo_bookInfoSysId FOREIGN KEY(bookInfoSysId) REFERENCES bookInfo(bookInfoSysId)
)
GO

--为借阅信息表创建触发器

--创建一个触发器判断该书是否可借
CREATE TRIGGER TR_lendingInfo_bookStatus
ON lendingInfo
WITH ENCRYPTION			--加密
INSTEAD OF INSERT
AS 
BEGIN
	DECLARE @bookStatus BIT,@bookInfoSysId INT
	SET @bookInfoSysId = (SELECT bookInfoSysId FROM inserted)
	SET @bookStatus = (SELECT bookStatus FROM bookInfo WHERE bookInfoSysId = @bookInfoSysId)
	IF @bookStatus = 0
		PRINT '该书不可借'
	ELSE
		INSERT INTO lendingInfo(lendingDate, returnDate, actualReturnDate, returnPosition, readerSysId, bookInfoSysId)
		SELECT lendingDate, returnDate, actualReturnDate, returnPosition, readerSysId, bookInfoSysId 
		FROM inserted
END
GO

--当向表中插入数据时,同时对读者的累计阅读量信息进行更新，以及计算本书的归还日期,图书状态设置为不可借
CREATE TRIGGER TR_lendingInfo_returnDate_And_readerInfo_readerBookCount
ON lendingInfo
WITH ENCRYPTION			--加密
AFTER INSERT
AS
BEGIN
	--累计阅读量修改
	DECLARE @readerSysId INT
	SET @readerSysId = (SELECT readerSysId FROM inserted)					--默认读者信息表中已经存存储该读者信息
	UPDATE readerInfo SET readerInfo.readerBookCount += 1 WHERE readerInfo.readerSysId = @readerSysId

	--应归还日期的计算
	DECLARE @returnDate DATE,@lendingDate DATE,@maxBorrowDate INT,@lendingInfoSysId INT
	SET @lendingInfoSysId = (SELECT lendingInfoSysId FROM inserted)
	SET @maxBorrowDate = (SELECT maxBorrowDate FROM rankInfo WHERE readerRank = (SELECT readerRank FROM readerInfo WHERE readerSysId = @readerSysId))
	SET @lendingDate = (SELECT lendingDate FROM inserted)
	SET @returnDate = DATEADD(MONTH,@maxBorrowDate,@lendingDate)				
	UPDATE lendingInfo SET lendingInfo.returnDate = @returnDate WHERE lendingInfo.lendingInfoSysId = @lendingInfoSysId

	DECLARE @bookInfoSysId INT
	SET @bookInfoSysId = (SELECT bookInfoSysId FROM inserted)
	UPDATE bookInfo SET bookStatus = 0 WHERE bookInfoSysId = @bookInfoSysId
END
GO

--当向表中修改数据后,同时对读者的违纪次数信息进行修改
CREATE TRIGGER TR_lendingInfo_readerInfo_readerViolationCount
ON lendingInfo
WITH ENCRYPTION			--加密
AFTER UPDATE
AS
BEGIN
	DECLARE @readerSysId INT,@returnDate DATE,@actualReturnDate DATE,@lendingDate DATE,@bookInfoSysId INT
	
	SET @bookInfoSysId = (SELECT bookInfoSysId FROM inserted)
	IF (SELECT actualReturnDate FROM inserted) IS NOT NULL
	BEGIN
	 SET @returnDate = (SELECT returnDate FROM inserted)
	 SET @lendingDate = (SELECT lendingDate FROM inserted)
	 SET @actualReturnDate = (SELECT actualReturnDate FROM inserted)
	 SET @readerSysId = (SELECT readerSysId FROM inserted)					--默认读者信息表中已经存存储该读者信息
	 IF @lendingDate <=  @actualReturnDate
	 BEGIN
		IF @actualReturnDate > @returnDate
		 BEGIN
		  UPDATE readerInfo SET readerInfo.readerViolationCount += 1 WHERE readerInfo.readerSysId = @readerSysId
		  UPDATE bookInfo SET bookStatus = 1 WHERE bookInfoSysId = @bookInfoSysId
		 END
	 END
	 ELSE
		PRINT '实际归还日期必须大于或等于结余日期'
	END
END
GO
---------------------------------------------------------------------------------------------------------------------


--向数据表中插入数据
---------------------------------------------------------------------------------------------------------------------

--等级表的数据插入操作
INSERT INTO rankInfo(readerRank, maxBorrowBook, maxDelegationBook, maxOrderBook, maxBorrowDate)
VALUES(0,50,0,0,3),
(1,80,0,0,5),
(2,100,1,1,6)
GO

--读者信息插入操作		--必须一条一条的进行插入
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES('韩雪娇',0,'541607030101','网络工程1601','10857821@qq.com','13345897664','2016-9-1','2016-9-1',0)

INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('韩林',1,'541607030102','网络工程1601','10857901@qq.com','15837177392','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('韩丁',1,'541607030103','网络工程1601','10556788@qq.com','15837177395','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('韩雪阳',1,'20164548','网络工程1601','10839577@qq.com','15837177537','2016-9-1','2016-9-1',1)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('韩静',0,'541607030105','网络工程1601','10851703@qq.com','15837177801','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('尤爽',0,'541607030106','网络工程1601','10853257@qq.com','15837177805','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('尤云',1,'541607030107','网络工程1601','10856381@qq.com','15837177865','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('马冬冬',1,'20164549','网络工程1601','10857039@qq.com','15837177927','2016-9-1','2016-10-1',1)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('马翔宇',1,'541607030109','网络工程1601','10857507@qq.com','13692588338','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('范艳',0,'1999012','网络工程1601','10859239@qq.com','13692599339','2016-9-1','2016-9-1',2)
GO

--出版社信息表的数据插入操作
INSERT INTO pressInfo(pressName)
VALUES('电子工业出版社'),
('《电脑编程技巧与维护》杂志社'),
('上海译文出版社'),
('成都科技大学出版社'),
('经济科学出版社'),
('清华大学出版社'),
('中国矿业大学出版社')
GO

--图书类型信息表的数据插入
INSERT INTO bookTypeInfo(bookTypeMark, bookTitleAndAuthor, isbnAndPrice, bookTypeMorphological, bookTypeSeries, bookTypePrintDate, PressSysId)
VALUES('TP312/2281','Visual C#.NET应用编程150例/尹立宏编著','7-5053-8936-X/35.00','401页;28cm','编程沙龙丛书','2003-8-1',1),
('TP314 /1/1','电脑编程技巧与维护（上）/《电脑编程技巧与维护》杂志社编','7-89994-056-7/29','455页;29cm+光盘1张10465-74',NULL,'2005-1-1',2),
('H319.5/179','计算机/潘绪年,陈士源注释','7-/.17','63;19cm',NULL,'1980-8-1',3),
('TP391.4/189','计算机绘图/蒋融, 贺元成编著','7-5616-3027-1/14','220;26cm',NULL,'1995-1-1',4),
('TP31-43/414','计算机原理/侯炳辉主编','7-5058-0920-2/19.6','239;26cm',NULL,'1996-1-1',5),
('TP399:H31/47:2','计算机英语/刘兆毓主编','7-302-02480-4/24.00','358;26cm',NULL,'1997-1-1',6),
('TP34/1122','计算机模拟/郭绍禧等编著','7-81021-090-4/$3.00','229页;26cm',NULL,'1989-2-1',7)
GO

--向评论信息表插入数据
INSERT INTO commentInfo(comment, commentDate, bookTypeMark, readerSysId)
VALUES('这本书非常的好看!!!!!','2017-5-1','TP391.4/189',1),
('这是一本非常有用的书。','2016-12-5','TP34/1122',2),
('这本书推荐给大家。','2017-4-26','TP312/2281',3)
GO

--插入学科主题
INSERT INTO subjectMatterInfo(subjectMatterName)
VALUES('C语言-程序设计'),
('教材-高等学校-计算机模拟'),
('计算机'),
('绘图'),
('电脑编程-维护')
GO

--向主题与图书类型信息表中插入数据
INSERT INTO subjectMatterAndBookTypeInfo(subjectMatterSysId, bookTypeSysId)
VALUES(1,1),
(2,7),
(3,5),
(3,4),
(3,3),
(4,4),
(5,2)
GO

--向图书表中插入信息
INSERT INTO bookInfo(bookMark, campusCollection, bookPosiTion, bookTypeMark)
VALUES('0605421','科学校区—科学校区待注销书库（负一层五区）','定位','TP312/2281'),
('0605414','科学校区—科学校区样本书区（六层）','定位','TP312/2281'),
('0605415','科学校区—科学校区中文密集书区（负一层二、三、四区）','定位','TP312/2281'),
('0605416','科学校区—科学校区中文密集书区（负一层二、三、四区）','定位','TP312/2281'),
('0605417','东风校区—东风校区工业技术学习空间（二层北）','定位','TP312/2281'),
('0605418','东风校区—东风校区工业技术学习空间（二层北）','定位','TP312/2281'),
('0605419','东风校区—东风校区工业技术学习空间（二层北）','定位','TP312/2281'),
('0605420','东风校区—东风校区工业技术学习空间（二层北）','定位','TP312/2281'),
('0780771','科学校区—科学校区三线书库（负一层五区）','定位','TP314 /1/1'),
('0780770','科学校区—科学校区样本书区（六层）','定位','TP314 /1/1'),
('0780769','科学校区—科学校区中文密集书区（负一层二、三、四区)','定位','TP314 /1/1'),
('0206653','东风校区—东风校区中文密集书区(一层)','定位','H319.5/179'),
('0268149','科学校区—科学校区样本书区（六层)','定位','TP391.4/189'),
('0268146','科学校区—科学校区中文密集书区（负一层二、三、四区）','定位','TP391.4/189'),
('0269537','科学校区—科学校区中文密集书区（负一层二、三、四区）','定位','TP31-43/414'),
('0269947','科学校区—科学校区中文密集书区（负一层二、三、四区）','定位','TP399:H31/47:2'),
('0067376','科学校区—科学校区中文密集书区（负一层二、三、四区） ','定位','TP34/1122')
GO

--借阅表数据的插入操作		--必须一条一条的进行插入操作
INSERT INTO lendingInfo(lendingDate,readerSysId,bookInfoSysId)
VALUES('2017-1-1','1','1')
GO
---------------------------------------------------------------------------------------------------------------------


--创建指定视图的操作
---------------------------------------------------------------------------------------------------------------------

--未归还图书及其借阅者的相关信息
CREATE VIEW V_NoReturnBookInfo
AS
SELECT bookInfo.bookMark AS 图书条码,readerInfo.readerName AS 借阅者姓名,readerInfo.readerNum AS 借阅者编号,lendingInfo.lendingDate AS 借阅日期,lendingInfo.returnDate AS 应归还日期
FROM bookInfo,lendingInfo,readerInfo
WHERE lendingInfo.readerSysId = readerInfo.readerSysId AND lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.actualReturnDate IS NULL
GO

--所有借阅过图书的借阅量信息
CREATE VIEW V_BookLendingNum
AS
SELECT bookInfo.bookTypeMark AS 索书号,COUNT(bookInfo.bookTypeMark) AS 历史借阅量
FROM lendingInfo,bookInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId
GROUP By bookInfo.bookTypeMark
GO

--主题与书本类型信息
CREATE VIEW V_MatterAndBookTypeInfo
AS
SELECT V_BookLendingNum.索书号 AS 索书号,subjectMatterInfo.subjectMatterName AS 主题词,COUNT(V_BookLendingNum.历史借阅量) AS 历史借阅量
FROM bookTypeInfo,subjectMatterInfo,subjectMatterAndBookTypeInfo,V_BookLendingNum
WHERE subjectMatterAndBookTypeInfo.bookTypeSysId = bookTypeInfo.bookTypeSysId AND subjectMatterAndBookTypeInfo.subjectMatterSysId = subjectMatterInfo.subjectMatterSysId AND V_BookLendingNum.索书号 = bookTypeInfo.bookTypeMark
GROUP BY V_BookLendingNum.索书号,subjectMatterInfo.subjectMatterName
GO

--根据读者编号查询未归还书籍相关信息
CREATE VIEW V_ReaderNoReturnBookInfo
AS
SELECT readerInfo.readerNum AS 读者编号,bookInfo.bookMark AS 图书条码,bookTypeInfo.bookTitleAndAuthor AS 图书名称,lendingInfo.returnDate AS 应归还日期
FROM bookInfo,bookTypeInfo,lendingInfo,readerInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.readerSysId = readerInfo.readerSysId AND bookInfo.bookTypeMark = bookTypeInfo.bookTypeMark AND lendingInfo.actualReturnDate IS NULL
GO

--根据读者信息查询其已归还图书信息
CREATE VIEW V_ReaderReturnBookInfo
AS
SELECT readerInfo.readerNum AS 读者编号,bookInfo.bookMark AS 图书条码,bookTypeInfo.bookTitleAndAuthor AS 图书名称,lendingInfo.lendingDate AS 借阅日期,lendingInfo.actualReturnDate AS 实际归还日期
FROM bookInfo,bookTypeInfo,lendingInfo,readerInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.readerSysId = readerInfo.readerSysId AND bookInfo.bookTypeMark = bookTypeInfo.bookTypeMark AND lendingInfo.actualReturnDate IS NOT NULL
GO

--读者发表的书评
CREATE VIEW V_ReaderAndComment
AS
SELECT readerInfo.readerNum AS 读者编号,bookTypeInfo.bookTitleAndAuthor AS 图书名称,commentInfo.commentDate AS 评论日期,commentInfo.comment AS 评论内容
FROM readerInfo,bookTypeInfo,commentInfo
WHERE commentInfo.readerSysId = readerInfo.readerSysId AND commentInfo.bookTypeMark = bookTypeInfo.bookTypeMark
GO

--出版社及其出版的书籍
CREATE VIEW V_PressAndBookType
AS
SELECT pressInfo.pressName AS 出版社名称,bookTypeInfo.bookTitleAndAuthor AS 图书名称,bookTypeInfo.bookTypePrintDate
FROM pressInfo,bookTypeInfo
WHERE bookTypeInfo.PressSysId = pressInfo.pressSysId
GROUP BY bookTypeInfo.bookTypePrintDate,pressInfo.pressName,bookTypeInfo.bookTitleAndAuthor
GO
--------------------------------------------------------------------------------------------------------------------------------


--创建存储过程用来向关系表中插入数据

--向rankInfo表的数据插入操作
CREATE PROC proc_rankInfo_insert
@readerRank TINYINT, 
@maxBorrowBook TINYINT, 
@maxDelegationBook TINYINT, 
@maxOrderBook TINYINT, 
@maxBorrowDate INT
AS
BEGIN
	INSERT INTO rankInfo(readerRank, maxBorrowBook, maxDelegationBook, maxOrderBook, maxBorrowDate)
	VALUES(@readerRank, @maxBorrowBook, @maxDelegationBook, @maxOrderBook, @maxBorrowDate)
END
GO

--向readerInfo关系表中插入数据
CREATE PROC proc_readerInfo_insert
@readerName NVARCHAR(8), 
@readerGender BIT, 
@readerNum VARCHAR(12), 
@readerClass NVARCHAR(16), 
@readerEmail NVARCHAR(32), 
@readerPhone CHAR(11), 
@readerRegistrationDate DATE, 
@readerEffectiveDate DATE, 
@readerRank TINYINT
AS
BEGIN
	INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
	VALUES(@readerName, @readerGender, @readerNum, @readerClass, @readerEmail, @readerPhone, @readerRegistrationDate, @readerEffectiveDate, @readerRank)
END
GO

--向pressInfo关系好表中插入数据
CREATE PROC proc_pressInfo_insert 
@pressName NVARCHAR(32)
AS 
BEGIN
	INSERT INTO pressInfo(pressName)
	VALUES(@pressName)
END
GO

--向bookTypeInfo关系表中插入数据
CREATE PROC proc_bookTypeInfo_insert
@bookTypeMark NVARCHAR(16), 
@bookTitleAndAuthor NVARCHAR(32), 
@isbnAndPrice NVARCHAR(64), 
@bookTypeMorphological NVARCHAR(32), 
@bookTypeSeries NVARCHAR(32), 
@bookTypePrintDate DATE, 
@PressSysId INT
AS
BEGIN
	INSERT INTO bookTypeInfo(bookTypeMark, bookTitleAndAuthor, isbnAndPrice, bookTypeMorphological, bookTypeSeries, bookTypePrintDate, PressSysId)
	VALUES(@bookTypeMark, @bookTitleAndAuthor, @isbnAndPrice, @bookTypeMorphological,@bookTypeSeries,@bookTypePrintDate, @PressSysId)
END
GO

--向commentInfo关系表中插入数据
CREATE PROC proc_commentInfo_insert
@comment NVARCHAR(128), 
@commentDate DATE, 
@bookTypeMark NVARCHAR(16), 
@readerSysId INT
AS
BEGIN
	INSERT INTO commentInfo(comment, commentDate, bookTypeMark, readerSysId)
	VALUES(@comment, @commentDate, @bookTypeMark, @readerSysId)
END
GO

--向subjectMatterInfo关系表中插入数据
CREATE PROC proc_subjectMatterInfo_insert
@subjectMatterName NVARCHAR(16)
AS
BEGIN
	INSERT INTO subjectMatterInfo(subjectMatterName)
	VALUES(@subjectMatterName)
END
GO

--向subjectMatterAndBookTypeInfo关系表中插入数据
CREATE PROC proc_subjectMatterAndBookTypeInfo_insert
@subjectMatterSysId INT, 
@bookTypeSysId INT
AS
BEGIN
	INSERT INTO subjectMatterAndBookTypeInfo(subjectMatterSysId, bookTypeSysId)
	VALUES(@subjectMatterSysId, @bookTypeSysId)
END
GO

--向bookInfo关系表中插入数据
CREATE PROC proc_bookInfo_insert
@bookMark CHAR(7), 
@campusCollection NVARCHAR(64), 
@bookPosiTion NVARCHAR(32), 
@bookTypeMark NVARCHAR(16)
AS
BEGIN
	INSERT INTO bookInfo(bookMark, campusCollection, bookPosiTion, bookTypeMark)
	VALUES(@bookMark, @campusCollection, @bookPosiTion, @bookTypeMark)
END
GO

--向lendingInfo关系表中插入数据
CREATE PROC proc_lendingInfo_insert
@lendingDate DATE,
@readerSysId INT,
@bookInfoSysId INT
AS
BEGIN
	INSERT INTO lendingInfo(lendingDate,readerSysId,bookInfoSysId)
	VALUES(@lendingDate,@readerSysId,@bookInfoSysId)
END
GO

--显示与某主题词相关的所有图书编号和历史总借阅量			--参数为主题词名称
CREATE PROC proc_V_MatterAndBookTypeInfo
@主题词 NVARCHAR(16)
AS
BEGIN
	SELECT 索书号, 历史借阅量
	FROM V_MatterAndBookTypeInfo 
	WHERE 主题词 = @主题词
END
GO

--显示某读者的编号和其当前所有未归还图书的条码、图书名称和应还日期；		--参数读者编号
CREATE PROC proc_V_ReaderNoReturnBookInfo
@读者编号 VARCHAR(12)
AS
BEGIN
	SELECT 读者编号, 图书条码, 图书名称, 应归还日期
	FROM V_ReaderNoReturnBookInfo
	WHERE 读者编号 = @读者编号
END
GO

--显示某读者的编号和其对应的历史借阅信息，包括图书条码、图书名称、实际借阅日期和实际归还日期；	--参数读者编号
CREATE PROC proc_V_ReaderReturnBookInfo
@读者编号 VARCHAR(12)
AS
BEGIN
	SELECT 读者编号, 图书条码, 图书名称, 借阅日期, 实际归还日期
	FROM V_ReaderReturnBookInfo
	WHERE 读者编号 = @读者编号
END
GO

--显示某读者编号和其发表的书评内容，包括评论的图书名称、评论时间和评论内容；			--参数读者编号
CREATE PROC proc_V_ReaderAndComment
@读者编号 VARCHAR(12)
AS
BEGIN
	SELECT 读者编号, 图书名称, 评论日期, 评论内容
	FROM V_ReaderAndComment
	WHERE 读者编号 = @读者编号
END
GO

--显示某出版社名称及其出版的所有图书名称，并按年代分组。						--参数出版社名称
CREATE PROC proc_V_BookLendingNum
@出版社名称 NVARCHAR(32)
AS
BEGIN
	SELECT 出版社名称, 图书名称, bookTypePrintDate
	FROM V_PressAndBookType
	WHERE 出版社名称 = @出版社名称
END
GO


SELECT * 
FROM [dbo].[V_BookLendingNum]

SELECT * 
FROM [dbo].[V_MatterAndBookTypeInfo]

SELECT * 
FROM [dbo].[V_NoReturnBookInfo]

SELECT * 
FROM [dbo].[V_PressAndBookType]

SELECT * 
FROM [dbo].[V_ReaderAndComment]

SELECT * 
FROM [dbo].[V_ReaderNoReturnBookInfo]


UPDATE lendingInfo SET actualReturnDate = '2017-5-1'
WHERE lendingInfoSysId = 1
SELECT * 
FROM [dbo].[V_ReaderReturnBookInfo]

EXEC proc_lendingInfo_insert '2017-4-1',1,2

EXEC proc_V_BookLendingNum '电子工业出版社'
EXEC proc_V_MatterAndBookTypeInfo 'C语言-程序设计'
EXEC proc_V_ReaderAndComment '541607030101'
EXEC proc_V_ReaderNoReturnBookInfo '541607030101'
EXEC proc_V_ReaderReturnBookInfo '541607030101'