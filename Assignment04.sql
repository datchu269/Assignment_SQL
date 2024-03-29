﻿use Assignment
go

-- Tạo bảng loại SP
create table LoaiSP(
    MaLoaiSp char(20)primary key not null,
	TenloaiSp nvarchar(200)
)
go

-- Tạo bảng Người Chịu Trách Nhiệm
create table NCTN(
    MaNCTN int primary key not null,
	TenNCTN nvarchar(200)
)
go

-- Tạo bảng loại SP
create table SanPham(
    MaSP char(20) primary key not null,
	NgaySX datetime,
	TenSP nvarchar(200),
	MaLoaiSp char(20) foreign key references LoaiSP(MaLoaiSp),
	MaNCTN int foreign key references NCTN(MaNCTN)
)
go

-- Tạo bảng mối liên hệ nhiều nhiều
create table NCTNLoaiSP(
	MaNCTN int foreign key references NCTN(MaNCTN),
	MaLoaiSp char(20) foreign key references LoaiSP(MaLoaiSp)   
)
go

--3
insert into LoaiSP values ('Z37E', N'Máy tính sách tay Z37'),
                          ('IP22', N'Điện thoại IPhone'),
						  ('AS21', N'Máy In Asus')

insert into NCTN values (987688, N'Nguyễn Văn An'),
                        (187688, N'Nguyễn Văn Tùng'),
						(587688, N'Nguyễn Bách Khoa')

insert into SanPham values ('Z37 111111', '2012-12-09', N'Máy tính Dell Vostro 15 3000', 'Z37E', 987688),
                           ('Z37 111122', '2012-12-09', N'Máy tính Dell Vostro 3888', 'Z37E', 587688),
						   ('IP22 232323', '2012-12-09', N'IPhone 13 512GB', 'IP22', 187688),
						   ('IP22 155551', '2012-12-09', N'IPhone 13 Promax 512GB', 'IP22', 187688),
						   ('AS21 999111', '2012-12-09', N'Máy in đa chức năng HP LaserJet Pro MFP M135w ', 'AS21', 587688),
						   ('AS21 111661', '2012-12-09', N'Máy in HP LaserJet Pro M107w', 'AS21', 987688),
						   ('AS21 255811', '2012-12-09', N'Máy in HP Neverstop Laser 1000w', 'AS21', 587688)

insert into NCTNLoaiSP values (987688, 'Z37E'),
                              (987688, 'AS21'),
							  (587688, 'Z37E'),
							  (587688, 'AS21'),
							  (187688, 'IP22')

--4
select * from LoaiSP
select * from NCTN
select * from SanPham
select * from NCTNLoaiSP

--5
select * from LoaiSP
order by TenloaiSp 

select * from NCTN
order by TenNCTN

select * from SanPham
where MaLoaiSp = 'Z37E'

select * from SanPham
where MaNCTN in
(select MaNCTN from NCTN
where TenNCTN = N'Nguyễn Văn An')
order by MaSP desc

--6
select MaloaiSp, COUNT(MaSP) as SoSP from SanPham
group by MaloaiSp

select MaSP, NgaySX, TenSP, MaNCTN, TenloaiSp
from SanPham inner join LoaiSP on LoaiSP.MaLoaiSp = SanPham.MaLoaiSp

select MaSP, NgaySX, TenSP, TenNCTN, TenloaiSp
from SanPham inner join LoaiSP on LoaiSP.MaLoaiSp = SanPham.MaLoaiSp 
inner join NCTN on NCTN.MaNCTN = SanPham.MaNCTN

--7
alter table SanPham
    add constraint ck_Ngay04 check(NgaySX <= getdate())

alter table SanPham
    add PhienBan nvarchar(100)

--8
--a 
CREATE INDEX IX_NCTN ON dbo.NCTN(TenNCTN)

--b
CREATE VIEW View_SanPham AS
SELECT s.MaSP, s.NgaySX, l.TenloaiSp
FROM dbo.SanPham AS s
JOIN dbo.LoaiSP AS l  ON l.MaLoaiSp = s.MaLoaiSp

CREATE VIEW View_SanPham_NCTN AS
SELECT s.MaSP, s.NgaySX, n.TenNCTN 
FROM dbo.SanPham AS s
JOIN dbo.NCTN AS n ON n.MaNCTN = s.MaNCTN

CREATE VIEW View_Top_SanPham AS 
SELECT TOP 5 s.MaSP, s.NgaySX, l.TenloaiSp 
FROM dbo.SanPham AS s
JOIN dbo.LoaiSP AS l ON l.MaLoaiSp = s.MaLoaiSp
ORDER BY NgaySX

--c
CREATE PROCEDURE SP_Them_LoaiSP
    @Maloai CHAR(20),
	@Tenloai NVARCHAR(200)
AS BEGIN
    INSERT INTO LoaiSP(MaLoaiSp, TenloaiSp)
           VALUES(@Maloai, @Tenloai)
END

EXECUTE SP_Them_LoaiSP 
        P23A, N'Máy Giặt Panasonic'

CREATE PROCEDURE SP_Them_LoaiSP
    @MaNCTN int,
	@TenNCTN NVARCHAR(200)
AS BEGIN
    INSERT INTO NCTN(MaNCTN, TenNCTN)
           VALUES(@MaNCTN, @TenNCTN)
END


CREATE PROCEDURE SP_Them_SanPham
    @MaSP int,
	@NgaySX datetime,
	@TenSP nvarchar(200),
	@Maloai CHAR(50),
	@MaNCTN int,
	@Phienban nvarchar(50)
AS BEGIN
    IF(@NgaySX IS NULL)
	    SET @NgaySX = GETDATE()
    INSERT INTO SanPham( MaSP, NgaySX, TenSP, MaLoaiSp, MaNCTN, PhienBan)
           VALUES(@MaSP, @NgaySX, @TenSP, @Maloai, @MaNCTN, @Phienban)
END

select * from LoaiSP
select * from NCTN
select * from SanPham
select * from NCTNLoaiSP

CREATE PROCEDURE SP_Xoa_SanPham 
    @MaSP CHAR(20)
AS BEGIN 
   DELETE FROM SanPham
   WHERE MaSP = @MaSP
END 

CREATE PROCEDURE SP_Xoa_SanPham_TheoLoai 
    @MaSP CHAR(20),
	@MaLoai CHAR(50)
AS BEGIN 
   DELETE FROM SanPham
   WHERE MaSP = @MaSP AND  MaLoaiSp = @MaLoai
END 


