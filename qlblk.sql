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
	SOLUONGTONKHO INT, -- ck bằng proc
	CONSTRAINT PK_LINHKIEN PRIMARY KEY (MALK),
	CONSTRAINT FK_LINHKIEN_LOAILK FOREIGN KEY (MALOAI)  REFERENCES LOAILK(MALOAI)
)
CREATE TABLE KHACHHANG
(
	MAKH VARCHAR(10) NOT NULL,
	TENKH NVARCHAR(50),
	DCHI NVARCHAR(MAX),
	DTHOAI VARCHAR(15),
	CONSTRAINT PK_KHACHHANG PRIMARY KEY (MAKH)
)
CREATE TABLE HOADON -- tổng kết hóa đơn xuất hàng
(
	MAHD VARCHAR(10) NOT NULL,
	NGAYHD DATE, -- default getdate()
	MAKH VARCHAR(10),
	TRIGIA MONEY, -- trigger (i, d, u)     df = 0
	CONSTRAINT PK_HOADON PRIMARY KEY (MAHD),
	CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
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
  MAPN VARCHAR(10) NOT NULL,
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
		CONSTRAINT DF_PHIEUNHAP_NGAYHD DEFAULT GETDATE() FOR NGAYHD

ALTER TABLE CHITIETPN
ADD CONSTRAINT CK_CHITIETPN_SOLUONG CHECK (SOLUONG > 0),
		CONSTRAINT CK_CHITIETPN_DONGIA CHECK (DONGIA > 0)

------------------------------------
--  _____    _                    --
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

-- đặt hàng
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
		WHERE MAPN = HOADON.MAPN
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
		WHERE MAPN = HOADON.MAPN
	)
	FROM PHIEUNHAP JOIN deleted ON PHIEUNHAP.MAPN = deleted.MAPN
-----------------------------------------------------------------------
END

GO
CREATE TRIGGER CAPNHAPDATHANG ON CHITIETPN
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
		WHERE MAPN = HOADON.MAHD
	)
	FROM PHIEUNHAP JOIN deleted ON PHIEUNHAP.MAPN = deleted.MAPN
-----------------------------------------------------------------------
END
----------------------------------------------------------
--  ___                            _   ___              --
-- | _ \_ _ ___  __   __ _ _ _  __| | | __|  _ _ _  __  --
-- |  _/ '_/ _ \/ _| / _` | ' \/ _` | | _| || | ' \/ _| --
-- |_| |_| \___/\__| \__,_|_||_\__,_| |_| \_,_|_||_\__| --
----------------------------------------------------------
