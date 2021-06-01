CREATE DATABASE QLBLK
GO
USE QLBLK
GO

CREATE TABLE LOAILK
(
	MALOAI VARCHAR(10) NOT NULL,
	TENLOAI NVARCHAR(50),
	CONSTRAINT PK_LOAILK PRIMARY KEY (MALOAI)
)
CREATE TABLE LINHKIEN
(
	MALK VARCHAR(10) NOT NULL,
	TENLK NVARCHAR(50),
	NGAYSX DATE,
	TGBH INT, -- thời gian bảo hành  >0 	tính bằng tháng
	MALOAI VARCHAR(10),
	NSX NVARCHAR(50), -- nhà sản xuất
	DVT NVARCHAR(30), -- đơn vị tính
	SOLUONGTONKHO INT, -- ck
	CONSTRAINT PK_LINHKIEN PRIMARY KEY (MALK),
	CONSTRAINT FK_LINHKIEN_LOAILK FOREIGN KEY (MALOAI)  REFERENCES LOAILK(MALOAI)
)
CREATE TABLE NHANVIEN
(
	MANV INT IDENTITY(1, 1) NOT NULL,
	TENNV NVARCHAR(50),
	NGAYSINH DATE,
	DOANHTHU MONEY,
	GIOITINH NVARCHAR(10),
	CONSTRAINT PK_NV PRIMARY KEY (MANV)
)
CREATE TABLE KHACHHANG
(
	MAKH INT IDENTITY(1, 1) NOT NULL,
	TENKH NVARCHAR(50) NOT NULL,
	DCHI NVARCHAR(MAX),
	DTHOAI VARCHAR(15),
	CONSTRAINT PK_KHACHHANG PRIMARY KEY (MAKH)
)
CREATE TABLE HOADON -- tổng kết hóa đơn xuất hàng
(
	MAHD VARCHAR(10) NOT NULL, -- default proc auto code
	NGAYHD DATE, -- default getdate()
	MAKH INT,
	MANV INT,
	TRIGIA MONEY, -- trigger (i, d, u)     df = 0
	CONSTRAINT PK_HOADON PRIMARY KEY (MAHD),
	CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
	CONSTRAINT FK_HOADON_NV FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
)
CREATE TABLE CHITIETHD  -- bill
(
	MAHD VARCHAR(10) NOT NULL,
	MALK VARCHAR(10) NOT NULL,
	SOLUONG INT, -- check > 0
	DONGIA MONEY, -- check > 0
	CONSTRAINT PK_CHITIETHD PRIMARY KEY (MAHD,MALK),
	CONSTRAINT FK_CHITIETHD_HOADON FOREIGN KEY (MAHD) REFERENCES HOADON(MAHD),
	CONSTRAINT FK_CHITIETHD_LINHKIEN FOREIGN KEY (MALK) REFERENCES LINHKIEN(MALK)
)
CREATE TABLE PHIEUNHAP -- nhập hàng
(
	MAPN VARCHAR(10) NOT NULL, -- default auto code
	NGAYNHAP DATE, -- default getdate()
	TRIGIA MONEY -- trigger (i, d, u)     df = 0
	CONSTRAINT PK_PN PRIMARY KEY (MAPN)
)
CREATE TABLE CHITIETPN
(
	MAPN VARCHAR(10) NOT NULL,
	MALK VARCHAR(10) NOT NULL,
	SOLUONG INT, -- check > 0
	DONGIA MONEY, -- check > 0
	CONSTRAINT PK_CTPN PRIMARY KEY (MAPN, MALK),
	CONSTRAINT FK_CTPN_LK FOREIGN KEY (MALK) REFERENCES LINHKIEN(MALK),
	CONSTRAINT FK_CTPN_PN FOREIGN KEY (MAPN) REFERENCES PHIEUNHAP(MAPN)
)

-- tạo ràng buộc

ALTER TABLE LINHKIEN
ADD CONSTRAINT CK_TGBH CHECK (TGBH > 0)

ALTER TABLE HOADON
ADD CONSTRAINT CK_HOADON_TRIGIA CHECK (TRIGIA >= 0),
		CONSTRAINT DF_HOADON_TRIGIA DEFAULT 0 FOR TRIGIA,
		CONSTRAINT DF_HOADON_NGAYHD DEFAULT GETDATE() FOR NGAYHD

ALTER TABLE CHITIETHD
ADD CONSTRAINT CK_CHITIETHD_SOLUONG CHECK (SOLUONG > 0),
		CONSTRAINT CK_CHITIETHD_DONGIA CHECK (DONGIA > 0)

ALTER TABLE PHIEUNHAP
ADD CONSTRAINT CK_PHIEUNHAP_TRIGIA CHECK (TRIGIA >= 0),
		CONSTRAINT DF_PHIEUNHAP_TRIGIA DEFAULT 0 FOR TRIGIA,
		CONSTRAINT DF_PHIEUNHAP_NGAYHD DEFAULT GETDATE() FOR NGAYNHAP

ALTER TABLE CHITIETPN
ADD CONSTRAINT CK_CHITIETPN_SOLUONG CHECK (SOLUONG > 0),
		CONSTRAINT CK_CHITIETPN_DONGIA CHECK (DONGIA > 0)

------------------------------------
--  _____    _        trigger     --
-- |_   _| _(_)__ _ __ _ ___ _ _  --
--   | || '_| / _` / _` / -_) '_| --
--   |_||_| |_\__, \__, \___|_|   --
--            |___/|___/          --
------------------------------------

-- xuất hàng
GO
CREATE TRIGGER DATHANG ON CHITIETHD
AFTER INSERT AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO - (
		SELECT SOLUONG
		FROM inserted
		WHERE MALK = LINHKIEN.MALK
	)
	FROM LINHKIEN JOIN inserted ON LINHKIEN.MALK = inserted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng hóa đơn
	UPDATE HOADON
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETHD
		WHERE MAHD = HOADON.MAHD
	)
	FROM HOADON JOIN inserted ON HOADON.MAHD = inserted.MAHD
-----------------------------------------------------------------------
END

GO
CREATE TRIGGER HUYDATHANG ON CHITIETHD
AFTER DELETE AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO + (
		SELECT SOLUONG
		FROM deleted
		WHERE MALK = LINHKIEN.MALK
	)
	FROM LINHKIEN JOIN deleted ON LINHKIEN.MALK = deleted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng hóa đơn
	UPDATE HOADON
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETHD
		WHERE MAHD = HOADON.MAHD
	)
	FROM HOADON JOIN deleted ON HOADON.MAHD = deleted.MAHD
-----------------------------------------------------------------------
END

GO
CREATE TRIGGER CAPNHAPDATHANG ON CHITIETHD
AFTER UPDATE AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO -
		(SELECT SOLUONG FROM inserted WHERE MALK = LINHKIEN.MALK) +
		(SELECT SOLUONG FROM deleted WHERE MALK = LINHKIEN.MALK)
	FROM LINHKIEN JOIN deleted ON LINHKIEN.MALK = deleted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng hóa đơn
	UPDATE HOADON
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETHD
		WHERE MAHD = HOADON.MAHD
	)
	FROM HOADON JOIN deleted ON HOADON.MAHD = deleted.MAHD
-----------------------------------------------------------------------
END

-- nhập hàng
GO
CREATE TRIGGER NHAPHANG ON CHITIETPN
AFTER INSERT AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO + (
		SELECT SOLUONG
		FROM inserted
		WHERE MALK = LINHKIEN.MALK
	)
	FROM LINHKIEN JOIN inserted ON LINHKIEN.MALK = inserted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng phiếu nhập
	UPDATE PHIEUNHAP
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETPN
		WHERE MAPN = PHIEUNHAP.MAPN
	)
	FROM PHIEUNHAP JOIN inserted ON PHIEUNHAP.MAPN = inserted.MAPN
-----------------------------------------------------------------------
END

GO
CREATE TRIGGER HUYNHAPHANG ON CHITIETPN
AFTER DELETE AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO - (
		SELECT SOLUONG
		FROM deleted
		WHERE MALK = LINHKIEN.MALK
	)
	FROM LINHKIEN JOIN deleted ON LINHKIEN.MALK = deleted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng phiếu nhập
	UPDATE PHIEUNHAP
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETPN
		WHERE MAPN = PHIEUNHAP.MAPN
	)
	FROM PHIEUNHAP JOIN deleted ON PHIEUNHAP.MAPN = deleted.MAPN
-----------------------------------------------------------------------
END

GO
CREATE TRIGGER CAPNHAPNHAPHANG ON CHITIETPN
AFTER UPDATE AS
BEGIN
	-- cập nhật số lượng tồn kho của linh kiện
	UPDATE LINHKIEN
	SET SOLUONGTONKHO = SOLUONGTONKHO +
		(SELECT SOLUONG FROM inserted WHERE MALK = LINHKIEN.MALK) -
		(SELECT SOLUONG FROM deleted WHERE MALK = LINHKIEN.MALK)
	FROM LINHKIEN JOIN deleted ON LINHKIEN.MALK = deleted.MALK
-----------------------------------------------------------------------
	-- cập nhật trị giá của bảng phiếu nhập
	UPDATE PHIEUNHAP
	SET TRIGIA = (
		SELECT SUM(SOLUONG*DONGIA)
		FROM CHITIETPN
		WHERE MAPN = PHIEUNHAP.MAPN
	)
	FROM PHIEUNHAP JOIN deleted ON PHIEUNHAP.MAPN = deleted.MAPN
-----------------------------------------------------------------------
END
GO

--------------------------------
--  ___           _   data    --
-- |   \   __ _  | |_   __ _  --
-- | |) | / _` | |  _| / _` | --
-- |___/  \__,_|  \__| \__,_| --
--------------------------------
INSERT LOAILK
VALUES
('MOU', N'Chuột'),
('LAP', N'Máy tính sách tay'),
('CPU', N'Bộ xử lí'),
('PCX', N'Máy tính để bàn'),
('MAI', N'Mainboard'),
('KEYB', N'Bàn phím'),
('HP', N'Tai nghe'),
('SCREEN', N'Màn hình'),
('PROJ', N'Máy chiếu')

SET DATEFORMAT DMY
INSERT LINHKIEN
VALUES
('SCREEN001', N'Màn hình máy tính ASUS', '20/10/2018', 12, 'SCREEN', 'ASUS', N'Cái', 20),
('SCREEN002', N'Màn hình máy tính DELL', '12/04/2018', 12, 'SCREEN', 'DELL', N'Cái', 15),
('MOU001', N'ChUột có dây LOGITECH', '19/06/2019', 6, 'MOU', 'LOGITECH', N'Cái', 34),
('MOU002', N'ChUột không dây LOGITECH', '19/06/2019', 6, 'MOU', 'LOGITECH', N'Cái', 10),
('MAI001', N'Mainboard ASUS', '17/5/2020', 12, 'MAI', 'ASUS', N'Cái', 27),
('MAI002', N'Mainboard ATXX', '16/6/2020', 12, 'MAI', 'ATXX', N'Cái', 12),
('CPU001', N'CPU Itel', '28/10/2018', 12, 'CPU', 'Itel', N'Cái', 10),
('KEYB001', N'Bàn phím LOGITECH', '20/10/2018', 6, 'KEYB', 'LOGITECH', N'Cái', 4),
('HP001', N'Tai nghe SONY', '4/6/2019', 12, 'HP', 'SONY', N'Cái', 20),
('PROJ001', N'Máy chiếu DELL', '20/10/2018', 12, 'PROJ', 'DELL', N'Cái', 10),
('PROJ002', N'Máy chiếu HP', '20/10/2018', 12, 'PROJ', 'HP', N'Cái', 10),
('PCX001', N'ASUS 20144', '20/10/2018', 12, 'PCX', 'ASUS', N'Cái', 5)

INSERT KHACHHANG (TENKH, DCHI, DTHOAI)
VALUES
(N'Nguyễn Thu Tâm', N'Tây Ninh', '0989751723'),
(N'Đinh Bảo Lộc', N'Lâm Đồng', '0918234654'),
(N'Trần Thanh Diệu', N'TP.HCM', '0978123765'),
(N'Hồ Trấn Thành', N'Hà Nội', '0909456768'),
(N'Huỳnh Kim Ánh', N'Khánh Hòa', '0932987567')

INSERT NHANVIEN (TENNV, NGAYSINH, GIOITINH)
VALUES
(N'Nguyễn Kim Ngọc', '4/11/1997', N'Nữ'),
(N'Trần Đinh Bảo', '11/12/2001', N'Nam'),
(N'Nguyễn Bảo Quyên', '5/1/1997', N'Nam'),
(N'Lê Hồng Hà', '12/2/2000', N'Nữ'),
(N'Trần Thành Công', '5/21/1998', N'Nam'),
(N'Huỳnh Thu Hà', '2/25/2000', N'Nữ'),
(N'Trương Thị My My', '4/24/1998', N'Nữ'),
(N'Trần Bảo Quân', '5/2/1999', N'Nam'),
(N'Võ Thị Thanh Hà', '1/1/2001', N'Nữ'),
(N'Lý Yến Nhi', '5/15/1998', N'Nữ'),

SET DATEFORMAT DMY
INSERT HOADON (MAHD, NGAYHD, MAKH, MANV)
VALUES
('HD001', '3/4/2020', 1, 1),
('HD002', '13/5/2020', 1, 2),
('HD003', '23/9/2020', 1, 3),
('HD004', '13/2/2020', 2, 4),
('HD005', '22/7/2020', 3, 5),
('HD006', '15/10/2020', 4, 6),
('HD007', '25/10/2020', 4, 7),
('HD008', '17/12/2020', 5, 1)

INSERT CHITIETHD
VALUES
('HD001', 'SCREEN001', 2, 12000000),
('HD002', 'MOU002', 3, 560000),
('HD003', 'MAI002', 5, 22000000),
('HD004', 'CPU001', 10, 27000000),
('HD005', 'KEYB001', 1, 5000000),
('HD006', 'HP001', 6, 7500000),
('HD007', 'PCX001', 12, 340000000),
('HD008', 'PROJ002', 9, 15000000)

SET DATEFORMAT DMY
INSERT PHIEUNHAP (MAPN, NGAYNHAP)
VALUES
('PN001', '16/12/2019'),
('PN002', '16/12/2019'),
('PN003', '24/12/2019'),
('PN004', '12/11/2019'),
('PN005', '13/12/2019'),
('PN006', '8/12/2019'),
('PN007', '22/12/2019'),
('PN008', '17/12/2019')

INSERT CHITIETPN
VALUES
('PN001', 'SCREEN001', 20, 120000000),
('PN002', 'MOU002', 30, 5600000),
('PN003', 'MAI002', 50, 220000000),
('PN004', 'CPU001', 26, 270000000),
('PN005', 'KEYB001', 10, 50000000),
('PN006', 'HP001', 60, 75000000),
('PN007', 'PCX001', 70, 3400000000),
('PN008', 'PROJ002', 20, 150000000)

----------------------------------------------------------
--  ___   Proc                     _   ___   Func       --
-- | _ \_ _ ___  __   __ _ _ _  __| | | __|  _ _ _  __  --
-- |  _/ '_/ _ \/ _| / _` | ' \/ _` | | _| || | ' \/ _| --
-- |_| |_| \___/\__| \__,_|_||_\__,_| |_| \_,_|_||_\__| --
----------------------------------------------------------
GO
CREATE PROC GetMaKH @TenKH NVARCHAR(50)
-- Nếu tìm thấy tên khách hàng thì trả về mã khách hàng tương ứng ngược lại trả về 0
AS
	DECLARE @MaKH INT
	IF EXISTS (SELECT MAKH FROM KHACHHANG WHERE TENKH=@TenKH)
		SELECT @MaKH=MAKH FROM KHACHHANG WHERE TENKH=@TenKH
	ELSE RETURN 0
	RETURN @MaKH
GO

CREATE PROC SLBanRa @MaLK VARCHAR(10), @NgayBan DATE
-- Cho biết số lượng được bán ra của linh kiện sản phẩm X trong ngày bán Y
AS
	DECLARE @SLBan INT

	IF NOT EXISTS(
		SELECT SUM(SOLUONG)
		FROM CHITIETHD CTHD JOIN HOADON HD
		ON CTHD.MAHD=HD.MAHD
		WHERE MALK=@MaLK AND NGAYHD=@NgayBan
	) RETURN 0

	SELECT @SLBan=SUM(SOLUONG)
	FROM CHITIETHD CTHD JOIN HOADON HD
		ON CTHD.MAHD=HD.MAHD
	WHERE MALK=@MaLK AND NGAYHD=@NgayBan


	RETURN @SLBan
GO

CREATE PROC SLTonKho @TenLK NVARCHAR(50)
-- GET số lượng linh kiện tồn kho
AS
	DECLARE @SL INT

	IF NOT EXISTS(
		SELECT SOLUONGTONKHO
		FROM LINHKIEN
		WHERE TENLK=@TenLK
	) RETURN -1

	SELECT @SL=SOLUONGTONKHO
	FROM LINHKIEN
	WHERE TENLK=@TenLK

	RETURN @SL
GO

CREATE PROC DoanhSoBanHang @MaKH INT
-- Lấy được doanh số bán hàng từ 1 khách hàng nào đó
AS
	DECLARE @TriGia MONEY
	SELECT @TriGia=SUM(TRIGIA)
	FROM HOADON
	WHERE MAKH=@MaKH
	IF @TriGia IS NULL
		SELECT 0 doanhSo
	ELSE SELECT @TriGia doanhSo
GO

CREATE PROC ThongTinLK @tenLK NVARCHAR(50)
-- show thông tin linh kiện dựa trên tên linh kiện
AS
	SELECT TENLK, NGAYSX, TGBH, NSX
	FROM LINHKIEN
	WHERE TENLK=@tenLK
GO

CREATE UD_DoanhThu @maNV INT, @thang INT
-- cập nhật doanh thu của nhân viên đó trong tháng x
AS

GO
