SET SERVEROUTPUT ON;
SET ECHO ON;

/* ====================================================================
   BƯỚC 1: CẤP NHÃN PHIÊN (SESSION LABEL) CHO SCHEMA OWNER
   Giúp SPORTS_OWNER vượt qua WRITE_CONTROL của OLS khi Insert dữ liệu
   ==================================================================== */
CONN SEC_ADMIN/SEC_ADMIN;
BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'SPORTS_OWNER',
        max_read_label  => 'CONFIDENTIAL::TD',
        max_write_label => 'CONFIDENTIAL::TD',
        def_label       => 'CONFIDENTIAL::TD', 
        row_label       => 'CONFIDENTIAL::TD'  
    );
    COMMIT;
END;
/

/* ====================================================================
   BƯỚC 2: KHỞI TẠO DỮ LIỆU NGHIỆP VỤ BẰNG TÀI KHOẢN CHỦ SỞ HỮU
   ==================================================================== */
CONN SPORTS_OWNER/CNTT2026!;

-- 1. KHỞI TẠO TÀI KHOẢN (Để trống MaDoi tránh lỗi Circular Dependency)
-- Pass mặc định: 123456
INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('btc_admin', 'Nguyễn Trưởng Ban', 'btc@vpf.vn', '0901111111', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('123456'), 'Role_BTC');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_hnfc', 'Trần Trưởng Đoàn HN', 'td_hnfc@vpf.vn', '0902222222', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('123456'), 'Role_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('td_hcmfc', 'Lê Trưởng Đoàn HCM', 'td_hcmfc@vpf.vn', '0903333333', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('123456'), 'Role_TD');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('tt_chinh', 'Phạm Trọng Tài', 'tt_chinh@vpf.vn', '0904444444', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('123456'), 'Role_TT');

INSERT INTO USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro)
VALUES ('gs_tran', 'Hoàng Giám Sát', 'gs_tran@vpf.vn', '0905555555', SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD('123456'), 'Role_GS');

-- 2. KHỞI TẠO GIẢI ĐẤU & SÂN THI ĐẤU
INSERT INTO GIAI_DAU (MaGiai, TenGiai, NamToChuc, NgayBatDau, NgayKetThuc, TrangThai)
VALUES ('VLEAGUE26', 'V-League 2026', 2026, TO_DATE('2026-08-01', 'YYYY-MM-DD'), TO_DATE('2027-05-30', 'YYYY-MM-DD'), 'REGISTRATION');

INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua, MoTa)
VALUES ('MYDINH', 'SVĐ Quốc gia Mỹ Đình', 'Đường Lê Đức Thọ, Hà Nội', 40192, 'Sân vận động quốc gia');

INSERT INTO SAN_THI_DAU (MaSan, TenSan, DiaChi, SucChua, MoTa)
VALUES ('THONGNHAT', 'SVĐ Thống Nhất', '138 Đào Duy Từ, TP.HCM', 15000, 'Sân nhà của CLB TP.HCM');

-- 3. KHỞI TẠO ĐỘI BÓNG & CẬP NHẬT NGƯỢC RÀNG BUỘC CHO USER
INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha, NgayThanhLap)
VALUES ('HNFC', 'VLEAGUE26', 'Hà Nội FC', 'td_hnfc', 'MYDINH', TO_DATE('2006-01-18', 'YYYY-MM-DD'));

INSERT INTO DOI_THI_DAU (MaDoi, MaGiai, TenDoi, TruongDoan_Username, SanNha, NgayThanhLap)
VALUES ('HCMFC', 'VLEAGUE26', 'CLB TP.HCM', 'td_hcmfc', 'THONGNHAT', TO_DATE('1975-11-01', 'YYYY-MM-DD'));

UPDATE USER_INFO SET MaDoi = 'HNFC' WHERE Username = 'td_hnfc';
UPDATE USER_INFO SET MaDoi = 'HCMFC' WHERE Username = 'td_hcmfc';

-- 4. KHỞI TẠO THÀNH VIÊN ĐỘI (Test OLS Label & Data Redaction)
INSERT INTO THANH_VIEN_DOI (MaThanhVien, MaDoi, TenThanhVien, LoaiThanhVien, NgaySinh, GioiTinh, SoAo, CCCD, SoDienThoai, EmailThanhVien, ThongTinSucKhoe)
VALUES ('TV001', 'HNFC', 'Nguyễn Văn Quyết', 'CAU_THU', TO_DATE('1991-06-27', 'YYYY-MM-DD'), 'Nam', 10, '001091123456', '0981112222', 'quyet@hnfc.vn', 'Đủ điều kiện thi đấu');

INSERT INTO THANH_VIEN_DOI (MaThanhVien, MaDoi, TenThanhVien, LoaiThanhVien, NgaySinh, GioiTinh, SoAo, CCCD, SoDienThoai, EmailThanhVien, ThongTinSucKhoe)
VALUES ('TV002', 'HNFC', 'Đỗ Duy Mạnh', 'CAU_THU', TO_DATE('1996-09-29', 'YYYY-MM-DD'), 'Nam', 2, '001096123456', '0982223333', 'manh@hnfc.vn', 'Đang hồi phục chấn thương nhẹ');

INSERT INTO THANH_VIEN_DOI (MaThanhVien, MaDoi, TenThanhVien, LoaiThanhVien, NgaySinh, GioiTinh, SoAo, CCCD, SoDienThoai, EmailThanhVien, ThongTinSucKhoe)
VALUES ('TV003', 'HCMFC', 'Patrik Lê Giang', 'CAU_THU', TO_DATE('1992-09-08', 'YYYY-MM-DD'), 'Nam', 89, '001092654321', '0911112222', 'legiang@hcmfc.vn', 'Đủ điều kiện thi đấu');

INSERT INTO THANH_VIEN_DOI (MaThanhVien, MaDoi, TenThanhVien, LoaiThanhVien, NgaySinh, GioiTinh, SoAo, CCCD, SoDienThoai, EmailThanhVien, ThongTinSucKhoe)
VALUES ('TV004', 'HCMFC', 'Phùng Thanh Phương', 'HLV_TRUONG', TO_DATE('1978-03-30', 'YYYY-MM-DD'), 'Nam', NULL, '001078654321', '0912223333', 'phuong@hcmfc.vn', 'Tốt');

-- 5. KHỞI TẠO TRẬN ĐẤU & PHÂN CÔNG TRỌNG TÀI (Test luồng ABAC)
INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran, KetQuaStatus)
VALUES ('TR01', 'VLEAGUE26', 'HNFC', 'HCMFC', 1, TO_TIMESTAMP('2026-08-15 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'MYDINH', 'PENDING', 'PENDING');

INSERT INTO TRAN_DAU (MaTranDau, MaGiai, MaDoiA, MaDoiB, VongDau, NgayGioThiDau, MaSan, TrangThaiTran, KetQuaStatus)
VALUES ('TR02', 'VLEAGUE26', 'HCMFC', 'HNFC', 14, TO_TIMESTAMP('2026-11-20 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'THONGNHAT', 'PLAYING', 'PENDING');

INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau)
VALUES ('TR01', 'tt_chinh', 'MAIN_REFEREE');

INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau)
VALUES ('TR01', 'gs_tran', 'SUPERVISOR');

INSERT INTO PHAN_CONG_TRAN_DAU (MaTranDau, Username, VaiTroTranDau)
VALUES ('TR02', 'tt_chinh', 'MAIN_REFEREE');

COMMIT;
PROMPT === SINH DU LIEU MAU THANH CONG ===