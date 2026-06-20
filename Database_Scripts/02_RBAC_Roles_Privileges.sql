-- 1. TẠO VÀ BẢO VỆ ROLE BAN TỔ CHỨC [cite: 205, 208, 209, 318]
-- Đặt mật khẩu để bắt buộc kích hoạt bằng lệnh SET ROLE
CREATE ROLE Role_BTC IDENTIFIED BY "BtcPass2026#"; 

-- Cấp quyền hệ thống cho BTC có quyền đi gán tiếp (WITH ADMIN OPTION) [cite: 231, 344-350]
GRANT CREATE USER, ALTER USER, DROP USER TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE, GRANT ANY ROLE TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE SESSION TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE TABLE, CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO Role_BTC;
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE TO Role_BTC;

-- Cấp quyền truy xuất từ điển dữ liệu để BTC xem thông tin [cite: 249, 250, 256]
GRANT SELECT ON DBA_USERS TO Role_BTC;
GRANT SELECT ON DBA_ROLES TO Role_BTC;
GRANT SELECT ON DBA_ROLE_PRIVS TO Role_BTC;
GRANT SELECT ON DBA_SYS_PRIVS TO Role_BTC;
GRANT SELECT ON DBA_TAB_PRIVS TO Role_BTC;

-- ==========================================
-- 2. TẠO CÁC ROLE NGHIỆP VỤ CÒN LẠI [cite: 320-325]
CREATE ROLE Role_TD; -- Trưởng đoàn
CREATE ROLE Role_TT; -- Trọng tài
CREATE ROLE Role_GS; -- Giám sát / Khán giả

-- ==========================================
-- 3. PHÂN QUYỀN ĐỐI TƯỢNG (OBJECT PRIVILEGES) [cite: 360-368]

-- A. Dành cho Trọng Tài (Role_TT) [cite: 336, 337]
GRANT SELECT ON SPORTS_OWNER.LICH_THI_DAU TO Role_TT;
GRANT SELECT ON SPORTS_OWNER.KET_QUA_TRAN_DAU TO Role_TT;
-- Cấp quyền mức Cột: Trọng tài CHỈ được cập nhật Tỷ số và Thẻ phạt [cite: 227, 370-373]
GRANT UPDATE (TySoDoiA, TySoDoiB, ThePhatDoiA, ThePhatDoiB) ON SPORTS_OWNER.KET_QUA_TRAN_DAU TO Role_TT;

-- B. Dành cho Trưởng Đoàn (Role_TD) [cite: 333, 334]
-- (Quyền thao tác trên toàn bảng. Oracle VPD sẽ tự động lọc dòng theo Mã Đội sau) [cite: 432-438]
GRANT SELECT, INSERT, UPDATE, DELETE ON SPORTS_OWNER.VAN_DONG_VIEN TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.DOI_THI_DAU TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.LICH_THI_DAU TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.KET_QUA_TRAN_DAU TO Role_TD;

-- C. Dành cho Giám sát / Khán giả (Role_GS) [cite: 338, 339]
-- (Chỉ có quyền Read-Only. Data Masking sẽ tự động che cột nhạy cảm sau) [cite: 476-478, 483-487]
GRANT SELECT ON SPORTS_OWNER.LICH_THI_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.KET_QUA_TRAN_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.VAN_DONG_VIEN TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.DOI_THI_DAU TO Role_GS;