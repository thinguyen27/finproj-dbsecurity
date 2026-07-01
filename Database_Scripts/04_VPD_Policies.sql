SET SERVEROUTPUT ON;
SET ECHO ON;

-- Kết nối bằng tài khoản quản trị an ninh để cấu hình chính sách VPD và Ngữ cảnh Session
CONN SEC_ADMIN/SEC_ADMIN;

-- Khởi tạo lại Context an toàn gắn liền với Trình quản lý Trusted Package
CREATE OR REPLACE CONTEXT SPORT_CTX USING SEC_ADMIN.PKG_SPORT_CONTEXT;
/

-- Bảng đặc tả Package quản trị Ngữ cảnh Session (Package Specification)
CREATE OR REPLACE PACKAGE SEC_ADMIN.PKG_SPORT_CONTEXT AS
    PROCEDURE INITIALIZE_SESSION(
        p_username IN VARCHAR2,
        p_role     IN VARCHAR2,
        p_team_id  IN VARCHAR2 DEFAULT NULL
    );
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
        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'USERNAME', UPPER(p_username));
        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'ROLE', UPPER(p_role));

        IF p_team_id IS NOT NULL THEN
            v_team := UPPER(p_team_id);
        ELSE
            BEGIN
                SELECT MaDoi INTO v_team
                FROM SPORTS_OWNER.USER_INFO
                WHERE UPPER(Username) = UPPER(p_username);
            EXCEPTION WHEN OTHERS THEN
                v_team := NULL;
            END;
        END IF;

        DBMS_SESSION.SET_CONTEXT('SPORT_CTX', 'TEAM_ID', NVL(UPPER(v_team), 'NONE'));
    END INITIALIZE_SESSION;

    PROCEDURE CLEAR_SESSION AS
    BEGIN
        DBMS_SESSION.CLEAR_CONTEXT(
                    namespace => 'SPORT_CTX',
                    client_id => NULL,       
                    attribute => NULL
        );
    END CLEAR_SESSION;
END PKG_SPORT_CONTEXT;
/

-- ĐÃ SỬA: Đồng bộ tên Role in hoa
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO ROLE_BTC;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO SPORTS_OWNER;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO ROLE_TD;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO ROLE_TT;
GRANT EXECUTE ON SEC_ADMIN.PKG_SPORT_CONTEXT TO ROLE_GS;
/


-- Hàm chính sách: Bảo vệ thông tin tài khoản cá nhân trên bảng USER_INFO
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_USER_INFO (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    IF SYS_CONTEXT('SPORT_CTX','USERNAME') IS NULL THEN
        RETURN '1=1';
    END IF;
    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    IF v_role = 'ROLE_BTC' THEN
        RETURN 'IsDeleted = ''N''';
    ELSE
        -- Người dùng thông thường chỉ thấy duy nhất bản ghi trùng với Username của mình
        RETURN q'[
            IsDeleted = 'N'
            AND UPPER(Username) =
            SYS_CONTEXT('SPORT_CTX','USERNAME')
        ]';
    END IF;
END FN_VPD_USER_INFO;
/


-- Hàm chính sách: Phân hoạch hiển thị bảng phân công nhiệm vụ trận đấu
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_PHAN_CONG (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    IF v_role = 'ROLE_BTC' THEN
        RETURN '1=1';
    ELSIF v_role IN ('ROLE_TT','ROLE_GS') THEN
        RETURN q'[
            UPPER(Username) =
            SYS_CONTEXT('SPORT_CTX','USERNAME')
        ]';
    ELSE
        RETURN '1=2';
    END IF;
END FN_VPD_PHAN_CONG;
/


-- Hàm chính sách: Kiểm soát dòng dữ liệu nhân sự trên bảng THANH_VIEN_DOI
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_THANH_VIEN (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    -- VÁ LỖI ORA-28115: Cho phép schema owner thao tác khi load data trực tiếp (Context rỗng)
    IF SYS_CONTEXT('SPORT_CTX', 'USERNAME') IS NULL THEN
        RETURN '1=1';
    END IF;

    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    IF v_role='ROLE_BTC' THEN
        RETURN 'IsDeleted=''N''';
    ELSIF v_role='ROLE_TD' THEN
        RETURN q'[
            IsDeleted='N'
            AND MaDoi=
            SYS_CONTEXT('SPORT_CTX','TEAM_ID')
        ]';
    ELSIF v_role IN ('ROLE_TT','ROLE_GS') THEN
        RETURN 'IsDeleted=''N''';
    ELSE
        RETURN '1=2';
    END IF;
END FN_VPD_THANH_VIEN;
/


-- Hàm chính sách: Kiểm soát luồng thay đổi kết quả trên bảng TRAN_DAU 
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_TRAN_DAU_UPDATE (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(30);
BEGIN
    v_role := SYS_CONTEXT('SPORT_CTX', 'ROLE');

    IF v_role = 'ROLE_BTC' THEN
        RETURN '1=1';
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
        RETURN '1=2';
    END IF;
END FN_VPD_TRAN_DAU_UPDATE;
/


-- Hàm chính sách: Kiểm soát hiển thị danh sách lịch thi đấu tổng quan
CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_TRAN_DAU_SELECT (
    p_schema IN VARCHAR2,
    p_object IN VARCHAR2
) RETURN VARCHAR2 AS
BEGIN
    RETURN 'IsDeleted = ''N''';
END FN_VPD_TRAN_DAU_SELECT;
/

CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_AUDIT (
    p_schema VARCHAR2,
    p_object VARCHAR2
) RETURN VARCHAR2 AS
BEGIN
    IF SYS_CONTEXT('SPORT_CTX','ROLE') = 'ROLE_BTC' THEN
        RETURN '1=1';
    ELSE
        RETURN '1=2';
    END IF;
END;
/


BEGIN
    -- Dọn dẹp dứt điểm các chính sách cũ 
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'USER_INFO', 'POLICY_USER_PROFILE'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'PHAN_CONG_TRAN_DAU', 'POLICY_VIEW_PHANCONG'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'THANH_VIEN_DOI', 'POLICY_THANHVIEN'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'TRAN_DAU', 'POLICY_TRAN_UPDATE'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER', 'TRAN_DAU', 'POLICY_TRAN_SELECT'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_RLS.DROP_POLICY('SPORTS_OWNER','AUDIT_LOG','POLICY_AUDIT'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- 1. USER_INFO
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'USER_INFO',
        policy_name     => 'POLICY_USER_PROFILE',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_USER_INFO',
        statement_types => 'SELECT',
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );

    -- 2. PHAN_CONG_TRAN_DAU
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'PHAN_CONG_TRAN_DAU',
        policy_name     => 'POLICY_VIEW_PHANCONG',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_PHAN_CONG',
        statement_types => 'SELECT',
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );

    -- 3. THANH_VIEN_DOI
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'THANH_VIEN_DOI',
        policy_name     => 'POLICY_THANHVIEN',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_THANH_VIEN',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE,
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );

    -- 4. TRAN_DAU (UPDATE)
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

    -- 5. TRAN_DAU (SELECT)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'TRAN_DAU',
        policy_name     => 'POLICY_TRAN_SELECT',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_TRAN_DAU_SELECT',
        statement_types => 'SELECT',
        policy_type     => DBMS_RLS.STATIC
    );

    -- 6. AUDIT_LOG
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'SPORTS_OWNER',
        object_name     => 'AUDIT_LOG',
        policy_name     => 'POLICY_AUDIT',
        function_schema => 'SEC_ADMIN',
        policy_function => 'FN_VPD_AUDIT',
        statement_types => 'SELECT',
        policy_type     => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/

-- BƯỚC FIX LỖI FILE 03: Biên dịch lại Package PKG_CRYPTO_UTILS sau khi PKG_SPORT_CONTEXT đã được tạo
ALTER PACKAGE SEC_ADMIN.PKG_CRYPTO_UTILS COMPILE BODY;

PROMPT VIRTUAL PRIVATE DATABASE (VPD) CONFIGURED SUCCESSFULLY