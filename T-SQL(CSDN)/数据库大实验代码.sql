/************************************************************************
 *�Ŵ��ϵ��:
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
 *����������(�Թ�ϵ�������Ե�����)��
 *1�����ߵ�֤����Ч���ڴ��ڻ���ڰ�֤����							--[TR_readerInfo_readerEffectiveDate]
 *2�����߽��ĵȼ������������ֱ�Ӿ���	��ÿ����100���ȼ���һ��		
 *   ���ߵ�Ƿ��������Υ�´���ֱ�Ӿ���	��ÿΥ��һ�η���10Ԫ��		--[TR_readerInfo_readerBorrowLevelAndreaderDebtMoney]
 *3������������ʱ�����ߵ��ۼƽ�������Ҫ�����仯����Ӧ�黹������ϵͳ�����д��ͼ���״̬��ϢҲͬ�������仯	��Ĭ��һ�β���һ�����ݡ�������Ϣ�Ѵ��ڣ�--[TR_lendingInfo_readerInfo_readerBookCount]
 *4�����黹ͼ��ʱ����Ҫ�ж϶����Ƿ���Υ�²�������ʵ�ʵĹ黹ʱ�������ڻ���ڽ���ʱ�䣬ͼ���״̬��ϢҲͬ�������仯	��Ĭ��һ�β���һ�����ݡ�������Ϣ�Ѵ��ڣ�		--[TR_lendingInfo_readerInfo_readerViolationCount]
 *
 *
 *��Ҫ��ͼ�Ĵ���:
 *��ͼ1����ʾ���е�ǰ��δ�黹��ͼ�����롢��������������Լ���š�����ʱ���Ӧ��ʱ�䣻
 *��ͼ2����ʾ���н��Ĺ���ͼ��Ľ�������Ϣ
 *��ͼ3����ʾ��ĳ�������ص�����ͼ���ź���ʷ�ܽ�������			--���������
 *��ͼ4����ʾĳ���ߵı�ţ���20181001�����䵱ǰ����δ�黹ͼ������롢ͼ�����ƺ�Ӧ�����ڣ�	--�������߱��
 *��ͼ5����ʾĳ���ߵı�ź����Ӧ����ʷ������Ϣ������ͼ�����롢ͼ�����ơ�ʵ�ʽ������ں�ʵ�ʹ黹���ڣ�--�������߱��
 *��ͼ6����ʾĳ���߱�ź��䷢����������ݣ��������۵�ͼ�����ơ�����ʱ����������ݣ�			--�������߱��
 *��ͼ7����ʾĳ���������Ƽ�����������ͼ�����ƣ�����������顣								--��������������
 *
 *
 *�������ϵ���в�������ݵĴ洢����:
 *1����rankInfo������ݲ������								--proc_rankInfo_insert
 *2����readerInfo��ϵ���в�������							--proc_readerInfo_insert
 *3����pressInfo��ϵ�ñ��в�������							--proc_pressInfo_insert 
 *4����bookTypeInfo��ϵ���в�������							--proc_bookTypeInfo_insert
 *5����commentInfo��ϵ���в�������							--proc_commentInfo_insert
 *6����subjectMatterInfo��ϵ���в�������					--proc_subjectMatterInfo_insert
 *7����subjectMatterAndBookTypeInfo��ϵ���в�������			--proc_subjectMatterAndBookTypeInfo_insert
 *8����bookInfo��ϵ���в�������								--proc_bookInfo_insert
 *9����lendingInfo��ϵ���в�������							--proc_lendingInfo_insert
 *10�������������Ĵ洢����������ѯָ����ͼ�е�ָ����Ϣ
 ************************************************************************/


--�����洢ͼ����Ϣ�����ݿ�

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

--��ת��ָ�������ݿ���
USE LibSystemOfZZULI
GO


--��ϵ��Ĵ���
-------------------------------------------------------------------------------------------------------------------------------
--�����ȼ���Ϣ��
CREATE TABLE rankInfo
(
	rankSysId INT IDENTITY(1,1) CONSTRAINT PK_rankInfo_SysId PRIMARY KEY,			--����ϵͳ����������
	readerRank TINYINT NOT NULL CONSTRAINT UN_rankInfo_readerRank UNIQUE,		--ΨһԼ������ѡ����
	maxBorrowBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxBorrowBook CHECK(maxBorrowBook IN(50,80,100)), --CHECKԼ��
	maxDelegationBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxDelegationBook CHECK(maxDelegationBook IN(0,1)), --CHECKԼ��
	maxOrderBook TINYINT NOT NULL CONSTRAINT CK_rankInfo_maxOrderBook CHECK(maxOrderBook IN(0,1)), --CHECKԼ��
	maxBorrowDate INT NOT NULL CONSTRAINT CK_rankInfo_maxBorrowDate CHECK(maxBorrowDate IN(3,5,6)),	--CHECKԼ��

	isDelete BIT NOT NULL CONSTRAINT DF_rankInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT CK_rankInfo_readerRank CHECK (readerRank IN(0,1,2))			--(��������0���о�����1����ʦ��2��
)
GO

--����������Ϣ��
CREATE TABLE readerInfo
(
	readerSysId INT IDENTITY(1,1) CONSTRAINT PK_readerInfo_SysId PRIMARY KEY,				--ϵͳ����������
	readerName  NVARCHAR(8) NOT NULL,								--��������
	readerGender BIT NOT NULL,										--(0:Ů��1:��)
	readerNum VARCHAR(12) NOT NULL CONSTRAINT UN_readerInfo_readerNum UNIQUE,		 --֤����
	readerClass NVARCHAR(16) NOT NULL,					--�������ڰ༶
	readerEmail VARCHAR(32) NOT NULL,					--���ߵ�Email��Ϣ
	readerPhone CHAR(11) NOT NULL,						--���ߵ��ֻ���
	readerRegistrationDate DATE NOT NULL,				--���߰�֤������
	readerEffectiveDate DATE NOT NULL,					--֤����Ч����  CHECKԼ��:����>=��֤����
	readerBookCount INT NOT NULL CONSTRAINT DF_readerInfo_readerBookCount DEFAULT 0, --�ۼƽ�����	Ĭ��Ϊ0
	readerBorrowLevel TINYINT NOT NULL CONSTRAINT DF_readerInfo_readerBorrowLevel DEFAULT 1, --���ĵȼ�	 Ĭ��Ϊ1,���ۼƽ������ж�
	readerViolationCount INT NOT NULL CONSTRAINT DF_readerInfo_readerViolationCount DEFAULT 0, --Υ�´���	Ĭ��Ϊ0
	readerDebtMoney MONEY NOT NULL CONSTRAINT DF_readerInfo_readerDebtMoney DEFAULT 0, --Ƿ����	Ĭ��Ϊ0

	readerRank TINYINT NOT NULL, --���(��ȼ���Ϣ�������)
	isDelete BIT NOT NULL CONSTRAINT DF_readerInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_readerInfo_readerRank_rankInfo_readerRank FOREIGN KEY(readerRank) REFERENCES rankInfo(readerRank)	--�������
)
GO

--����������

--ָ��֤����Ч���ڱ�����ڻ���ڰ�֤����
CREATE TRIGGER TR_readerInfo_readerEffectiveDate
ON readerInfo
WITH ENCRYPTION			--����
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
	 PRINT '��������ڲ����Ϲ淶'
END
GO

--����������ָ�����ĵȼ���������Ĺ�ϵ�Լ�Ƿ������Υ�´����Ĺ�ϵ
CREATE TRIGGER TR_readerInfo_readerBorrowLevelAndreaderDebtMoney
ON readerInfo
WITH ENCRYPTION			--����
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

--������������Ϣ��
CREATE TABLE pressInfo
(
	pressSysId INT IDENTITY(1,1) CONSTRAINT PK_pressInfo_pressId PRIMARY KEY,				--���������������������
	pressName NVARCHAR(32) NOT NULL CONSTRAINT UN_pressInfo_pressName UNIQUE,		--����������

	isDelete BIT NOT NULL CONSTRAINT DF_pressInfo_isDelete DEFAULT 0,				--ɾ����ʾ
)
GO

--����ͼ��������Ϣ��
CREATE TABLE bookTypeInfo
(
	bookTypeSysId INT IDENTITY(1,1) CONSTRAINT PK_bookTypeInfo_sysId PRIMARY KEY,			--����ϵͳ����������
	bookTypeMark NVARCHAR(16) NOT NULL CONSTRAINT UN_bookTypeInfo_bookMark UNIQUE,		--�����
	bookTitleAndAuthor NVARCHAR(32) NOT NULL,										--����/������
	isbnAndPrice NVARCHAR(64) NOT NULL,												--ISBN������
	bookTypeMorphological NVARCHAR(32) NOT NULL,										--������̬��
	bookTypeSeries NVARCHAR(32) NULL,												--�Ա���
	bookTypePrintDate DATE NOT NULL,													--ӡˢʱ��

	PressSysId INT NOT NULL,				--���淢����			��������������Ϣ���������
	isDelete BIT NOT NULL CONSTRAINT DF_bookTypeInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_bookTypeInfo_PressSysId_pressInfo_PressSysId FOREIGN KEY(PressSysId) REFERENCES pressInfo(PressSysId)
)
GO

--����������Ϣ��
CREATE TABLE commentInfo
(
	commentSysId INT IDENTITY(1,1) CONSTRAINT PK_commentInfo_sysId PRIMARY KEY,			--ϵͳ����������
	comment NVARCHAR(128) NOT NULL,														--��������
	commentDate DATE NOT NULL,															--��������
	
	bookTypeMark  NVARCHAR(16) NOT NULL,													--ͼ�����ͣ������
	readerSysId INT NOT NULL,															--���߱�ţ������
	isDelete BIT NOT NULL CONSTRAINT DF_commentInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_commentInfo_bookTypeMark_bookTypeInfo_bookTypeMark FOREIGN KEY(bookTypeMark) REFERENCES bookTypeInfo(bookTypeMark),
	CONSTRAINT FK_commentInfo_readerSysId_readerInfo_readerSysId FOREIGN KEY(readerSysId) REFERENCES readerInfo(readerSysId)
)
GO

--����ѧ��������Ϣ��
CREATE TABLE subjectMatterInfo
(
	subjectMatterSysId INT IDENTITY(1,1) CONSTRAINT PK_subjectMatterInfo_subjectMatterSysId PRIMARY KEY,	--ϵͳ����������
	subjectMatterName NVARCHAR(16) NOT NULL,											--ѧ����������

	isDelete BIT NOT NULL CONSTRAINT DF_subjectMatterInfo_isDelete DEFAULT 0,				--ɾ����ʾ
)
GO

--����ѧ��������Ϣ��ͼ��������Ϣ��
CREATE TABLE subjectMatterAndBookTypeInfo
(
	subjectMatterAndBookTypeInfoSysId INT IDENTITY(1,1) CONSTRAINT PK_subjectMatterAndBookTypeInfo_subjectMatterAndBookTypeInfoSysId PRIMARY KEY,				--ϵͳ����������

	subjectMatterSysId INT NOT NULL,					--ѧ���������
	bookTypeSysId INT NOT NULL,							--ͼ���������
	isDelete BIT NOT NULL CONSTRAINT DF_subjectMatterAndBookTypeInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_subjectMatterAndBookTypeInfo_subjectMatterSysId_subjectMatterInfo_subjectMatterSysId FOREIGN KEY (subjectMatterSysId) REFERENCES subjectMatterInfo(subjectMatterSysId),
	CONSTRAINT FK_subjectMatterAndBookTypeInfo_bookTypeSysId__bookTypeSysId FOREIGN KEY (bookTypeSysId) REFERENCES bookTypeInfo(bookTypeSysId)
)
GO

--ͼ����Ϣ��
CREATE TABLE bookInfo
(
	bookInfoSysId INT IDENTITY(1,1) CONSTRAINT PK_bookInfo_bookInfoSysId PRIMARY KEY,		--ϵͳ����������
	bookMark CHAR(7) NOT NULL CONSTRAINT UN_bookInfo_bookMark UNIQUE,						--ͼ�������룬Ψһ��ʾͼ��
	campusCollection NVARCHAR(64) NOT NULL,													--У��-�ݲص�
	bookStatus BIT NOT NULL CONSTRAINT DF_bookInfo_bookStatus DEFAULT 1,					--�鿯״̬
	bookPosiTion NVARCHAR(32) NULL,														--ͼ�鶨λ

	bookTypeMark NVARCHAR(16) NOT NULL,														--ͼ�����ͣ������
	isDelete BIT NOT NULL CONSTRAINT DF_bookInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_bookInfo_bookTypeMark_bookTypeInfo_bookTypeMark FOREIGN KEY(bookTypeMark) REFERENCES bookTypeInfo(bookTypeMark)
)
GO

--����������Ϣ��
CREATE TABLE lendingInfo
(
	lendingInfoSysId INT IDENTITY(1,1) CONSTRAINT KF_lendingInfo_lendingInfoSysId PRIMARY KEY,		--ϵͳ����������
	lendingDate DATE NOT NULL,															--��������
	returnDate DATE NULL,							--���ݽ���ʱ�䡢���ߵȼ�����õ�	����������룩
	actualReturnDate DATE NULL,										-- ʵ�ʹ黹ʱ��>=����ʱ��	--����Ϊ��
	returnPosition NVARCHAR(32) NULL,							--ʵ�ʹ黹ʱ��		--����Ϊ��

	readerSysId INT NOT NULL,						--������������Ϣ�������
	bookInfoSysId INT NOT NULL,						--�������ͼ����Ϣ�ȹ�����

	isDelete BIT NOT NULL CONSTRAINT DF_lendingInfo_isDelete DEFAULT 0,				--ɾ����ʾ

	CONSTRAINT FK_lendingInfo_readerSysId_readerInfo_readerSysId FOREIGN KEY(readerSysId) REFERENCES readerInfo(readerSysId),
	CONSTRAINT FK_lendingInfo_bookInfoSysId_bookInfo_bookInfoSysId FOREIGN KEY(bookInfoSysId) REFERENCES bookInfo(bookInfoSysId)
)
GO

--Ϊ������Ϣ����������

--����һ���������жϸ����Ƿ�ɽ�
CREATE TRIGGER TR_lendingInfo_bookStatus
ON lendingInfo
WITH ENCRYPTION			--����
INSTEAD OF INSERT
AS 
BEGIN
	DECLARE @bookStatus BIT,@bookInfoSysId INT
	SET @bookInfoSysId = (SELECT bookInfoSysId FROM inserted)
	SET @bookStatus = (SELECT bookStatus FROM bookInfo WHERE bookInfoSysId = @bookInfoSysId)
	IF @bookStatus = 0
		PRINT '���鲻�ɽ�'
	ELSE
		INSERT INTO lendingInfo(lendingDate, returnDate, actualReturnDate, returnPosition, readerSysId, bookInfoSysId)
		SELECT lendingDate, returnDate, actualReturnDate, returnPosition, readerSysId, bookInfoSysId 
		FROM inserted
END
GO

--������в�������ʱ,ͬʱ�Զ��ߵ��ۼ��Ķ�����Ϣ���и��£��Լ����㱾��Ĺ黹����,ͼ��״̬����Ϊ���ɽ�
CREATE TRIGGER TR_lendingInfo_returnDate_And_readerInfo_readerBookCount
ON lendingInfo
WITH ENCRYPTION			--����
AFTER INSERT
AS
BEGIN
	--�ۼ��Ķ����޸�
	DECLARE @readerSysId INT
	SET @readerSysId = (SELECT readerSysId FROM inserted)					--Ĭ�϶�����Ϣ�����Ѿ���洢�ö�����Ϣ
	UPDATE readerInfo SET readerInfo.readerBookCount += 1 WHERE readerInfo.readerSysId = @readerSysId

	--Ӧ�黹���ڵļ���
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

--��������޸����ݺ�,ͬʱ�Զ��ߵ�Υ�ʹ�����Ϣ�����޸�
CREATE TRIGGER TR_lendingInfo_readerInfo_readerViolationCount
ON lendingInfo
WITH ENCRYPTION			--����
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
	 SET @readerSysId = (SELECT readerSysId FROM inserted)					--Ĭ�϶�����Ϣ�����Ѿ���洢�ö�����Ϣ
	 IF @lendingDate <=  @actualReturnDate
	 BEGIN
		IF @actualReturnDate > @returnDate
		 BEGIN
		  UPDATE readerInfo SET readerInfo.readerViolationCount += 1 WHERE readerInfo.readerSysId = @readerSysId
		  UPDATE bookInfo SET bookStatus = 1 WHERE bookInfoSysId = @bookInfoSysId
		 END
	 END
	 ELSE
		PRINT 'ʵ�ʹ黹���ڱ�����ڻ���ڽ�������'
	END
END
GO
---------------------------------------------------------------------------------------------------------------------


--�����ݱ��в�������
---------------------------------------------------------------------------------------------------------------------

--�ȼ�������ݲ������
INSERT INTO rankInfo(readerRank, maxBorrowBook, maxDelegationBook, maxOrderBook, maxBorrowDate)
VALUES(0,50,0,0,3),
(1,80,0,0,5),
(2,100,1,1,6)
GO

--������Ϣ�������		--����һ��һ���Ľ��в���
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES('��ѩ��',0,'541607030101','���繤��1601','10857821@qq.com','13345897664','2016-9-1','2016-9-1',0)

INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',1,'541607030102','���繤��1601','10857901@qq.com','15837177392','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',1,'541607030103','���繤��1601','10556788@qq.com','15837177395','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('��ѩ��',1,'20164548','���繤��1601','10839577@qq.com','15837177537','2016-9-1','2016-9-1',1)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',0,'541607030105','���繤��1601','10851703@qq.com','15837177801','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('��ˬ',0,'541607030106','���繤��1601','10853257@qq.com','15837177805','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',1,'541607030107','���繤��1601','10856381@qq.com','15837177865','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',1,'20164549','���繤��1601','10857039@qq.com','15837177927','2016-9-1','2016-10-1',1)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('������',1,'541607030109','���繤��1601','10857507@qq.com','13692588338','2016-9-1','2016-9-1',0)
INSERT INTO readerInfo(readerName, readerGender, readerNum, readerClass, readerEmail, readerPhone, readerRegistrationDate, readerEffectiveDate, readerRank)
VALUES
('����',0,'1999012','���繤��1601','10859239@qq.com','13692599339','2016-9-1','2016-9-1',2)
GO

--��������Ϣ������ݲ������
INSERT INTO pressInfo(pressName)
VALUES('���ӹ�ҵ������'),
('�����Ա�̼�����ά������־��'),
('�Ϻ����ĳ�����'),
('�ɶ��Ƽ���ѧ������'),
('���ÿ�ѧ������'),
('�廪��ѧ������'),
('�й���ҵ��ѧ������')
GO

--ͼ��������Ϣ������ݲ���
INSERT INTO bookTypeInfo(bookTypeMark, bookTitleAndAuthor, isbnAndPrice, bookTypeMorphological, bookTypeSeries, bookTypePrintDate, PressSysId)
VALUES('TP312/2281','Visual C#.NETӦ�ñ��150��/���������','7-5053-8936-X/35.00','401ҳ;28cm','���ɳ������','2003-8-1',1),
('TP314 /1/1','���Ա�̼�����ά�����ϣ�/�����Ա�̼�����ά������־���','7-89994-056-7/29','455ҳ;29cm+����1��10465-74',NULL,'2005-1-1',2),
('H319.5/179','�����/������,��ʿԴע��','7-/.17','63;19cm',NULL,'1980-8-1',3),
('TP391.4/189','�������ͼ/����, ��Ԫ�ɱ���','7-5616-3027-1/14','220;26cm',NULL,'1995-1-1',4),
('TP31-43/414','�����ԭ��/���������','7-5058-0920-2/19.6','239;26cm',NULL,'1996-1-1',5),
('TP399:H31/47:2','�����Ӣ��/����ع����','7-302-02480-4/24.00','358;26cm',NULL,'1997-1-1',6),
('TP34/1122','�����ģ��/�������ȱ���','7-81021-090-4/$3.00','229ҳ;26cm',NULL,'1989-2-1',7)
GO

--��������Ϣ���������
INSERT INTO commentInfo(comment, commentDate, bookTypeMark, readerSysId)
VALUES('�Ȿ��ǳ��ĺÿ�!!!!!','2017-5-1','TP391.4/189',1),
('����һ���ǳ����õ��顣','2016-12-5','TP34/1122',2),
('�Ȿ���Ƽ�����ҡ�','2017-4-26','TP312/2281',3)
GO

--����ѧ������
INSERT INTO subjectMatterInfo(subjectMatterName)
VALUES('C����-�������'),
('�̲�-�ߵ�ѧУ-�����ģ��'),
('�����'),
('��ͼ'),
('���Ա��-ά��')
GO

--��������ͼ��������Ϣ���в�������
INSERT INTO subjectMatterAndBookTypeInfo(subjectMatterSysId, bookTypeSysId)
VALUES(1,1),
(2,7),
(3,5),
(3,4),
(3,3),
(4,4),
(5,2)
GO

--��ͼ����в�����Ϣ
INSERT INTO bookInfo(bookMark, campusCollection, bookPosiTion, bookTypeMark)
VALUES('0605421','��ѧУ������ѧУ����ע����⣨��һ��������','��λ','TP312/2281'),
('0605414','��ѧУ������ѧУ���������������㣩','��λ','TP312/2281'),
('0605415','��ѧУ������ѧУ�������ܼ���������һ���������������','��λ','TP312/2281'),
('0605416','��ѧУ������ѧУ�������ܼ���������һ���������������','��λ','TP312/2281'),
('0605417','����У��������У����ҵ����ѧϰ�ռ䣨���㱱��','��λ','TP312/2281'),
('0605418','����У��������У����ҵ����ѧϰ�ռ䣨���㱱��','��λ','TP312/2281'),
('0605419','����У��������У����ҵ����ѧϰ�ռ䣨���㱱��','��λ','TP312/2281'),
('0605420','����У��������У����ҵ����ѧϰ�ռ䣨���㱱��','��λ','TP312/2281'),
('0780771','��ѧУ������ѧУ��������⣨��һ��������','��λ','TP314 /1/1'),
('0780770','��ѧУ������ѧУ���������������㣩','��λ','TP314 /1/1'),
('0780769','��ѧУ������ѧУ�������ܼ���������һ�������������)','��λ','TP314 /1/1'),
('0206653','����У��������У�������ܼ�����(һ��)','��λ','H319.5/179'),
('0268149','��ѧУ������ѧУ����������������)','��λ','TP391.4/189'),
('0268146','��ѧУ������ѧУ�������ܼ���������һ���������������','��λ','TP391.4/189'),
('0269537','��ѧУ������ѧУ�������ܼ���������һ���������������','��λ','TP31-43/414'),
('0269947','��ѧУ������ѧУ�������ܼ���������һ���������������','��λ','TP399:H31/47:2'),
('0067376','��ѧУ������ѧУ�������ܼ���������һ��������������� ','��λ','TP34/1122')
GO

--���ı����ݵĲ������		--����һ��һ���Ľ��в������
INSERT INTO lendingInfo(lendingDate,readerSysId,bookInfoSysId)
VALUES('2017-1-1','1','1')
GO
---------------------------------------------------------------------------------------------------------------------


--����ָ����ͼ�Ĳ���
---------------------------------------------------------------------------------------------------------------------

--δ�黹ͼ�鼰������ߵ������Ϣ
CREATE VIEW V_NoReturnBookInfo
AS
SELECT bookInfo.bookMark AS ͼ������,readerInfo.readerName AS ����������,readerInfo.readerNum AS �����߱��,lendingInfo.lendingDate AS ��������,lendingInfo.returnDate AS Ӧ�黹����
FROM bookInfo,lendingInfo,readerInfo
WHERE lendingInfo.readerSysId = readerInfo.readerSysId AND lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.actualReturnDate IS NULL
GO

--���н��Ĺ�ͼ��Ľ�������Ϣ
CREATE VIEW V_BookLendingNum
AS
SELECT bookInfo.bookTypeMark AS �����,COUNT(bookInfo.bookTypeMark) AS ��ʷ������
FROM lendingInfo,bookInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId
GROUP By bookInfo.bookTypeMark
GO

--�������鱾������Ϣ
CREATE VIEW V_MatterAndBookTypeInfo
AS
SELECT V_BookLendingNum.����� AS �����,subjectMatterInfo.subjectMatterName AS �����,COUNT(V_BookLendingNum.��ʷ������) AS ��ʷ������
FROM bookTypeInfo,subjectMatterInfo,subjectMatterAndBookTypeInfo,V_BookLendingNum
WHERE subjectMatterAndBookTypeInfo.bookTypeSysId = bookTypeInfo.bookTypeSysId AND subjectMatterAndBookTypeInfo.subjectMatterSysId = subjectMatterInfo.subjectMatterSysId AND V_BookLendingNum.����� = bookTypeInfo.bookTypeMark
GROUP BY V_BookLendingNum.�����,subjectMatterInfo.subjectMatterName
GO

--���ݶ��߱�Ų�ѯδ�黹�鼮�����Ϣ
CREATE VIEW V_ReaderNoReturnBookInfo
AS
SELECT readerInfo.readerNum AS ���߱��,bookInfo.bookMark AS ͼ������,bookTypeInfo.bookTitleAndAuthor AS ͼ������,lendingInfo.returnDate AS Ӧ�黹����
FROM bookInfo,bookTypeInfo,lendingInfo,readerInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.readerSysId = readerInfo.readerSysId AND bookInfo.bookTypeMark = bookTypeInfo.bookTypeMark AND lendingInfo.actualReturnDate IS NULL
GO

--���ݶ�����Ϣ��ѯ���ѹ黹ͼ����Ϣ
CREATE VIEW V_ReaderReturnBookInfo
AS
SELECT readerInfo.readerNum AS ���߱��,bookInfo.bookMark AS ͼ������,bookTypeInfo.bookTitleAndAuthor AS ͼ������,lendingInfo.lendingDate AS ��������,lendingInfo.actualReturnDate AS ʵ�ʹ黹����
FROM bookInfo,bookTypeInfo,lendingInfo,readerInfo
WHERE lendingInfo.bookInfoSysId = bookInfo.bookInfoSysId AND lendingInfo.readerSysId = readerInfo.readerSysId AND bookInfo.bookTypeMark = bookTypeInfo.bookTypeMark AND lendingInfo.actualReturnDate IS NOT NULL
GO

--���߷��������
CREATE VIEW V_ReaderAndComment
AS
SELECT readerInfo.readerNum AS ���߱��,bookTypeInfo.bookTitleAndAuthor AS ͼ������,commentInfo.commentDate AS ��������,commentInfo.comment AS ��������
FROM readerInfo,bookTypeInfo,commentInfo
WHERE commentInfo.readerSysId = readerInfo.readerSysId AND commentInfo.bookTypeMark = bookTypeInfo.bookTypeMark
GO

--�����缰�������鼮
CREATE VIEW V_PressAndBookType
AS
SELECT pressInfo.pressName AS ����������,bookTypeInfo.bookTitleAndAuthor AS ͼ������,bookTypeInfo.bookTypePrintDate
FROM pressInfo,bookTypeInfo
WHERE bookTypeInfo.PressSysId = pressInfo.pressSysId
GROUP BY bookTypeInfo.bookTypePrintDate,pressInfo.pressName,bookTypeInfo.bookTitleAndAuthor
GO
--------------------------------------------------------------------------------------------------------------------------------


--�����洢�����������ϵ���в�������

--��rankInfo������ݲ������
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

--��readerInfo��ϵ���в�������
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

--��pressInfo��ϵ�ñ��в�������
CREATE PROC proc_pressInfo_insert 
@pressName NVARCHAR(32)
AS 
BEGIN
	INSERT INTO pressInfo(pressName)
	VALUES(@pressName)
END
GO

--��bookTypeInfo��ϵ���в�������
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

--��commentInfo��ϵ���в�������
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

--��subjectMatterInfo��ϵ���в�������
CREATE PROC proc_subjectMatterInfo_insert
@subjectMatterName NVARCHAR(16)
AS
BEGIN
	INSERT INTO subjectMatterInfo(subjectMatterName)
	VALUES(@subjectMatterName)
END
GO

--��subjectMatterAndBookTypeInfo��ϵ���в�������
CREATE PROC proc_subjectMatterAndBookTypeInfo_insert
@subjectMatterSysId INT, 
@bookTypeSysId INT
AS
BEGIN
	INSERT INTO subjectMatterAndBookTypeInfo(subjectMatterSysId, bookTypeSysId)
	VALUES(@subjectMatterSysId, @bookTypeSysId)
END
GO

--��bookInfo��ϵ���в�������
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

--��lendingInfo��ϵ���в�������
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

--��ʾ��ĳ�������ص�����ͼ���ź���ʷ�ܽ�����			--����Ϊ���������
CREATE PROC proc_V_MatterAndBookTypeInfo
@����� NVARCHAR(16)
AS
BEGIN
	SELECT �����, ��ʷ������
	FROM V_MatterAndBookTypeInfo 
	WHERE ����� = @�����
END
GO

--��ʾĳ���ߵı�ź��䵱ǰ����δ�黹ͼ������롢ͼ�����ƺ�Ӧ�����ڣ�		--�������߱��
CREATE PROC proc_V_ReaderNoReturnBookInfo
@���߱�� VARCHAR(12)
AS
BEGIN
	SELECT ���߱��, ͼ������, ͼ������, Ӧ�黹����
	FROM V_ReaderNoReturnBookInfo
	WHERE ���߱�� = @���߱��
END
GO

--��ʾĳ���ߵı�ź����Ӧ����ʷ������Ϣ������ͼ�����롢ͼ�����ơ�ʵ�ʽ������ں�ʵ�ʹ黹���ڣ�	--�������߱��
CREATE PROC proc_V_ReaderReturnBookInfo
@���߱�� VARCHAR(12)
AS
BEGIN
	SELECT ���߱��, ͼ������, ͼ������, ��������, ʵ�ʹ黹����
	FROM V_ReaderReturnBookInfo
	WHERE ���߱�� = @���߱��
END
GO

--��ʾĳ���߱�ź��䷢����������ݣ��������۵�ͼ�����ơ�����ʱ����������ݣ�			--�������߱��
CREATE PROC proc_V_ReaderAndComment
@���߱�� VARCHAR(12)
AS
BEGIN
	SELECT ���߱��, ͼ������, ��������, ��������
	FROM V_ReaderAndComment
	WHERE ���߱�� = @���߱��
END
GO

--��ʾĳ���������Ƽ�����������ͼ�����ƣ�����������顣						--��������������
CREATE PROC proc_V_BookLendingNum
@���������� NVARCHAR(32)
AS
BEGIN
	SELECT ����������, ͼ������, bookTypePrintDate
	FROM V_PressAndBookType
	WHERE ���������� = @����������
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

EXEC proc_V_BookLendingNum '���ӹ�ҵ������'
EXEC proc_V_MatterAndBookTypeInfo 'C����-�������'
EXEC proc_V_ReaderAndComment '541607030101'
EXEC proc_V_ReaderNoReturnBookInfo '541607030101'
EXEC proc_V_ReaderReturnBookInfo '541607030101'