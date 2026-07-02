SET SERVEROUTPUT ON;
SET ECHO ON;

-- =========================================================================
-- PHẦN 1: BỔ SUNG CẤU TRÚC BẢNG AUDIT_LOG VÀ CẬP NHẬT TRIGGER DML
-- =========================================================================
CONN SPORTS_OWNER/CNTT2026!;

-- Thêm cột phục vụ OLS và Phân mảnh VPD
ALTER TABLE SPORTS_OWNER.AUDIT_LOG ADD OLS_LABEL NUMBER(10);
ALTER TABLE SPORTS_OWNER.AUDIT_LOG ADD TeamCode VARCHAR2(20);

-- Cập nhật lại Trigger nhân sự để ghi nhận TeamCode
CREATE OR REPLACE TRIGGER TRG_AUDIT_THANH_VIEN
AFTER INSERT OR UPDATE OR DELETE ON SPORTS_OWNER.THANH_VIEN_DOI
FOR EACH ROW
DECLARE
    v_action   VARCHAR2(20);
    v_old_json CLOB := NULL;
    v_new_json CLOB := NULL;
    v_user     VARCHAR2(50);
    v_ip       VARCHAR2(100);
BEGIN
    v_user := NVL(SYS_CONTEXT('SPORT_CTX', 'USERNAME'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
    v_ip   := SYS_CONTEXT('USERENV', 'IP_ADDRESS');

    IF INSERTING THEN
        v_action := 'INSERT';
        v_new_json := JSON_OBJECT(
            'MaThanhVien'   VALUE :NEW.MaThanhVien,
            'MaDoi'         VALUE :NEW.MaDoi,
            'TenThanhVien'  VALUE :NEW.TenThanhVien,
            'LoaiThanhVien' VALUE :NEW.LoaiThanhVien
        );
        INSERT INTO SPORTS_OWNER.AUDIT_LOG (Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP, TeamCode)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :NEW.MaThanhVien, NULL, v_new_json, v_ip, :NEW.MaDoi);

    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_old_json := JSON_OBJECT(
            'MaThanhVien'   VALUE :OLD.MaThanhVien,
            'MaDoi'         VALUE :OLD.MaDoi,
            'TenThanhVien'  VALUE :OLD.TenThanhVien,
            'LoaiThanhVien' VALUE :OLD.LoaiThanhVien
        );
        v_new_json := JSON_OBJECT(
            'MaThanhVien'   VALUE :NEW.MaThanhVien,
            'MaDoi'         VALUE :NEW.MaDoi,
            'TenThanhVien'  VALUE :NEW.TenThanhVien,
            'LoaiThanhVien' VALUE :NEW.LoaiThanhVien
        );
        INSERT INTO SPORTS_OWNER.AUDIT_LOG (Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP, TeamCode)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :NEW.MaThanhVien, v_old_json, v_new_json, v_ip, :NEW.MaDoi);

    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_old_json := JSON_OBJECT(
            'MaThanhVien'   VALUE :OLD.MaThanhVien,
            'MaDoi'         VALUE :OLD.MaDoi,
            'TenThanhVien'  VALUE :OLD.TenThanhVien,
            'LoaiThanhVien' VALUE :OLD.LoaiThanhVien
        );
        INSERT INTO SPORTS_OWNER.AUDIT_LOG (Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP, TeamCode)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :OLD.MaThanhVien, v_old_json, NULL, v_ip, :OLD.MaDoi);
    END IF;
END;
/

-- Cập nhật lại Trigger trận đấu để gán TeamCode là 'MATCH'
CREATE OR REPLACE TRIGGER TRG_AUDIT_TRAN_DAU
AFTER UPDATE ON SPORTS_OWNER.TRAN_DAU
FOR EACH ROW
DECLARE
    v_old_json CLOB := NULL;
    v_new_json CLOB := NULL;
    v_user     VARCHAR2(50);
    v_ip       VARCHAR2(100);
BEGIN
    IF :OLD.TySoDoiA <> :NEW.TySoDoiA OR :OLD.TySoDoiB <> :NEW.TySoDoiB OR :OLD.TheVangDoiA <> :NEW.TheVangDoiA OR :OLD.TheVangDoiB <> :NEW.TheVangDoiB OR :OLD.TheDoDoiA <> :NEW.TheDoDoiA OR :OLD.TheDoDoiB <> :NEW.TheDoDoiB OR :OLD.TrangThaiTran <> :NEW.TrangThaiTran OR :OLD.KetQuaStatus <> :NEW.KetQuaStatus THEN

        v_user := NVL(SYS_CONTEXT('SPORT_CTX','USERNAME'), SYS_CONTEXT('USERENV','SESSION_USER'));
        v_ip := SYS_CONTEXT('USERENV','IP_ADDRESS');

        v_old_json := JSON_OBJECT(
            'TySoDoiA' VALUE :OLD.TySoDoiA, 'TySoDoiB' VALUE :OLD.TySoDoiB,
            'TheVangDoiA' VALUE :OLD.TheVangDoiA, 'TheVangDoiB' VALUE :OLD.TheVangDoiB,
            'TheDoDoiA' VALUE :OLD.TheDoDoiA, 'TheDoDoiB' VALUE :OLD.TheDoDoiB,
            'TrangThaiTran' VALUE :OLD.TrangThaiTran, 'KetQuaStatus' VALUE :OLD.KetQuaStatus
        );

        v_new_json := JSON_OBJECT(
            'TySoDoiA' VALUE :NEW.TySoDoiA, 'TySoDoiB' VALUE :NEW.TySoDoiB,
            'TheVangDoiA' VALUE :NEW.TheVangDoiA, 'TheVangDoiB' VALUE :NEW.TheVangDoiB,
            'TheDoDoiA' VALUE :NEW.TheDoDoiA, 'TheDoDoiB' VALUE :NEW.TheDoDoiB,
            'TrangThaiTran' VALUE :NEW.TrangThaiTran, 'KetQuaStatus' VALUE :NEW.KetQuaStatus
        );

        INSERT INTO SPORTS_OWNER.AUDIT_LOG (Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP, TeamCode)
        VALUES (v_user, 'UPDATE', 'TRAN_DAU', :NEW.MaTranDau, v_old_json, v_new_json, v_ip, 'MATCH');
    END IF;
END;
/


-- =========================================================================
-- PHẦN 2: CHỈNH SỬA LOGIC HÀM VPD CHO BẢNG AUDIT_LOG
-- =========================================================================
CONN SEC_ADMIN/SEC_ADMIN;

CREATE OR REPLACE FUNCTION SEC_ADMIN.FN_VPD_AUDIT (
    p_schema VARCHAR2,
    p_object VARCHAR2
) RETURN VARCHAR2 AS
    v_role VARCHAR2(20);
    v_team VARCHAR2(20);
BEGIN
    v_role := SYS_CONTEXT('SPORT_CTX','ROLE');
    v_team := SYS_CONTEXT('SPORT_CTX','TEAM_ID');

    IF v_role = 'ROLE_BTC' THEN
        RETURN '1=1';
    ELSIF v_role = 'ROLE_TD' THEN
        RETURN 'TeamCode='''||v_team||'''';
    ELSE
        RETURN '1=2'; -- ĐÃ FIX: Chặn hiển thị với các Role không có thẩm quyền kiểm toán
    END IF;
END;
/


-- =========================================================================
-- PHẦN 3: TRIỂN KHAI ORACLE LABEL SECURITY (OLS)
-- =========================================================================
CONN LBACSYS/LBACSYS;

BEGIN
    SA_SYSDBA.CREATE_POLICY(
        policy_name => 'SPORT_POLICY',
        column_name => 'OLS_LABEL'
    );
END;
/
EXEC SA_SYSDBA.ENABLE_POLICY('SPORT_POLICY');
GRANT SPORT_POLICY_DBA TO SEC_ADMIN;

-- Chuyển quyền quản trị Policy cho SEC_ADMIN
CONN SEC_ADMIN/SEC_ADMIN;

BEGIN
    -- 1. Levels
    SA_COMPONENTS.CREATE_LEVEL('SPORT_POLICY', 100, 'PUBLIC', 'Public');
    SA_COMPONENTS.CREATE_LEVEL('SPORT_POLICY', 200, 'INTERNAL', 'Internal');
    SA_COMPONENTS.CREATE_LEVEL('SPORT_POLICY', 300, 'CONFIDENTIAL', 'Confidential');
    SA_COMPONENTS.CREATE_LEVEL('SPORT_POLICY', 400, 'SECRET', 'Secret');

    -- 2. Compartments
    SA_COMPONENTS.CREATE_COMPARTMENT('SPORT_POLICY', 10, 'MATCH', 'Match');
    SA_COMPONENTS.CREATE_COMPARTMENT('SPORT_POLICY', 20, 'TEAM', 'Team');
    SA_COMPONENTS.CREATE_COMPARTMENT('SPORT_POLICY', 30, 'MEMBER', 'Member');
    SA_COMPONENTS.CREATE_COMPARTMENT('SPORT_POLICY', 40, 'SECURITY', 'Security');

    -- 3. Groups
    SA_COMPONENTS.CREATE_GROUP('SPORT_POLICY', 1, 'SYSTEM', 'System');
END;
/

-- 4. Tạo Labels (Bổ sung để khớp hoàn toàn với Trigger phân nhãn)
BEGIN
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 1001, 'PUBLIC:MATCH:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 1002, 'PUBLIC:TEAM:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 2001, 'INTERNAL:MATCH:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 2002, 'INTERNAL:TEAM:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 3001, 'CONFIDENTIAL:MEMBER:SYSTEM');
    
    -- ĐÃ FIX: Thêm các nhãn rời rạc để hỗ trợ hàm CHAR_TO_LABEL trong Trigger
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 4001, 'SECRET:MEMBER:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 4002, 'SECRET:SECURITY:SYSTEM');
    SA_LABEL_ADMIN.CREATE_LABEL('SPORT_POLICY', 4003, 'SECRET:MEMBER,SECURITY:SYSTEM');
END;
/

-- 5. Áp dụng Policy lên Bảng
BEGIN
    LBAC_POLICY_ADMIN.APPLY_TABLE_POLICY(
        policy_name   => 'SPORT_POLICY',
        schema_name   => 'SPORTS_OWNER',
        table_name    => 'AUDIT_LOG',
        table_options => 'READ_CONTROL'
    );
END;
/

-- =========================================================================
-- PHẦN 4: TRIGGER DÁN NHÃN ĐỘNG (MAC)
-- =========================================================================
CONN SPORTS_OWNER/CNTT2026!;

CREATE OR REPLACE TRIGGER TRG_AUDIT_LOG_OLS
BEFORE INSERT ON AUDIT_LOG
FOR EACH ROW
BEGIN
    CASE :NEW.ObjectName
        WHEN 'TRAN_DAU' THEN
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'INTERNAL:MATCH:SYSTEM');
        WHEN 'DOI_THI_DAU' THEN
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'INTERNAL:TEAM:SYSTEM');
        WHEN 'PHAN_CONG_TRAN_DAU' THEN
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'INTERNAL:MATCH:SYSTEM');
        WHEN 'THANH_VIEN_DOI' THEN
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'CONFIDENTIAL:MEMBER:SYSTEM');
        WHEN 'USER_INFO' THEN
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'SECRET:MEMBER:SYSTEM');
        ELSE
            :NEW.OLS_LABEL := CHAR_TO_LABEL('SPORT_POLICY', 'SECRET:SECURITY:SYSTEM');
    END CASE;
END;
/


-- =========================================================================
-- PHẦN 5: KHỞI TẠO TÀI KHOẢN APP & CẤP QUYỀN CLEARANCE
-- =========================================================================
CONN SYSTEM/manager;

-- ĐÃ FIX: Tạo vật lý các Proxy User để SA_USER_ADMIN không văng lỗi ORA-01918
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER BTC_APP IDENTIFIED BY "App2026#"';
    EXECUTE IMMEDIATE 'CREATE USER TD_APP IDENTIFIED BY "App2026#"';
    EXECUTE IMMEDIATE 'CREATE USER TT_APP IDENTIFIED BY "App2026#"';
    EXECUTE IMMEDIATE 'CREATE USER GS_APP IDENTIFIED BY "App2026#"';
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO BTC_APP, TD_APP, TT_APP, GS_APP';
EXCEPTION WHEN OTHERS THEN NULL; END; -- Bỏ qua nếu user đã tồn tại
/

CONN SEC_ADMIN/SEC_ADMIN;

-- Gán nhãn cho Ban Tổ Chức
BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'BTC_APP',
        max_read_label  => 'SECRET:MEMBER,SECURITY:SYSTEM',
        max_write_label => 'SECRET:MEMBER,SECURITY:SYSTEM'
    );
END;
/

-- Gán nhãn cho Trưởng đoàn
BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'TD_APP',
        max_read_label  => 'CONFIDENTIAL:MEMBER:SYSTEM',
        max_write_label => 'CONFIDENTIAL:MEMBER:SYSTEM'
    );
END;
/

-- Gán nhãn cho Trọng tài
BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'TT_APP',
        max_read_label  => 'INTERNAL:MATCH:SYSTEM',
        max_write_label => 'INTERNAL:MATCH:SYSTEM'
    );
END;
/

-- Gán nhãn cho Giám sát
BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'GS_APP',
        max_read_label  => 'INTERNAL:TEAM:SYSTEM',
        max_write_label => 'INTERNAL:TEAM:SYSTEM'
    );
END;
/

BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'SEC_ADMIN',
        max_read_label  => 'SECRET:MEMBER,SECURITY:SYSTEM',
        max_write_label => 'SECRET:MEMBER,SECURITY:SYSTEM'
    );
END;
/

BEGIN
    SA_USER_ADMIN.SET_USER_LABELS(
        policy_name     => 'SPORT_POLICY',
        user_name       => 'SPORTS_OWNER',
        max_read_label  => 'SECRET:MEMBER,SECURITY:SYSTEM',
        max_write_label => 'SECRET:MEMBER,SECURITY:SYSTEM'
    );
END;
/


PROMPT OLS MASKING AND CLEARANCE POLICIES CONFIGURED SUCCESSFULLY