SET SERVEROUTPUT ON;
SET ECHO ON;

-- Kết nối bằng tài khoản quản trị hệ thống có thẩm quyền quản lý vai trò
CONN SYSTEM/manager;

-- Sử dụng PL/SQL động quét từ điển hệ thống để xóa bỏ các Role cũ tránh lỗi lặp cấu trúc khi thực thi lại script
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

-- Khởi tạo nhóm quyền Ban Tổ Chức, áp dụng mật khẩu bảo vệ để ép buộc kích hoạt an toàn thông qua lệnh SET ROLE ở tầng ứng dụng
CREATE ROLE Role_BTC IDENTIFIED BY "BtcPass2026#"; 

-- Cấp đặc quyền quản trị tài khoản vòng đời người dùng kèm tùy chọn phân cấp tiếp cho Ban Tổ Chức
GRANT CREATE USER, ALTER USER, DROP USER TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE, GRANT ANY ROLE TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE SESSION TO Role_BTC WITH ADMIN OPTION;
GRANT CREATE TABLE, CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO Role_BTC;
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE TO Role_BTC;

-- Cấp đặc quyền truy xuất từ điển dữ liệu hệ thống để Ban Tổ Chức thực hiện giám sát cấu hình bảo mật trên Dashboard ứng dụng Web
GRANT SELECT ON DBA_USERS TO Role_BTC;
GRANT SELECT ON DBA_ROLES TO Role_BTC;
GRANT SELECT ON DBA_ROLE_PRIVS TO Role_BTC;
GRANT SELECT ON DBA_SYS_PRIVS TO Role_BTC;
GRANT SELECT ON DBA_TAB_PRIVS TO Role_BTC;


-- Khởi tạo các nhóm quyền vai trò nghiệp vụ thực tế cho các phân hệ chức năng của giải đấu
CREATE ROLE Role_TD; -- Nhóm quyền dành cho Trưởng đoàn quản lý câu lạc bộ
CREATE ROLE Role_TT; -- Nhóm quyền dành cho Tổ trọng tài điều khiển chuyên môn
CREATE ROLE Role_GS; -- Nhóm quyền dành cho Giám sát trận đấu và Khán giả tra cứu công khai


-- Phân quyền cho vai trò Trọng tài (Role_TT): Chỉ đọc thông tin nền và cập nhật số liệu kết quả giới hạn nghiêm ngặt ở mức cột
GRANT SELECT ON SPORTS_OWNER.GIAI_DAU TO Role_TT;
GRANT SELECT ON SPORTS_OWNER.SAN_THI_DAU TO Role_TT;
GRANT SELECT ON SPORTS_OWNER.DOI_THI_DAU TO Role_TT;
GRANT SELECT ON SPORTS_OWNER.TRAN_DAU TO Role_TT;
GRANT SELECT ON SPORTS_OWNER.PHAN_CONG_TRAN_DAU TO Role_TT;

-- Ép buộc an toàn: Trọng tài tuyệt đối không được sửa lịch thi đấu, sân vận động mà CHỈ được cập nhật tỷ số, thẻ phạt và trạng thái diễn ra của trận đấu
GRANT UPDATE (TySoDoiA, TySoDoiB, TheVangDoiA, TheVangDoiB, TheDoDoiA, TheDoDoiB, TrangThaiTran) ON SPORTS_OWNER.TRAN_DAU TO Role_TT;

-- Phân quyền cho vai trò Trưởng đoàn (Role_TD): Toàn quyền thao tác nhân sự đội bóng bóng. Cơ chế độc lập dòng dữ liệu sẽ do chính sách VPD tại File 04 đảm nhiệm
GRANT SELECT ON SPORTS_OWNER.GIAI_DAU TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.SAN_THI_DAU TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.DOI_THI_DAU TO Role_TD;
GRANT SELECT, INSERT, UPDATE, DELETE ON SPORTS_OWNER.THANH_VIEN_DOI TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.TRAN_DAU TO Role_TD;
GRANT SELECT ON SPORTS_OWNER.PHAN_CONG_TRAN_DAU TO Role_TD;

-- Phân quyền cho vai trò Giám sát / Khán giả (Role_GS): Quyền độc giả Read-Only thuần túy trên toàn bộ hệ thống giải đấu. Lớp Data Masking sẽ xử lý che dữ liệu cá nhân sau
GRANT SELECT ON SPORTS_OWNER.USER_INFO TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.GIAI_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.SAN_THI_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.DOI_THI_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.THANH_VIEN_DOI TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.TRAN_DAU TO Role_GS;
GRANT SELECT ON SPORTS_OWNER.PHAN_CONG_TRAN_DAU TO Role_GS;

PROMPT ROLES AND PRIVILEGES CONFIGURED SUCCESSFULLY