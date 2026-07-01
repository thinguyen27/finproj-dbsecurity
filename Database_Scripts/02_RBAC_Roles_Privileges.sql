SET SERVEROUTPUT ON;
SET ECHO ON;

-- =========================================================================
-- PHẦN 1: QUẢN TRỊ HỆ THỐNG - KHỞI TẠO ROLE VÀ CẤP QUYỀN SYSTEM
-- =========================================================================
CONN SYSTEM/manager;

-- Sử dụng PL/SQL động quét từ điển hệ thống để xóa bỏ các Role cũ
BEGIN
    FOR r IN (
        SELECT role 
        FROM dba_roles 
        WHERE role IN ('ROLE_BTC', 'ROLE_TD', 'ROLE_TT', 'ROLE_GS')
    ) LOOP
        EXECUTE IMMEDIATE 'DROP ROLE ' || r.role;
    END LOOP;
END;
/

-- Khởi tạo các nhóm quyền vai trò (Viết hoa toàn bộ để đồng bộ Constraint)
CREATE ROLE ROLE_BTC IDENTIFIED BY "BtcPass2026#"; 
CREATE ROLE ROLE_TD; 
CREATE ROLE ROLE_TT; 
CREATE ROLE ROLE_GS; 

-- Cấp quyền System cho Ban Tổ Chức (ROLE_BTC)
GRANT CREATE USER, ALTER USER, DROP USER TO ROLE_BTC WITH ADMIN OPTION;
GRANT CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE, GRANT ANY ROLE TO ROLE_BTC WITH ADMIN OPTION;
GRANT CREATE SESSION TO ROLE_BTC WITH ADMIN OPTION;
GRANT CREATE TABLE, CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO ROLE_BTC;
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE TO ROLE_BTC;

-- FIX: Thay vì Grant từng view DBA_ dễ gây lỗi ORA-01031 do SYSTEM thiếu Grant Option,
-- ta cấp đặc quyền SELECT ANY DICTIONARY để BTC truy xuất toàn bộ từ điển hệ thống phục vụ Dashboard.
GRANT SELECT ANY DICTIONARY TO ROLE_BTC;


-- =========================================================================
-- PHẦN 2: PHÂN QUYỀN TRUY XUẤT DATA - DO DATA OWNER THỰC HIỆN
-- =========================================================================
CONN SPORTS_OWNER/CNTT2026!;

-- Phân quyền cho vai trò Trọng tài (ROLE_TT): 
-- Chỉ đọc thông tin nền và cập nhật số liệu kết quả giới hạn nghiêm ngặt ở mức cột
GRANT SELECT ON GIAI_DAU TO ROLE_TT;
GRANT SELECT ON SAN_THI_DAU TO ROLE_TT;
GRANT SELECT ON DOI_THI_DAU TO ROLE_TT;
GRANT SELECT ON TRAN_DAU TO ROLE_TT;
GRANT SELECT ON PHAN_CONG_TRAN_DAU TO ROLE_TT;
GRANT UPDATE (TySoDoiA, TySoDoiB, TheVangDoiA, TheVangDoiB, TheDoDoiA, TheDoDoiB, TrangThaiTran) ON TRAN_DAU TO ROLE_TT;

-- Phân quyền cho vai trò Trưởng đoàn (ROLE_TD): 
-- Cơ chế độc lập dòng dữ liệu sẽ do chính sách VPD tại File 04 đảm nhiệm
GRANT SELECT ON GIAI_DAU TO ROLE_TD;
GRANT SELECT ON SAN_THI_DAU TO ROLE_TD;
GRANT SELECT ON DOI_THI_DAU TO ROLE_TD;
GRANT SELECT, INSERT, UPDATE, DELETE ON THANH_VIEN_DOI TO ROLE_TD;
GRANT SELECT ON TRAN_DAU TO ROLE_TD;
GRANT SELECT ON PHAN_CONG_TRAN_DAU TO ROLE_TD;

-- Phân quyền cho vai trò Giám sát / Khán giả (ROLE_GS): 
-- Quyền độc giả Read-Only thuần túy. Lớp Data Masking sẽ xử lý che dữ liệu cá nhân sau
GRANT SELECT ON USER_INFO TO ROLE_GS;
GRANT SELECT ON GIAI_DAU TO ROLE_GS;
GRANT SELECT ON SAN_THI_DAU TO ROLE_GS;
GRANT SELECT ON DOI_THI_DAU TO ROLE_GS;
GRANT SELECT ON THANH_VIEN_DOI TO ROLE_GS;
GRANT SELECT ON TRAN_DAU TO ROLE_GS;
GRANT SELECT ON PHAN_CONG_TRAN_DAU TO ROLE_GS;

PROMPT ROLES AND PRIVILEGES CONFIGURED SUCCESSFULLY