SET SERVEROUTPUT ON;
SET ECHO ON;

-- MỞ KẾT NỐI VÀO SCHEMA DỮ LIỆU
CONN SPORTS_OWNER/CNTT2026!;

-- Xóa dữ liệu an toàn để tránh lỗi khóa ngoại (Foreign Key)
DELETE FROM AUDIT_LOG;
DELETE FROM PHAN_CONG_TRAN_DAU;
DELETE FROM TRAN_DAU;
DELETE FROM THANH_VIEN_DOI;
UPDATE USER_INFO SET MaDoi = NULL;
DELETE FROM DOI_THI_DAU;
DELETE FROM SAN_THI_DAU;
DELETE FROM GIAI_DAU;
DELETE FROM USER_INFO;

-- ====================================================================
-- 1. INSERT DATA: USER_INFO 
-- ====================================================================

-- ====================================================================
-- 1. INSERT DATA: USER_INFO 
-- Cấu hình tài khoản: 1 BTC + 10 Trưởng đoàn (TD) + 10 Trọng tài (TT) + 10 Giám sát (GS) = 31 dòng
-- Mật khẩu được mã hóa trực tiếp qua gói SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD
-- ====================================================================

-- 1 Ban tổ chức hệ thống
INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('btc_admin', N'Nguyễn Văn Trưởng', 'btc@sport.vn', '0901000000', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd_123'), 'ROLE_BTC');

-- 10 Trưởng đoàn (Quản lý các đội bóng)
INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_hanoi', N'Đỗ Quang Vinh', 'vinh.dq@hanoifc.vn', '0912000001', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_hcm', N'Nguyễn Hữu Thắng', 'thang.nh@hcmcfc.vn', '0912000002', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_danang', N'Lê Minh', 'minh.l@shbdanang.vn', '0912000003', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_haiphong', N'Văn Trần Hoàn', 'hoan.vt@haiphongfc.vn', '0912000004', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_namdinh', N'Nguyễn Văn Hiển', 'hien.nv@namdinhfc.vn', '0912000005', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_thanhhoa', N'Cao Tiến Đoan', 'doan.ct@thanhhoafc.vn', '0912000006', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_binhduong', N'Hồ Hồng Thạch', 'thach.hh@bdfc.vn', '0912000007', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_thecong', N'Đỗ Mạnh Dũng', 'dung.dm@thecong.vn', '0912000008', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_duphong1', N'Trưởng Đoàn Dự Phòng 1', 'td.dp1@sport.vn', '0912000009', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_duphong2', N'Trưởng Đoàn Dự Phòng 2', 'td.dp2@sport.vn', '0912000010', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TD');

-- 10 Trọng tài
INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_lan', N'Ngô Duy Lân', 'lan.nd@referee.vn', '0988000001', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_vu', N'Nguyễn Ngọc Vũ', 'vu.nn@referee.vn', '0988000002', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_hien', N'Nguyễn Trung Hiền', 'hien.nt@referee.vn', '0988000003', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_chuan', N'Hoàng Ngọc Chuẩn', 'chuan.hn@referee.vn', '0988000004', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_tuan', N'Trần Đình Tuấn', 'tuan.td@referee.vn', '0988000005', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_nghi', N'Lê Vũ Nghi', 'nghi.lv@referee.vn', '0988000006', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_thanh', N'Nguyễn Văn Thành', 'thanh.nv@referee.vn', '0988000007', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_duc', N'Vũ Hải Đức', 'duc.vh@referee.vn', '0988000008', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_tam', N'Phan Đức Tâm', 'tam.pd@referee.vn', '0988000009', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_khang', N'Bùi Minh Khang', 'khang.bm@referee.vn', '0988000010', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_TT');

-- 10 Giám sát
INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_anh', N'Lê Hoài Anh', 'anh.lh@supervisor.vn', '0977000001', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_dung', N'Nguyễn Trọng Dũng', 'dung.nt@supervisor.vn', '0977000002', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_hien', N'Trần Huy Hiền', 'hien.th@supervisor.vn', '0977000003', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_quang', N'Đặng Thanh Quang', 'quang.dt@supervisor.vn', '0977000004', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_tuan', N'Phạm Anh Tuấn', 'tuan.pa@supervisor.vn', '0977000005', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_long', N'Bùi Tiến Long', 'long.bt@supervisor.vn', '0977000006', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_son', N'Nguyễn Hồng Sơn', 'son.nh@supervisor.vn', '0977000007', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_phong', N'Vũ Việt Phong', 'phong.vv@supervisor.vn', '0977000008', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_thinh', N'Mai Đức Thịnh', 'thinh.md@supervisor.vn', '0977000009', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_minh', N'Hoàng Gia Minh', 'minh.hg@supervisor.vn', '0977000010', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('pwd'), 'ROLE_GS');

-- 2. INSERT DATA: GIAI_DAU (Giải đấu chính quy quy tụ 8 đội)
INSERT INTO GIAI_DAU (MaGiai, TenGiai, NamToChuc, NgayBatDau, NgayKetThuc, TrangThai) VALUES ('V_LEAGUE_2026', N'Giải bóng đá Vô Địch Quốc Gia 2026', 2026, TO_DATE('2026-02-01','YYYY-MM-DD'), TO_DATE('2026-11-01','YYYY-MM-DD'), 'PLAYING');

-- 3. INSERT DATA: SAN_THI_DAU (10 sân thi đấu cho đa dạng địa điểm)
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_HANGDAY', N'Sân Hàng Đẫy', N'Hà Nội', 22500);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_THONGNHAT', N'Sân Thống Nhất', N'TP. Hồ Chí Minh', 15000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_HOAXUAN', N'Sân Hòa Xuân', N'Đà Nẵng', 20000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_LACHTRAY', N'Sân Lạch Tray', N'Hải Phòng', 30000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_THIENTRUONG', N'Sân Thiên Trường', N'Nam Định', 30000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_THANHHOA', N'Sân Thanh Hóa', N'Thanh Hóa', 14000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_GODAU', N'Sân Gò Đậu', N'Bình Dương', 18000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_MYDINH', N'Sân Quốc Gia Mỹ Đình', N'Hà Nội', 40000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_CAMPHA', N'Sân Cẩm Phả', N'Quảng Ninh', 16000);
INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua) VALUES ('SAN_VINH', N'Sân vận động Vinh', N'Nghệ An', 18000);

-- 4. INSERT DATA: DOI_THI_DAU (8 đội quy tụ vào 1 giải duy nhất)
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D01', 'V_LEAGUE_2026', N'Hà Nội FC', 'td_hanoi', 'SAN_HANGDAY');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D02', 'V_LEAGUE_2026', N'Hồ Chí Minh City FC', 'td_hcm', 'SAN_THONGNHAT');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D03', 'V_LEAGUE_2026', N'SHB Đà Nẵng', 'td_danang', 'SAN_HOAXUAN');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D04', 'V_LEAGUE_2026', N'Hải Phòng FC', 'td_haiphong', 'SAN_LACHTRAY');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D05', 'V_LEAGUE_2026', N'Thép Xanh Nam Định', 'td_namdinh', 'SAN_THIENTRUONG');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D06', 'V_LEAGUE_2026', N'Đông Á Thanh Hóa', 'td_thanhhoa', 'SAN_THANHHOA');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D07', 'V_LEAGUE_2026', N'Becamex Bình Dương', 'td_binhduong', 'SAN_GODAU');
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha) VALUES ('D08', 'V_LEAGUE_2026', N'Thể Công Viettel', 'td_thecong', 'SAN_MYDINH');

-- Cập nhật ngược lại mã đội cho Trưởng đoàn phục vụ test Session Context/VPD
UPDATE USER_INFO SET MaDoi = 'D01' WHERE Username = 'td_hanoi';
UPDATE USER_INFO SET MaDoi = 'D02' WHERE Username = 'td_hcm';
UPDATE USER_INFO SET MaDoi = 'D03' WHERE Username = 'td_danang';
UPDATE USER_INFO SET MaDoi = 'D04' WHERE Username = 'td_haiphong';
UPDATE USER_INFO SET MaDoi = 'D05' WHERE Username = 'td_namdinh';
UPDATE USER_INFO SET MaDoi = 'D06' WHERE Username = 'td_thanhhoa';
UPDATE USER_INFO SET MaDoi = 'D07' WHERE Username = 'td_binhduong';
UPDATE USER_INFO SET MaDoi = 'D08' WHERE Username = 'td_thecong';

-- 5. INSERT DATA TƯỜNG MINH: THANH_VIEN_DOI (160 dòng - 8 đội x 20 thành viên)
-- Nhãn bảo mật OLS: 100 -> Cầu thủ, 200 -> Bác sĩ, 300 -> Ban huấn luyện

-- --- ĐỘI 1: HÀ NỘI FC (D01) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_01', 'D01', N'Daiki Iwamasa', 'HLV_TRUONG', TO_DATE('1982-01-30','YYYY-MM-DD'), N'Nam', 99, '001082000001', '0911000101', 'daiki@hanoifc.vn', N'Sức khỏe tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_02', 'D01', N'Lê Đức Tuấn', 'HLV_PHO', TO_DATE('1980-05-15','YYYY-MM-DD'), N'Nam', 98, '001080000002', '0911000102', 'tuan.ld@hanoifc.vn', N'Sức khỏe tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_03', 'D01', N'Kwon Hyuk-jun', 'BAC_SI', TO_DATE('1978-09-20','YYYY-MM-DD'), N'Nam', 97, '001078000003', '0911000103', 'kwon@hanoifc.vn', N'Khuỷu tay ổn định', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_04', 'D01', N'Nguyễn Tấn Trường', 'CAU_THU', TO_DATE('1986-02-19','YYYY-MM-DD'), N'Nam', 1, '001086000004', '0911000104', 'tantruong@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_05', 'D01', N'Đỗ Duy Mạnh', 'CAU_THU', TO_DATE('1996-09-29','YYYY-MM-DD'), N'Nam', 2, '001096000005', '0911000105', 'duymanh@hanoifc.vn', N'Hơi mỏi cơ đùi', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_06', 'D01', N'Phạm Xuân Mạnh', 'CAU_THU', TO_DATE('1996-02-09','YYYY-MM-DD'), N'Nam', 3, '001096000006', '0911000106', 'xuanmanh@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_07', 'D01', N'Nguyễn Thành Chung', 'CAU_THU', TO_DATE('1997-09-08','YYYY-MM-DD'), N'Nam', 4, '001097000007', '0911000107', 'thanhchung@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_08', 'D01', N'Đào Văn Nam', 'CAU_THU', TO_DATE('1996-10-20','YYYY-MM-DD'), N'Nam', 5, '001096000008', '0911000108', 'vannam@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_09', 'D01', N'Brandon Wilson', 'CAU_THU', TO_DATE('1997-09-22','YYYY-MM-DD'), N'Nam', 6, '001097000009', '0911000109', 'brandon@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_10', 'D01', N'Đỗ Hùng Dũng', 'CAU_THU', TO_DATE('1993-09-08','YYYY-MM-DD'), N'Nam', 7, '001093000010', '0911000110', 'hungdung@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_11', 'D01', N'Đậu Văn Toàn', 'CAU_THU', TO_DATE('1997-04-07','YYYY-MM-DD'), N'Nam', 8, '001097000011', '0911000111', 'vantoan.d@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_12', 'D01', N'Phạm Tuấn Hải', 'CAU_THU', TO_DATE('1998-05-19','YYYY-MM-DD'), N'Nam', 9, '001098000012', '0911000112', 'tuanhai@hanoifc.vn', N'Căng cơ nhẹ', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_13', 'D01', N'Nguyễn Văn Quyết', 'CAU_THU', TO_DATE('1991-07-01','YYYY-MM-DD'), N'Nam', 10, '001091000013', '0911000113', 'vanquyet@hanoifc.vn', N'Thể trạng xuất sắc', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_14', 'D01', N'Joel Tagueu', 'CAU_THU', TO_DATE('1993-11-06','YYYY-MM-DD'), N'Nam', 11, '001093000014', '0911000114', 'joel@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_15', 'D01', N'Hai Long', 'CAU_THU', TO_DATE('2000-08-27','YYYY-MM-DD'), N'Nam', 12, '001100000015', '0911000115', 'hailong@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_16', 'D01', N'Lê Văn Xuân', 'CAU_THU', TO_DATE('1999-02-27','YYYY-MM-DD'), N'Nam', 13, '001099000016', '0911000116', 'vanxuan@hanoifc.vn', N'Ổn định dây chằng', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_17', 'D01', N'Nguyễn Văn Tùng', 'CAU_THU', TO_DATE('2001-12-07','YYYY-MM-DD'), N'Nam', 14, '001101000017', '0911000117', 'vantung@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_18', 'D01', N'Vũ Đình Hai', 'CAU_THU', TO_DATE('2000-01-15','YYYY-MM-DD'), N'Nam', 15, '001100000018', '0911000118', 'dinhhai@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_19', 'D01', N'Mạch Ngọc Hà', 'CAU_THU', TO_DATE('2000-04-10','YYYY-MM-DD'), N'Nam', 16, '001100000019', '0911000119', 'ngocha@hanoifc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D01_20', 'D01', N'Quan Văn Chuẩn', 'CAU_THU', TO_DATE('2001-01-07','YYYY-MM-DD'), N'Nam', 17, '001101000020', '0911000120', 'vanchuan@hanoifc.vn', N'Thể trạng tốt', 100, 'N');

-- --- ĐỘI 2: HỒ CHÍ MINH CITY FC (D02) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_01', 'D02', N'Phùng Thanh Phương', 'HLV_TRUONG', TO_DATE('1978-03-30','YYYY-MM-DD'), N'Nam', 99, '002078000001', '0912000201', 'phuong.pt@hcmcfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_02', 'D02', N'Nguyễn Liêm Thanh', 'HLV_PHO', TO_DATE('1972-02-14','YYYY-MM-DD'), N'Nam', 98, '002072000002', '0912000202', 'thanh.nl@hcmcfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_03', 'D02', N'Đoàn Hoàng Sơn', 'BAC_SI', TO_DATE('1980-11-12','YYYY-MM-DD'), N'Nam', 97, '002080000003', '0912000203', 'son.dh@hcmcfc.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_04', 'D02', N'Patrik Lê Giang', 'CAU_THU', TO_DATE('1992-09-08','YYYY-MM-DD'), N'Nam', 1, '002092000004', '0912000204', 'patrik@hcmcfc.vn', N'Khớp vai ổn định', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_05', 'D02', N'Sầm Ngọc Đức', 'CAU_THU', TO_DATE('1992-05-18','YYYY-MM-DD'), N'Nam', 2, '002092000005', '0912000205', 'ngocduc@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_06', 'D02', N'Nguyễn Thanh Thảo', 'CAU_THU', TO_DATE('1995-10-02','YYYY-MM-DD'), N'Nam', 3, '002095000006', '0912000206', 'thanhthao@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_07', 'D02', N'Nguyễn Minh Tùng', 'CAU_THU', TO_DATE('1992-08-09','YYYY-MM-DD'), N'Nam', 4, '002092000007', '0912000207', 'minhtung@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_08', 'D02', N'Uông Ngọc Tiến', 'CAU_THU', TO_DATE('1998-06-15','YYYY-MM-DD'), N'Nam', 5, '002098000008', '0912000208', 'ngoctien@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_09', 'D02', N'Nguyễn Hạ Long', 'CAU_THU', TO_DATE('1994-03-09','YYYY-MM-DD'), N'Nam', 6, '002094000009', '0912000209', 'halong@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_10', 'D02', N'Võ Huy Toàn', 'CAU_THU', TO_DATE('1993-03-15','YYYY-MM-DD'), N'Nam', 7, '002093000010', '0912000210', 'huytoan@hcmcfc.vn', N'Ổn định cơ cổ chân', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_11', 'D02', N'Cheick Timité', 'CAU_THU', TO_DATE('1997-11-20','YYYY-MM-DD'), N'Nam', 8, '002097000011', '0912000211', 'timite@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_12', 'D02', N'Santiago Patino', 'CAU_THU', TO_DATE('1997-04-10','YYYY-MM-DD'), N'Nam', 9, '002097000012', '0912000212', 'patino@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_13', 'D02', N'Lâm Thuận', 'CAU_THU', TO_DATE('1998-11-20','YYYY-MM-DD'), N'Nam', 10, '002098000013', '0912000213', 'lamthuan@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_14', 'D02', N'Chu Văn Kiên', 'CAU_THU', TO_DATE('1998-02-18','YYYY-MM-DD'), N'Nam', 11, '002098000014', '0912000214', 'vankien@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_15', 'D02', N'Phạm Hữu Nghĩa', 'CAU_THU', TO_DATE('1999-05-12','YYYY-MM-DD'), N'Nam', 12, '002099000015', '0912000215', 'huunghia@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_16', 'D02', N'Phan Văn Thành', 'CAU_THU', TO_DATE('1998-01-20','YYYY-MM-DD'), N'Nam', 13, '002098000016', '0912000216', 'vanthanh@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_17', 'D02', N'Nguyễn Phong Hồng Duy', 'CAU_THU', TO_DATE('1996-06-13','YYYY-MM-DD'), N'Nam', 14, '002096000017', '0912000217', 'hongduy@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_18', 'D02', N'Hồ Tuấn Tài', 'CAU_THU', TO_DATE('1995-03-16','YYYY-MM-DD'), N'Nam', 15, '002095000018', '0912000218', 'tuantai@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_19', 'D02', N'Bùi Vĩnh Nguyên', 'CAU_THU', TO_DATE('2002-02-15','YYYY-MM-DD'), N'Nam', 16, '002102000019', '0912000219', 'vinhnguyen@hcmcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D02_20', 'D02', N'Trần Thanh Bình', 'CAU_THU', TO_DATE('1999-08-22','YYYY-MM-DD'), N'Nam', 17, '002099000020', '0912000220', 'thanhbinh@hcmcfc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 3: SHB ĐÀ NẴNG (D03) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_01', 'D03', N'Trương Việt Hoàng', 'HLV_TRUONG', TO_DATE('1975-12-09','YYYY-MM-DD'), N'Nam', 99, '003075000001', '0913000301', 'hoang.tv@danangfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_02', 'D03', N'Nguyễn Vũ Phong', 'HLV_PHO', TO_DATE('1985-02-06','YYYY-MM-DD'), N'Nam', 98, '003085000002', '0913000302', 'phong.nv@danangfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_03', 'D03', N'Phạm Quốc Thắng', 'BAC_SI', TO_DATE('1983-04-18','YYYY-MM-DD'), N'Nam', 97, '003083000003', '0913000303', 'thang.pq@danangfc.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_04', 'D03', N'Phan Văn Biểu', 'CAU_THU', TO_DATE('1998-03-12','YYYY-MM-DD'), N'Nam', 1, '003098000004', '0913000304', 'vanbieu@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_05', 'D03', N'Lương Duy Cương', 'CAU_THU', TO_DATE('2001-11-07','YYYY-MM-DD'), N'Nam', 2, '003101000005', '0913000305', 'duycuong@danangfc.vn', N'Thể lực sung mãn', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_06', 'D03', N'Nguyễn Công Nhật', 'CAU_THU', TO_DATE('1993-02-16','YYYY-MM-DD'), N'Nam', 3, '003093000006', '0913000306', 'congnhat@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_07', 'D03', N'Trần Đình Duy', 'CAU_THU', TO_DATE('2002-05-14','YYYY-MM-DD'), N'Nam', 4, '003102000007', '0913000307', 'dinhduy@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_08', 'D03', N'Đặng Anh Tuấn', 'CAU_THU', TO_DATE('1994-08-01','YYYY-MM-DD'), N'Nam', 5, '003094000008', '0913000308', 'anhtuan@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_09', 'D03', N'Võ Ngọc Toàn', 'CAU_THU', TO_DATE('1994-05-20','YYYY-MM-DD'), N'Nam', 6, '003094000009', '0913000309', 'ngoctoan@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_10', 'D03', N'Phan Văn Long', 'CAU_THU', TO_DATE('1996-06-01','YYYY-MM-DD'), N'Nam', 7, '003096000010', '0913000310', 'vanlong@danangfc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_11', 'D03', N'Nguyễn Minh Quang', 'CAU_THU', TO_DATE('2001-06-18','YYYY-MM-DD'), N'Nam', 8, '003101000011', '0913000311', 'minhquang@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_12', 'D03', N'Phạm Đình Duy', 'CAU_THU', TO_DATE('2002-04-02','YYYY-MM-DD'), N'Nam', 9, '003102000012', '0913000312', 'phamduy@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_13', 'D03', N'Giáp Tuấn Dương', 'CAU_THU', TO_DATE('2002-09-07','YYYY-MM-DD'), N'Nam', 10, '003102000013', '0913000313', 'tuanduong@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_14', 'D03', N'Nguyễn Trọng Nam', 'CAU_THU', TO_DATE('1998-04-05','YYYY-MM-DD'), N'Nam', 11, '003098000014', '0913000314', 'trongnam@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_15', 'D03', N'Lê Văn Hưng', 'CAU_THU', TO_DATE('2000-03-12','YYYY-MM-DD'), N'Nam', 12, '003100000015', '0913000315', 'vanhung@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_16', 'D03', N'Mai Quốc Tú', 'CAU_THU', TO_DATE('2004-12-10','YYYY-MM-DD'), N'Nam', 13, '003104000016', '0913000316', 'quoctu@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_17', 'D03', N'Trần Vương', 'CAU_THU', TO_DATE('1999-01-20','YYYY-MM-DD'), N'Nam', 14, '003099000017', '0913000317', 'tranvuong@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_18', 'D03', N'Nguyễn Phi Hoàng', 'CAU_THU', TO_DATE('2003-03-27','YYYY-MM-DD'), N'Nam', 15, '003103000018', '0913000318', 'phihoang@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_19', 'D03', N'Phạm Văn Hữu', 'CAU_THU', TO_DATE('2001-06-03','YYYY-MM-DD'), N'Nam', 16, '003101000019', '0913000319', 'vanhuu@danangfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D03_20', 'D03', N'Lê Quang Hùng', 'CAU_THU', TO_DATE('1992-06-01','YYYY-MM-DD'), N'Nam', 17, '003092000020', '0913000320', 'quanghung@danangfc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 4: HẢI PHÒNG FC (D04) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_01', 'D04', N'Chu Đình Nghiêm', 'HLV_TRUONG', TO_DATE('1972-08-18','YYYY-MM-DD'), N'Nam', 99, '004072000001', '0914000401', 'nghiem.cd@haiphongfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_02', 'D04', N'Lê Quốc Vượng', 'HLV_PHO', TO_DATE('1983-02-20','YYYY-MM-DD'), N'Nam', 98, '004083000002', '0914000402', 'vuong.lq@haiphongfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_03', 'D04', N'Nguyễn Văn Tuấn', 'BAC_SI', TO_DATE('1976-12-15','YYYY-MM-DD'), N'Nam', 97, '004076000003', '0914000403', 'tuan.nv@haiphongfc.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_04', 'D04', N'Nguyễn Đình Triệu', 'CAU_THU', TO_DATE('1991-11-04','YYYY-MM-DD'), N'Nam', 1, '004091000004', '0914000404', 'dinhtrieu@haiphongfc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_05', 'D04', N'Đặng Văn Tới', 'CAU_THU', TO_DATE('1999-01-12','YYYY-MM-DD'), N'Nam', 2, '004099000005', '0914000405', 'vantoi@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_06', 'D04', N'Bùi Tiến Dụng', 'CAU_THU', TO_DATE('1998-11-23','YYYY-MM-DD'), N'Nam', 3, '004098000006', '0914000406', 'tiendung@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_07', 'D04', N'Phạm Hoài Dương', 'CAU_THU', TO_DATE('1993-10-14','YYYY-MM-DD'), N'Nam', 4, '004093000007', '0914000407', 'hoaiduong@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_08', 'D04', N'A Sân', 'CAU_THU', TO_DATE('1995-12-09','YYYY-MM-DD'), N'Nam', 5, '004095000008', '0914000408', 'asan@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_09', 'D04', N'Lương Hoàng Nam', 'CAU_THU', TO_DATE('1997-03-02','YYYY-MM-DD'), N'Nam', 6, '004097000009', '0914000409', 'hoangnam@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_10', 'D04', N'Triệu Việt Hưng', 'CAU_THU', TO_DATE('1997-01-19','YYYY-MM-DD'), N'Nam', 7, '004097000010', '0914000410', 'viethung@haiphongfc.vn', N'Thể lực ổn định', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_11', 'D04', N'Nguyễn Hữu Sơn', 'CAU_THU', TO_DATE('1996-09-27','YYYY-MM-DD'), N'Nam', 8, '004096000011', '0914000411', 'huuson@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_12', 'D04', N'Lucão do Break', 'CAU_THU', TO_DATE('1991-09-14','YYYY-MM-DD'), N'Nam', 9, '004091000012', '0914000412', 'lucao@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_13', 'D04', N'Mpande Joseph', 'CAU_THU', TO_DATE('1994-03-24','YYYY-MM-DD'), N'Nam', 10, '004094000013', '0914000413', 'mpande@haiphongfc.vn', N'Rất khỏe', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_14', 'D04', N'Lê Tiến Anh', 'CAU_THU', TO_DATE('1998-08-16','YYYY-MM-DD'), N'Nam', 11, '004098000014', '0914000414', 'tienanh@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_15', 'D04', N'Nguyễn Tuấn Anh', 'CAU_THU', TO_DATE('1995-05-16','YYYY-MM-DD'), N'Nam', 12, '004095000015', '0914000415', 'tuananh@haiphongfc.vn', N'Cổ chân ổn định', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_16', 'D04', N'Nguyễn Văn Minh', 'CAU_THU', TO_DATE('1999-02-08','YYYY-MM-DD'), N'Nam', 13, '004099000016', '0914000416', 'vanminh@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_17', 'D04', N'Dương Văn Khoa', 'CAU_THU', TO_DATE('1994-05-06','YYYY-MM-DD'), N'Nam', 14, '004094000017', '0914000417', 'vankhoa@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_18', 'D04', N'Lê Minh Bình', 'CAU_THU', TO_DATE('1999-12-25','YYYY-MM-DD'), N'Nam', 15, '004099000018', '0914000418', 'minhbinh@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_19', 'D04', N'Phạm Văn Luân', 'CAU_THU', TO_DATE('1999-05-26','YYYY-MM-DD'), N'Nam', 16, '004099000019', '0914000419', 'vanluan@haiphongfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D04_20', 'D04', N'Nguyễn Trọng Đại', 'CAU_THU', TO_DATE('1997-04-07','YYYY-MM-DD'), N'Nam', 17, '004097000020', '0914000420', 'trongdai@haiphongfc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 5: THÉP XANH NAM ĐỊNH (D05) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_01', 'D05', N'Vũ Hồng Việt', 'HLV_TRUONG', TO_DATE('1979-03-16','YYYY-MM-DD'), N'Nam', 99, '005079000001', '0915000501', 'viet.vh@namdinhfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_02', 'D05', N'Nguyễn Trung Kiên', 'HLV_PHO', TO_DATE('1979-08-11','YYYY-MM-DD'), N'Nam', 98, '005079000002', '0915000502', 'kien.nt@namdinhfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_03', 'D05', N'Lê Văn Sỹ', 'BAC_SI', TO_DATE('1975-10-10','YYYY-MM-DD'), N'Nam', 97, '005075000003', '0915000503', 'doctor.sy@namdinhfc.vn', N'Ổn định', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_04', 'D05', N'Trần Nguyên Mạnh', 'CAU_THU', TO_DATE('1991-12-20','YYYY-MM-DD'), N'Nam', 1, '005091000004', '0915000504', 'nguyenmanh@namdinhfc.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_05', 'D05', N'Lucas Alves', 'CAU_THU', TO_DATE('1992-06-03','YYYY-MM-DD'), N'Nam', 2, '005092000005', '0915000505', 'lucas@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_06', 'D05', N'Dương Thanh Hào', 'CAU_THU', TO_DATE('1991-02-15','YYYY-MM-DD'), N'Nam', 3, '005091000006', '0915000506', 'thanhhao@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_07', 'D05', N'Nguyễn Phong Hồng Duy', 'CAU_THU', TO_DATE('1996-06-13','YYYY-MM-DD'), N'Nam', 4, '005096000007', '0915000507', 'hongduy.n@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_08', 'D05', N'Trần Văn Kiên', 'CAU_THU', TO_DATE('1996-05-13','YYYY-MM-DD'), N'Nam', 5, '005096000008', '0915000508', 'vankien.t@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_09', 'D05', N'Phạm Đức Huy', 'CAU_THU', TO_DATE('1995-01-20','YYYY-MM-DD'), N'Nam', 6, '005095000009', '0915000509', 'duchuy@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_10', 'D05', N'Nguyễn Tuấn Anh', 'CAU_THU', TO_DATE('1995-05-16','YYYY-MM-DD'), N'Nam', 7, '005095000010', '0915000510', 'tuananh.n@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_11', 'D05', N'Hendrio Araujo', 'CAU_THU', TO_DATE('1994-05-16','YYYY-MM-DD'), N'Nam', 8, '005094000011', '0915000511', 'hendrio@namdinhfc.vn', N'Xuất sắc', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_12', 'D05', N'Rafaelson Bezerra', 'CAU_THU', TO_DATE('1997-03-30','YYYY-MM-DD'), N'Nam', 9, '005097000012', '0915000512', 'rafaelson@namdinhfc.vn', N'Thể trạng đỉnh cao', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_13', 'D05', N'Nguyễn Văn Toàn', 'CAU_THU', TO_DATE('1996-04-12','YYYY-MM-DD'), N'Nam', 10, '005096000013', '0915000513', 'vantoan@namdinhfc.vn', N'Tốc độ cơ đùi tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_14', 'D05', N'Trần Văn Đạt', 'CAU_THU', TO_DATE('2000-12-26','YYYY-MM-DD'), N'Nam', 11, '005100000014', '0915000514', 'vandat@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_15', 'D05', N'Nguyễn Văn Vĩ', 'CAU_THU', TO_DATE('1998-02-12','YYYY-MM-DD'), N'Nam', 12, '005098000015', '0915000515', 'vanvi@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_16', 'D05', N'Trần Văn Công', 'CAU_THU', TO_DATE('1999-02-15','YYYY-MM-DD'), N'Nam', 13, '005099000016', '0915000516', 'vancong@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_17', 'D05', N'Lý Công Hoàng Anh', 'CAU_THU', TO_DATE('1999-12-01','YYYY-MM-DD'), N'Nam', 14, '005099000017', '0915000517', 'hoanganh@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_18', 'D05', N'Tô Văn Vũ', 'CAU_THU', TO_DATE('1993-10-20','YYYY-MM-DD'), N'Nam', 15, '005093000018', '0915000518', 'vanvu@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_19', 'D05', N'Nguyễn Đình Bắc', 'CAU_THU', TO_DATE('2004-08-19','YYYY-MM-DD'), N'Nam', 16, '005104000019', '0915000519', 'dinhbac@namdinhfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D05_20', 'D05', N'Hồ Khắc Ngọc', 'CAU_THU', TO_DATE('1992-08-02','YYYY-MM-DD'), N'Nam', 17, '005092000020', '0915000520', 'khacngoc@namdinhfc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 6: ĐÔNG Á THANH HÓA (D06) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_01', 'D06', N'Velizar Popov', 'HLV_TRUONG', TO_DATE('1976-03-04','YYYY-MM-DD'), N'Nam', 99, '006076000001', '0916000601', 'popov@thanhhoafc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_02', 'D06', N'Nguyễn Chí Công', 'HLV_PHO', TO_DATE('1975-06-15','YYYY-MM-DD'), N'Nam', 98, '006075000002', '0916000602', 'chicong@thanhhoafc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_03', 'D06', N'Dương Tiến Đồng', 'BAC_SI', TO_DATE('1982-10-22','YYYY-MM-DD'), N'Nam', 97, '006082000003', '0916000603', 'tiendong@thanhhoafc.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_04', 'D06', N'Trịnh Xuân Hoàng', 'CAU_THU', TO_DATE('2000-11-06','YYYY-MM-DD'), N'Nam', 1, '006100000004', '0916000604', 'xuanhoang@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_05', 'D06', N'Đinh Tiến Thành', 'CAU_THU', TO_DATE('1991-01-24','YYYY-MM-DD'), N'Nam', 2, '006091000005', '0916000605', 'tienthanh@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_06', 'D06', N'Trịnh Văn Lợi', 'CAU_THU', TO_DATE('1995-05-28','YYYY-MM-DD'), N'Nam', 3, '006095000006', '0916000606', 'vanloi@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_07', 'D06', N'Nguyễn Thanh Long', 'CAU_THU', TO_DATE('1993-01-10','YYYY-MM-DD'), N'Nam', 4, '006093000007', '0916000607', 'thanhlong@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_08', 'D06', N'Lục Xuân Hưng', 'CAU_THU', TO_DATE('1995-04-15','YYYY-MM-DD'), N'Nam', 5, '006095000008', '0916000608', 'xuanhung@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_09', 'D06', N'Nguyễn Thái Sơn', 'CAU_THU', TO_DATE('2003-07-13','YYYY-MM-DD'), N'Nam', 6, '006003000009', '0916000609', 'thaison@thanhhoafc.vn', N'Thể lực sung mãn', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_10', 'D06', N'Lê Quốc Phương', 'CAU_THU', TO_DATE('1991-05-19','YYYY-MM-DD'), N'Nam', 7, '006091000010', '0916000610', 'quocphuong@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_11', 'D06', N'Lê Văn Thắng', 'CAU_THU', TO_DATE('1990-02-08','YYYY-MM-DD'), N'Nam', 8, '006090000011', '0916000611', 'vanthang@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_12', 'D06', N'Rimario Gordon', 'CAU_THU', TO_DATE('1994-07-06','YYYY-MM-DD'), N'Nam', 9, '006094000012', '0916000612', 'rimario@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_13', 'D06', N'Luiz Antonio', 'CAU_THU', TO_DATE('1991-03-11','YYYY-MM-DD'), N'Nam', 10, '006091000013', '0916000613', 'antonio@thanhhoafc.vn', N'Xuất sắc', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_14', 'D06', N'Lâm Ti Phông', 'CAU_THU', TO_DATE('1996-02-01','YYYY-MM-DD'), N'Nam', 11, '006096000014', '0916000614', 'tiphong@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_15', 'D06', N'Nguyễn Trọng Hùng', 'CAU_THU', TO_DATE('1997-10-03','YYYY-MM-DD'), N'Nam', 12, '006097000015', '0916000615', 'tronghung@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_16', 'D06', N'Võ Nguyên Hoàng', 'CAU_THU', TO_DATE('2002-02-07','YYYY-MM-DD'), N'Nam', 13, '006102000016', '0916000616', 'nguyenhoang@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_17', 'D06', N'Hoàng Thái Bình', 'CAU_THU', TO_DATE('1998-01-22','YYYY-MM-DD'), N'Nam', 14, '006098000017', '0916000617', 'thaibinh@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_18', 'D06', N'Đoàn Ngọc Hà', 'CAU_THU', TO_DATE('2004-03-15','YYYY-MM-DD'), N'Nam', 15, '006104000018', '0916000618', 'ngocha.d@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_19', 'D06', N'Nguyễn Sỹ Nam', 'CAU_THU', TO_DATE('1993-02-15','YYYY-MM-DD'), N'Nam', 16, '006093000019', '0916000619', 'synam@thanhhoafc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D06_20', 'D06', N'Nguyễn Minh Tùng', 'CAU_THU', TO_DATE('1992-08-09','YYYY-MM-DD'), N'Nam', 17, '006092000020', '0916000620', 'minhtung.n@thanhhoafc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 7: BECAMEX BÌNH DƯƠNG (D07) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_01', 'D07', N'Hoàng Anh Tuấn', 'HLV_TRUONG', TO_DATE('1968-02-20','YYYY-MM-DD'), N'Nam', 99, '007068000001', '0917000701', 'tuan.ha@bdcfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_02', 'D07', N'Nguyễn Thanh Sơn', 'HLV_PHO', TO_DATE('1973-04-10','YYYY-MM-DD'), N'Nam', 98, '007073000002', '0917000702', 'son.nt@bdcfc.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_03', 'D07', N'Phan Bá Thục', 'BAC_SI', TO_DATE('1981-08-14','YYYY-MM-DD'), N'Nam', 97, '007081000003', '0917000703', 'bathuc@bdcfc.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_04', 'D07', N'Trần Minh Toàn', 'CAU_THU', TO_DATE('1996-01-21','YYYY-MM-DD'), N'Nam', 1, '007096000004', '0917000704', 'minhtoan@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_05', 'D07', N'Quế Ngọc Hải', 'CAU_THU', TO_DATE('1993-05-15','YYYY-MM-DD'), N'Nam', 2, '007093000005', '0917000705', 'ngochai@bdcfc.vn', N'Tốt, ổn định gối', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_06', 'D07', N'Janclesio Almeida', 'CAU_THU', TO_DATE('1993-04-22','YYYY-MM-DD'), N'Nam', 3, '007093000006', '0917000706', 'janclesio@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_07', 'D07', N'Nguyễn Thành Lộc', 'CAU_THU', TO_DATE('1992-12-04','YYYY-MM-DD'), N'Nam', 4, '007092000007', '0917000707', 'thanhloc@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_08', 'D07', N'Lê Quang Hùng', 'CAU_THU', TO_DATE('1992-06-01','YYYY-MM-DD'), N'Nam', 5, '007092000008', '0917000708', 'quanghung.l@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_09', 'D07', N'Nguyễn Hải Huy', 'CAU_THU', TO_DATE('1991-06-18','YYYY-MM-DD'), N'Nam', 6, '007091000009', '0917000709', 'haihuy@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_10', 'D07', N'Nguyễn Tiến Linh', 'CAU_THU', TO_DATE('1997-10-20','YYYY-MM-DD'), N'Nam', 7, '007097000010', '0917000710', 'tienlinh@bdcfc.vn', N'Thể trạng rất tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_11', 'D07', N'Bùi Vĩ Hào', 'CAU_THU', TO_DATE('2003-02-24','YYYY-MM-DD'), N'Nam', 8, '007103000011', '0917000711', 'vihao@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_12', 'D07', N'Charles Atshimene', 'CAU_THU', TO_DATE('1998-03-05','YYYY-MM-DD'), N'Nam', 9, '007098000012', '0917000712', 'charles@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_13', 'D07', N'Võ Hoàng Minh Khoa', 'CAU_THU', TO_DATE('2001-03-12','YYYY-MM-DD'), N'Nam', 10, '007101000013', '0917000713', 'minhkhoa@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_14', 'D07', N'Trần Đình Khương', 'CAU_THU', TO_DATE('1996-01-10','YYYY-MM-DD'), N'Nam', 11, '007096000014', '0917000714', 'dinhkhuong@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_15', 'D07', N'Nguyễn Trần Việt Cường', 'CAU_THU', TO_DATE('2000-12-27','YYYY-MM-DD'), N'Nam', 12, '007100000015', '0917000715', 'vietcuong@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_16', 'D07', N'Đoàn Tuấn Cảnh', 'CAU_THU', TO_DATE('2000-05-18','YYYY-MM-DD'), N'Nam', 13, '007100000016', '0917000716', 'tuancanh@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_17', 'D07', N'Hồ Sỹ Giáp', 'CAU_THU', TO_DATE('1994-04-26','YYYY-MM-DD'), N'Nam', 14, '007094000017', '0917000717', 'sygiap@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_18', 'D07', N'Nguyễn Trung Hậu', 'CAU_THU', TO_DATE('2002-06-20','YYYY-MM-DD'), N'Nam', 15, '007102000018', '0917000718', 'trunghau@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_19', 'D07', N'Nguyễn Hoàng Bảo', 'CAU_THU', TO_DATE('2001-08-11','YYYY-MM-DD'), N'Nam', 16, '007101000019', '0917000719', 'hoangbao@bdcfc.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D07_20', 'D07', N'Trần Duy Khánh', 'CAU_THU', TO_DATE('1997-07-20','YYYY-MM-DD'), N'Nam', 17, '007097000020', '0917000720', 'duykhanh@bdcfc.vn', N'Tốt', 100, 'N');

-- --- ĐỘI 8: THỂ CÔNG VIETTEL (D08) ---
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_01', 'D08', N'Nguyễn Đức Thắng', 'HLV_TRUONG', TO_DATE('1976-05-28','YYYY-MM-DD'), N'Nam', 99, '008076000001', '0918000801', 'thang.nd@thecongviettel.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_02', 'D08', N'Nguyễn Huy Hoàng', 'HLV_PHO', TO_DATE('1981-01-04','YYYY-MM-DD'), N'Nam', 98, '008081000002', '0918000802', 'hoang.nh@thecongviettel.vn', N'Tốt', 300, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_03', 'D08', N'Kim Kwang-jae', 'BAC_SI', TO_DATE('1977-11-20','YYYY-MM-DD'), N'Nam', 97, '008077000003', '0918000803', 'kim@thecongviettel.vn', N'Tốt', 200, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_04', 'D08', N'Phan Văn Phong', 'CAU_THU', TO_DATE('1993-11-25','YYYY-MM-DD'), N'Nam', 1, '008093000004', '0918000804', 'vanphong@thecongviettel.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_05', 'D08', N'Thanh Bình', 'CAU_THU', TO_DATE('2000-11-02','YYYY-MM-DD'), N'Nam', 2, '008100000005', '0918000805', 'thanhbinh@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_06', 'D08', N'Bùi Tiến Dũng', 'CAU_THU', TO_DATE('1995-10-02','YYYY-MM-DD'), N'Nam', 3, '008095000006', '0918000806', 'tiendung@thecongviettel.vn', N'Ổn định cơ háng', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_07', 'D08', N'Phan Tuấn Tài', 'CAU_THU', TO_DATE('2001-01-07','YYYY-MM-DD'), N'Nam', 4, '008101000007', '0918000807', 'tuantai@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_08', 'D08', N'Nguyễn Thanh Bình', 'CAU_THU', TO_DATE('2000-11-02','YYYY-MM-DD'), N'Nam', 5, '008100000008', '0918000808', 'thanhbinh.n@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_09', 'D08', N'Đức Chiến', 'CAU_THU', TO_DATE('1998-04-16','YYYY-MM-DD'), N'Nam', 6, '008098000009', '0918000809', 'ducchien@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_10', 'D08', N'Jaha', 'CAU_THU', TO_DATE('1995-04-01','YYYY-MM-DD'), N'Nam', 7, '008095000010', '0918000810', 'jaha@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_11', 'D08', N'Khuất Văn Khang', 'CAU_THU', TO_DATE('2003-05-11','YYYY-MM-DD'), N'Nam', 8, '008103000011', '0918000811', 'vankhang@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_12', 'D08', N'Pedro Henrique', 'CAU_THU', TO_DATE('1997-01-15','YYYY-MM-DD'), N'Nam', 9, '008097000012', '0918000812', 'pedro@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_13', 'D08', N'Nguyễn Hoàng Đức', 'CAU_THU', TO_DATE('1998-01-11','YYYY-MM-DD'), N'Nam', 10, '008098000013', '0918000813', 'hoangduc@thecongviettel.vn', N'Thể trạng tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_14', 'D08', N'Trần Danh Trung', 'CAU_THU', TO_DATE('2000-10-03','YYYY-MM-DD'), N'Nam', 11, '008100000014', '0918000814', 'danhtrung@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_15', 'D08', N'Dương Văn Hào', 'CAU_THU', TO_DATE('1997-02-15','YYYY-MM-DD'), N'Nam', 12, '008097000015', '0918000815', 'vanhao@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_16', 'D08', N'Trần Mạnh Cường', 'CAU_THU', TO_DATE('1993-10-28','YYYY-MM-DD'), N'Nam', 13, '008093000016', '0918000816', 'manhcuong@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_17', 'D08', N'Trương Tiến Anh', 'CAU_THU', TO_DATE('1999-04-25','YYYY-MM-DD'), N'Nam', 14, '008099000017', '0918000817', 'tienanh.t@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_18', 'D08', N'Nguyễn Mạnh Dũng', 'CAU_THU', TO_DATE('2000-04-14','YYYY-MM-DD'), N'Nam', 15, '008100000018', '0918000818', 'manhdung@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_19', 'D08', N'Đinh Tuấn Tài', 'CAU_THU', TO_DATE('1999-04-10','YYYY-MM-DD'), N'Nam', 16, '008099000019', '0918000819', 'tuantai.d@thecongviettel.vn', N'Tốt', 100, 'N');
INSERT INTO THANH_VIEN_DOI VALUES ('TV_D08_20', 'D08', N'Quàng Văn Cường', 'CAU_THU', TO_DATE('2001-08-11','YYYY-MM-DD'), N'Nam', 17, '008101000020', '0918000820', 'vancuong@thecongviettel.vn', N'Tốt', 100, 'N');

-- 6. INSERT DATA: TRAN_DAU (Đúng 20 trận đấu với đầy đủ trạng thái và vòng)
-- Trận 1 -> 5: Trạng thái FINISHED (Đã kết thúc, có tỷ số)
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus, NguoiDuyetKetQua) VALUES ('M01', 'V_LEAGUE_2026', 'D01', 'D02', 1, TO_TIMESTAMP('2026-02-10 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HANGDAY', 2, 1, 'FINISHED', 'FINAL', 'gs_anh');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus, NguoiDuyetKetQua) VALUES ('M02', 'V_LEAGUE_2026', 'D03', 'D04', 1, TO_TIMESTAMP('2026-02-11 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HOAXUAN', 0, 0, 'FINISHED', 'FINAL', 'gs_dung');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus, NguoiDuyetKetQua) VALUES ('M03', 'V_LEAGUE_2026', 'D05', 'D06', 1, TO_TIMESTAMP('2026-02-12 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THIENTRUONG', 3, 2, 'FINISHED', 'FINAL', 'gs_hien');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus, NguoiDuyetKetQua) VALUES ('M04', 'V_LEAGUE_2026', 'D07', 'D08', 1, TO_TIMESTAMP('2026-02-13 19:15:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_GODAU', 1, 2, 'FINISHED', 'FINAL', 'gs_quang');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus, NguoiDuyetKetQua) VALUES ('M05', 'V_LEAGUE_2026', 'D01', 'D03', 2, TO_TIMESTAMP('2026-02-18 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HANGDAY', 1, 1, 'FINISHED', 'FINAL', 'gs_tuan');

-- Trận 6 -> 10: Trạng thái PLAYING (Đang diễn ra trực tiếp)
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus) VALUES ('M06', 'V_LEAGUE_2026', 'D02', 'D04', 2, TO_TIMESTAMP('2026-06-28 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THONGNHAT', 0, 0, 'PLAYING', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus) VALUES ('M07', 'V_LEAGUE_2026', 'D05', 'D07', 2, TO_TIMESTAMP('2026-06-28 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THIENTRUONG', 1, 0, 'PLAYING', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus) VALUES ('M08', 'V_LEAGUE_2026', 'D06', 'D08', 2, TO_TIMESTAMP('2026-06-28 19:15:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THANHHOA', 2, 2, 'PLAYING', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus) VALUES ('M09', 'V_LEAGUE_2026', 'D01', 'D04', 3, TO_TIMESTAMP('2026-06-28 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_MYDINH', 0, 1, 'PLAYING', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TySoDoiA, TySoDoiB, TrangThaiTran, KetQuaStatus) VALUES ('M10', 'V_LEAGUE_2026', 'D02', 'D03', 3, TO_TIMESTAMP('2026-06-28 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THONGNHAT', 0, 0, 'PLAYING', 'PENDING');

-- Trận 11 -> 20: Trạng thái PENDING (Lịch thi đấu tương lai)
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M11', 'V_LEAGUE_2026', 'D05', 'D08', 3, TO_TIMESTAMP('2026-07-05 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THIENTRUONG', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M12', 'V_LEAGUE_2026', 'D06', 'D07', 3, TO_TIMESTAMP('2026-07-06 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THANHHOA', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M13', 'V_LEAGUE_2026', 'D01', 'D05', 4, TO_TIMESTAMP('2026-07-12 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HANGDAY', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M14', 'V_LEAGUE_2026', 'D02', 'D06', 4, TO_TIMESTAMP('2026-07-13 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THONGNHAT', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M15', 'V_LEAGUE_2026', 'D03', 'D07', 4, TO_TIMESTAMP('2026-07-14 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HOAXUAN', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M16', 'V_LEAGUE_2026', 'D04', 'D08', 4, TO_TIMESTAMP('2026-07-15 19:15:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_LACHTRAY', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M17', 'V_LEAGUE_2026', 'D01', 'D06', 5, TO_TIMESTAMP('2026-07-20 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HANGDAY', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M18', 'V_LEAGUE_2026', 'D02', 'D07', 5, TO_TIMESTAMP('2026-07-21 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_THONGNHAT', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M19', 'V_LEAGUE_2026', 'D03', 'D08', 5, TO_TIMESTAMP('2026-07-22 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_HOAXUAN', 'PENDING');
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran) VALUES ('M20', 'V_LEAGUE_2026', 'D04', 'D05', 5, TO_TIMESTAMP('2026-07-23 19:15:00','YYYY-MM-DD HH24:MI:SS'), 'SAN_LACHTRAY', 'PENDING');

-- 7. INSERT DATA: PHAN_CONG_TRAN_DAU 
-- Phân công đầy đủ ban trọng tài (Chính, Biên, VAR) & Giám sát cho tổ chức trận đấu
-- Trận M01
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M01', 'tt_lan', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M01', 'tt_vu', 'ASSISTANT_1');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M01', 'tt_hien', 'ASSISTANT_2');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M01', 'gs_anh', 'SUPERVISOR');

-- Trận M02
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M02', 'tt_chuan', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M02', 'tt_tuan', 'ASSISTANT_1');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M02', 'gs_dung', 'SUPERVISOR');

-- Trận M03
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M03', 'tt_nghi', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M03', 'tt_thanh', 'VAR');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M03', 'gs_hien', 'SUPERVISOR');

-- Trận M04
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M04', 'tt_duc', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M04', 'gs_quang', 'SUPERVISOR');

-- Trận M05
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M05', 'tt_tam', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M05', 'gs_tuan', 'SUPERVISOR');

-- Trận M06 (Đang đá)
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M06', 'tt_khang', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M06', 'gs_long', 'SUPERVISOR');

-- Trận M07 (Đang đá)
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M07', 'tt_lan', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M07', 'gs_son', 'SUPERVISOR');

-- Trận M08 (Đang đá)
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M08', 'tt_vu', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M08', 'gs_phong', 'SUPERVISOR');

-- Trận M09 (Đang đá)
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M09', 'tt_hien', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M09', 'gs_thinh', 'SUPERVISOR');

-- Trận M10 (Đang đá)
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M10', 'tt_chuan', 'MAIN_REFEREE');
INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau) VALUES ('M10', 'gs_minh', 'SUPERVISOR');

-- 8. INSERT DATA: AUDIT_LOG (10 dòng log hệ thống mẫu)
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('btc_admin', 'CREATE', 'GIAI_DAU', 'V_LEAGUE_2026', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('td_hanoi', 'INSERT', 'THANH_VIEN_DOI', 'TV_D01_01', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('tt_lan', 'UPDATE', 'TRAN_DAU', 'M01', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('td_hcm', 'INSERT', 'THANH_VIEN_DOI', 'TV_D02_01', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('td_haiphong', 'DELETE', 'THANH_VIEN_DOI', 'TV_D04_15', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('td_hanoi', 'UPDATE', 'THANH_VIEN_DOI', 'TV_D01_02', 'FAILED');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('gs_anh', 'APPROVE', 'TRAN_DAU', 'M01', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('gs_dung', 'APPROVE', 'TRAN_DAU', 'M02', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('btc_admin', 'UPDATE', 'USER_INFO', 'td_danang', 'SUCCESS');
INSERT INTO AUDIT_LOG (Username, ActionType, ObjectName, RecordID, Status) VALUES ('tt_chuan', 'UPDATE', 'TRAN_DAU', 'M06', 'SUCCESS');

-- CHỐT GIAO DỊCH SAU KHI ĐỔ DATA
COMMIT;

PROMPT DATABASE MOCK DATA INITIALIZED SUCCESSFULLY