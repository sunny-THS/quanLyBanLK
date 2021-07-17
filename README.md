# quanLyBanLK
## Task
- [x] pojo
  - [x] pojoLinhKien
  - [x] pojoNhanVien
  - [x] pojoKhachHang
  - [x] pojoHoaDon
  - [x] pojoPhieuNhap
- [x] mô hình 2 lớp
- [x] Hoàn thành câu 1
  - [x] tạo table show thông tin LK
  - [x] thêm linh kiện
  - [x] xóa linh kiện
  - [x] chỉnh sửa thông tin linh kiện
- [ ] Hoàn thành câu 2
- [ ] Hoàn thành câu 3
  - [x] tạo 2 dialog tìm kiếm
  - [ ] tìm kiếm thông tin nhân viên
    - [ ] họ tên
    - [ ] gender (giới tính)
  - [ ] tìm kiếm thông tin các linh kiện
    - [ ] tên linh kiện
    - [ ] theo nhà sãn xuất
    - [ ] theo loại linh kiện
## error
- [x] trigger xuất hàng
  - [x] check xem đủ hàng xuất hay k
  - [x] xuất lỗi
## Procedure & Function
### Procedure
- [x] addLK(tenLK, tenLoai, ngSX, tgbh, nsx, dvt, sl)
- [x] updateTT(maLK, tenLK, baoHanh, NSX, soLuong)
- [ ] GetMaKH(tenKH)
- [ ] GetMaNV(tenNV)
- [ ] SLBanRa(maLK, ngayBan)
- [ ] SLTonKho(tenLK)
- [ ] DoanhSoBanHang(maKH)
### Function
- [x] ShowTTLK()
- [x] find Information
  - [x] TimTTNhanVien(tenNV)
  - [x] TimTTNhanVien_gender(gender)
  - [x] TimTTLK_Ten(tenLK)
  - [x] TimTTLK_NSX(tenNSX)
  - [x] TimTTLK_LOAI(tenLoaiLK)
- [ ] thông kê doanh thu
  - [ ] DOANHTHU_YEAR(year)
  - [ ] GetDoanhThu_NV()
  - [ ] GetDoanhThu_NV_YEAR()
    - [ ] DoanhThu_NV_YEAR(year)
  - [ ] GetDoanhThu_EACH_MIY(year)
