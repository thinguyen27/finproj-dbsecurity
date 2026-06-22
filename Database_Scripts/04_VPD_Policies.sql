SET SERVEROUTPUT ON;
SET ECHO ON;

-- Kết nối bằng tài khoản quản trị an ninh để cấu hình chính sách VPD và Ngữ cảnh Session
CONN SEC_ADMIN/SEC_ADMIN;

-- Giải phóng cấu hình vùng ngữ cảnh cũ nếu có để làm sạch môi trường thực thi lại script
BEGIN
    EXECUTE IMMEDIATE 'DROP CONTEXT SPORT_CTX';
EXCEPTION WHEN OTHERS THEN NULL; 
END;
/

-- Khởi tạo lại Context an toàn gắn liền với Trình quản lý Trusted Package
CREATE CONTEXT SPORT_CTX USING SEC_ADMIN.PKG_SPORT_CONTEXT;
/

-- Bảng đặc tả Package quản trị Ngữ cảnh Session (Package Specification)
CREATE OR REPLACE PACKAGE SEC_ADMIN.PKG_SPORT_CONTEXT AS
    -- Thủ tục đồng bộ và nạp dữ liệu phiên làm việc từ File 03 xuống bộ nhớ an toàn Oracle
    PROCEDURE INITIALIZE_SESSION(
        p_username IN VARCHAR2,
        p_role     IN VARCHAR2,
        p_team_id  IN VARCHAR2 DEFAULT NULL
    );
    -- Thủ tục giải phóng vùng nhớ đệm Context khi người dùng đăng xuất khỏi hệ thống Web
    PROCEDURE CLEAR_SESSION;
END PKG_SPORT_CONTEXT;
/

-- Triển khai nội dung thực thi chi tiết của Package quản trị Ngữ cảnh (Package Body)
CREATE OR REPLACE PACKAGE BODY SEC_ADMIN.PKG_SPORT_CONTEXT AS
    PROCEDURE INITIALIZE_SESSION(
        p_username IN VARCHAR2,
        p_role     IN VARCHAR2,
        p_team_id  IN VARCHAR2 DEFAULT NULL
    ) AS
        v_team VARCHAR2(20);
    BEGIN
        -- Chuyển đổi viết hoa và nạp danh tính, vai trò kiểm tra hệ thống vào Context
        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'USERNAME', UPPER(p_username));
        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'ROLE', UPPER(p_role));

        -- Nếu ứng dụng truyền tường minh mã đội bóng (MaDoi) từ Web UI
        IF p_team_id IS NOT NULL THEN
            v_team := UPPER(p_team_id);
        ELSE
            -- Nếu không truyền, hệ thống tự động truy vấn ngược bảng tài khoản hệ thống để lấy thuộc tính cách ly
            BEGIN
                SELECT MaDoi INTO v_team
                FROM SPORTS_OWNER.USER_INFO
                WHERE UPPER(Username) = UPPER(p_username);
            EXCEPTION WHEN OTHERS THEN
                v_team := NULL;
            END;
        END IF;

        -- Thiết lập mã đội bảo mật, mặc định trả về 'NONE' cho các vai trò diện rộng (BTC, Trọng tài)
        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'TEAM_ID', NVL(UPPER(v_team), 'NONE'));
    END INITIALIZE_SESSION;

    PROCEDURE CLEAR_SESSION AS
    BEGIN
        DBMS_SESSION.CLEAR_CONTEXT('SPORT_CTX');
    END CLEAR_SESSION;
END PKG_SPORT_CONTEXT;
/

-- Cấp quyền thực thi Package khởi tạo phiên cho các vai trò hệ thống đã định nghĩa
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO Role_BTC;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO SPORTS_OWNER;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO Role_TD;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO Role_TT;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO Role_GS;
/

-- Hàm chính sách 1: Kiểm soát dòng dữ liệu nhân sự trên bảng THANH_VIEN_DOI
-- Nghiệp vụ: Chặn hiển thị bản ghi đã xóa mềm. Ép buộc Trưởng đoàn (Role_TD) chỉ thao tác trên thành viên đội mình.
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_THANH_VIEN (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    -- Ban tổ chức giải đấu (ROLE_BTC) giữ quyền quản trị toàn cục dữ liệu sạch
    IF v_role = 'ROLE_BTC' THEN
        RETURN 'IsDeleted = ''N''';
    END IF;

    -- Áp dụng mệnh đề cách ly ranh giới câu lạc bộ đối với Trưởng đoàn (ROLE_TD)
    IF v_role = 'ROLE_TD' THEN
        RETURN 'IsDeleted = ''N'' AND MaDoi = SYS_CONTEXT(''SPORT_CTX'', ''TEAM_ID'')';
    ELSE
        -- Tổ trọng tài (Role_TT) và Giám sát/Khán giả (Role_GS) chỉ được xem danh mục chung chưa bị xóa mềm
        RETURN 'IsDeleted = ''N''';
    END IF;
END FN_VPD_THANH_VIEN;
/

-- Hàm chính sách 2: Kiểm soát luồng thay đổi kết quả trên bảng TRAN_DAU áp dụng mô hình thuộc tính ABAC nâng cao
-- Nghiệp vụ: Trọng tài (ROLE_TT) chỉ sửa được trận mình bắt chính/VAR, khi trận đấu đang LIVE và biên bản chưa khóa (PENDING).
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_TRAN_DAU_UPDATE (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    -- Ban tổ chức giữ quyền tối cao điều chỉnh sửa lỗi kết quả thi đấu
    IF v_role = 'ROLE_BTC' THEN
        RETURN '1=1';
    -- Ép buộc chính sách ABAC đa thuộc tính thông qua toán tử q'[]' trực quan cho Tổ trọng tài
    ELSIF v_role = 'ROLE_TT' THEN
        RETURN q'[
            MaTranDau IN (
                SELECT MaTranDau 
                FROM SPORTS_OWNER.PHAN_CONG_TRAN_DAU 
                WHERE UPPER(Username) = SYS_CONTEXT('SPORT_CTX', 'USERNAME')
                  AND VaiTroTranDau IN ('MAIN_REFEREE', 'VAR')
            )
            AND TrangThaiTran = 'PLAYING' 
            AND KetQuaStatus = 'PENDING'
            AND IsDeleted = 'N'
        ]';
    ELSE
        -- Chặn đứng tuyệt đối quyền UPDATE kết quả thi đấu đối với Trưởng đoàn hoặc Khán giả
        RETURN '1=2';   -- Mệnh đề luôn luôn sai
    END IF;
END FN_VPD_TRAN_DAU_UPDATE;
/

-- Hàm chính sách 3: Kiểm soát hiển thị danh sách lịch thi đấu tổng quan (SELECT) trên bảng TRAN_DAU
-- Nghiệp vụ: Ẩn hoàn toàn các trận đấu đã bị xóa mềm một cách trong suốt đối với mọi đối tượng truy vấn
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_TRAN_DAU_SELECT (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
BEGIN
    RETURN 'IsDeleted = ''N''';
END FN_VPD_TRAN_DAU_SELECT;
/

-- Khối lệnh PL/SQL áp dụng đóng gói chính sách bảo mật lên cơ sở dữ liệu thực tế bằng package quản trị RLS
BEGIN
    -- Gỡ bỏ các cấu hình chính sách cũ để làm sạch môi trường, tránh lỗi trùng lặp khi chạy lại script
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'THANH_VIEN_DOI', 'POLICY_THANHVIEN'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'TRAN_DAU', 'POLICY_TRAN_UPDATE'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'TRAN_DAU', 'POLICY_TRAN_SELECT'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- Gán chính sách bảo vệ thực thể thành viên câu lạc bộ (SELECT, INSERT, UPDATE, DELETE)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'THANH_VIEN_DOI',
        policy_name     => 'POLICY_THANHVIEN',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_THANH_VIEN',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE, -- Ngăn Trưởng đoàn đổi mã MaDoi sang câu lạc bộ khác nhằm tẩu tán dữ liệu thành viên
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );

    -- Gán chính sách thuộc tính phức hợp ABAC cho luồng cập nhật số liệu chuyên môn trận đấu (UPDATE)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'TRAN_DAU',
        policy_name     => 'POLICY_TRAN_UPDATE',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_TRAN_DAU_UPDATE',
        statement_types => 'UPDATE',
        update_check    => TRUE,
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );

    -- Gán chính sách lọc dữ liệu tĩnh, ẩn các bản ghi đã xóa mềm khi xem lịch thi đấu (SELECT)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'TRAN_DAU',
        policy_name     => 'POLICY_TRAN_SELECT',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_TRAN_DAU_SELECT',
        statement_types => 'SELECT',
        policy_type     => DBMS_RLS.STATIC -- Tối ưu hiệu năng tối đa cho Shared Pool vì điều kiện IsDeleted = 'N' là cố định
    );
END;
/

PROMPT VIRTUAL PRIVATE DATABASE (VPD) CONFIGURED SUCCESSFULLY