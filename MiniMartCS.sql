--เริ่มจาก Master สร้างฐานข้อมูล CSminimart
Create Database CSMinimart
--ปรับให้ฐานข้อมูลสามารถเพิ่มข้อมูลที่เป็นภาษาไทยได้
--เปลี่ยนฐานข้อมูลไปใช้ CSMinimart เปลี่ยนดมนู
Alter Database CSMinimart collate Thai_CI_AS;
--สร้างตารางข้อมูลพนักงาน ชื่อ Employees
Create Table Employess(
	EmployeeID int identity (1,1) Primary Key,
	title varchar(20) null,
	firstname varchar(50) not null,
	lastname varchar(50) null,
	position varchar(50) null,
	username varchar(50) Unique,
	passwordhash varchar(255) not null,
	IsActive bit Not null default 1
)
--สำหรับคนที่สร้างผิด ใช้ database เดิม master

--ทดสอบเพิ่มข้อมูลในตาราง Emplyees
INSERT INTO Employees
    (title, firstname, lastname,
    position, username, passwordhash)
VALUES
    ('นาย', 'วสวัตติ์', 'สุขใจ',
    'Manager', 'user101', 'hashed1');
	--เมื่อเพิ่มแล้ว ทดสอบเรียกข้อมูลออกมาดู
SELECT * FROM Employees

--สร้างตารางหมวดหมู่สินค้า Categories
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE NOT NULL,
    Description VARCHAR(200) null
)
--เพิ่มสินค้าเข้าไปใน ตาราง
INSERT INTO Categories
    (CategoryName, Description)
VALUES
	('เครื่องปรุง','เกลือ พริก น้ำตาล');

INSERT INTO Categories
    (CategoryName, Description)
VALUES
	('เครื่องดื่มเย็น','สิงค์ ลีโอ ช้าง ไฮเนเก้น');

INSERT INTO Categories
    (CategoryName, Description)
VALUES('อาหารสำเร็จรูป','มาม่า บะหมี่ ปลากระป๋อง');

INSERT INTO Categories
    (CategoryName, Description)
VALUES('เครื่องสำอาง','ลิปสติก อายลายเนอร์ ดินสอเขียนคิ้ว');

INSERT INTO Categories
    (CategoryName, Description)
VALUES('เวชภัณฑ์','ยาบ้า ยาอี ไวอาก้า ฝิ่น');

SELECT * FROM Categories

--สร้างตาราง Products โดย มีการอ้างอิงถึงข้อมูลตาราง Categories(CategoriesID)

CREATE TABLE Products (
    ProductID VARCHAR(13) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitsInStock INT NOT NULL DEFAULT 0,
    CategoryID INT NOT NULL,
    Discontinued BIT NOT NULL DEFAULT 0,

    CONSTRAINT CK_Products_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Products_UnitsInStock
        CHECK (UnitsInStock >= 0),

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

SELECT * FROM Products
--เพิ่มข้อมูลในตารางโปรดัก
INSERT INTO Products
        (ProductID, ProductName, UnitPrice,UnitsInStock, CategoryID)
VALUES
        ('8858757001948', 'โค้ก',15.00, 290, 1),
        ('8850862031030', 'สมุด5บาท',5.00, 50, 2),
        ('1891114155411', 'กระดาษ',10.00, 20, 3),
        ('8858741304589', 'สมุดจดA4',25.00, 25, 4),
        ('8851023055704', 'ปากกา',10.00, 21, 5);

        --สร้างตารางใบเสร็จ
CREATE TABLE Receipts (
    ReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptDate DATETIME NOT NULL
        DEFAULT GETDATE(),
    EmployeeID INT NOT NULL,
    TotalCash DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT CK_Receipts_TotalCash
        CHECK (TotalCash >= 0),

    CONSTRAINT FK_Receipts_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

SELECT * FROM Receipts

--เพิ่มข้อมูลในตาราง ใบเสร็จ
INSERT INTO Receipts
        (EmployeeID, TotalCash)
VALUES
    (1, 115.00);

SELECT * FROM Receipts

--เพิ่มข้อมูลที่ผิดเพื่อเช็ค(ไม่มีemployees = 99)
INSERT INTO Receipts
        (EmployeeID, TotalCash)
VALUES
    (99, 100.00);
--สร้างตาราง details
CREATE TABLE Details (
    ReceiptID INT NOT NULL,
    ProductID VARCHAR(13) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,

    CONSTRAINT PK_Details
        PRIMARY KEY (ReceiptID, ProductID),

    CONSTRAINT CK_Details_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Details_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT FK_Details_Receipts
        FOREIGN KEY (ReceiptID)
        REFERENCES Receipts(ReceiptID),

    CONSTRAINT FK_Details_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

--เพิ่มข้อมูลลงในตารางDetils
INSERT INTO Details
    (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
    (1, '8858757001948', 15.00, 3);

--เพิ่มข้อมูลที่ปิดเพื่อเช็คเนื่องจากเวลาขายสินค้าจะต้องมี1ขึ้นไป
INSERT INTO Details
    (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
    (1, '8858757001948', 15.00, 0);



SELECT *FROM Details

--การลบข้อมูลทั้งตาราง
--truncate Table Products;
--การลบข้อมูลบางข้อมูลในตาราง
--DELETE FROM Products WHERE ProductID = '8858757009999';
