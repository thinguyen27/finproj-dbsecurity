SET SERVEROUTPUT ON;
SET ECHO ON;

-- Phần 1: Cấu hình kiểm toán hệ thống (System Audit) và kiểm toán thao tác dữ liệu nghiệp vụ (DML Audit)
-- Kết nối bằng tài khoản quản trị an ninh
CONN SEC_ADMIN/SEC_ADMIN;

-- Xóa các policy cũ (nếu có) để làm sạch môi trường trước khi khởi tạo lại
BEGIN
    EXECUTE IMMEDIATE 'NOAUDIT POLICY AUDIT_SYS_SPORTS';
    EXECUTE IMMEDIATE 'DROP AUDIT POLICY AUDIT_SYS_SPORTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'NOAUDIT POLICY AUDIT_DML_SPORTS';
    EXECUTE IMMEDIATE 'DROP AUDIT POLICY AUDIT_DML_SPORTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- 1.1 Tạo Policy kiểm toán các thao tác quản trị hệ thống (System Audit)
-- Ghi nhận các lệnh: CREATE/ALTER/DROP USER, CREATE/ALTER/DROP ROLE, GRANT, REVOKE
CREATE AUDIT POLICY AUDIT_SYS_SPORTS 
PRIVILEGES CREATE USER, ALTER USER, DROP USER, 
           CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE,
           GRANT ANY ROLE, GRANT ANY PRIVILEGE;
-- Kích hoạt Policy
AUDIT POLICY AUDIT_SYS_SPORTS;         

-- 1.2 Tạo Policy kiểm toán thao tác dữ liệu nghiệp vụ (DML Audit)
-- Ghi nhận thao tác INSERT, UPDATE, DELETE trên bảng nhân sự và UPDATE trên bảng trận đấu
CREATE AUDIT POLICY AUDIT_DML_SPORTS 
ACTIONS INSERT ON SPORTS_OWNER.THANH_VIEN_DOI, 
        UPDATE ON SPORTS_OWNER.THANH_VIEN_DOI, 
        DELETE ON SPORTS_OWNER.THANH_VIEN_DOI, 
        UPDATE ON SPORTS_OWNER.TRAN_DAU;

-- 1.3 Kích hoạt các Policy để hệ thống bắt đầu giám sát
AUDIT POLICY AUDIT_SYS_SPORTS;
AUDIT POLICY AUDIT_DML_SPORTS;

--Phần 2: Cấu hình kiểm toán dữ liệu nghiệp vụ (DML Audit) bằng Trigger
'''Kết nối vào schema chủ sở hữu dữ liệu giải đấu'''
CONN SPORTS_OWNER/CNTT2026!;

-- 2.1 Trigger giám sát biến động dữ liệu nhân sự (Bảng THANH_VIEN_DOI)
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
    -- Ưu tiên lấy Username từ Context VPD, nếu không có thì lấy Session User của DB
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
        INSERT INTO SPORTS_OWNER.AUDIT_LOG(Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :NEW.MaThanhVien, NULL, v_new_json, v_ip);
        
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
        INSERT INTO SPORTS_OWNER.AUDIT_LOG(Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :NEW.MaThanhVien, v_old_json, v_new_json, v_ip);
        
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_old_json := JSON_OBJECT(
            'MaThanhVien'   VALUE :OLD.MaThanhVien,
            'MaDoi'         VALUE :OLD.MaDoi,
            'TenThanhVien'  VALUE :OLD.TenThanhVien,
            'LoaiThanhVien' VALUE :OLD.LoaiThanhVien
        );
        INSERT INTO SPORTS_OWNER.AUDIT_LOG(Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP)
        VALUES (v_user, v_action, 'THANH_VIEN_DOI', :OLD.MaThanhVien, v_old_json, NULL, v_ip);
    END IF;
END;
/

-- 2.2 Trigger giám sát cập nhật kết quả và diễn biến trận đấu (Bảng TRAN_DAU)
CREATE OR REPLACE TRIGGER TRG_AUDIT_TRAN_DAU
AFTER UPDATE ON SPORTS_OWNER.TRAN_DAU
FOR EACH ROW
DECLARE
    v_old_json CLOB := NULL;
    v_new_json CLOB := NULL;
    v_user     VARCHAR2(50);
    v_ip       VARCHAR2(100);
BEGIN
    -- Chỉ ghi nhận kiểm toán khi có sự thay đổi thực sự về mặt chuyên môn (tỷ số, thẻ phạt, trạng thái)
    IF :OLD.TySoDoiA <> :NEW.TySoDoiA OR :OLD.TySoDoiB <> :NEW.TySoDoiB OR
       :OLD.TheVangDoiA <> :NEW.TheVangDoiA OR :OLD.TheVangDoiB <> :NEW.TheVangDoiB OR
       :OLD.TheDoDoiA <> :NEW.TheDoDoiA OR :OLD.TheDoDoiB <> :NEW.TheDoDoiB OR
       :OLD.TrangThaiTran <> :NEW.TrangThaiTran OR :OLD.KetQuaStatus <> :NEW.KetQuaStatus THEN
       
        v_user := NVL(SYS_CONTEXT('SPORT_CTX', 'USERNAME'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
        v_ip   := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        
        v_old_json := JSON_OBJECT(
            'TySoDoiA'      VALUE :OLD.TySoDoiA,      'TySoDoiB'      VALUE :OLD.TySoDoiB,
            'TheVangDoiA'   VALUE :OLD.TheVangDoiA,   'TheVangDoiB'   VALUE :OLD.TheVangDoiB,
            'TheDoDoiA'     VALUE :OLD.TheDoDoiA,     'TheDoDoiB'     VALUE :OLD.TheDoDoiB,
            'TrangThaiTran' VALUE :OLD.TrangThaiTran, 'KetQuaStatus'  VALUE :OLD.KetQuaStatus
        );
        
        v_new_json := JSON_OBJECT(
            'TySoDoiA'      VALUE :NEW.TySoDoiA,      'TySoDoiB'      VALUE :NEW.TySoDoiB,
            'TheVangDoiA'   VALUE :NEW.TheVangDoiA,   'TheVangDoiB'   VALUE :NEW.TheVangDoiB,
            'TheDoDoiA'     VALUE :NEW.TheDoDoiA,     'TheDoDoiB'     VALUE :NEW.TheDoDoiB,
            'TrangThaiTran' VALUE :NEW.TrangThaiTran, 'KetQuaStatus'  VALUE :NEW.KetQuaStatus
        );
        
        INSERT INTO SPORTS_OWNER.AUDIT_LOG(Username, ActionType, ObjectName, RecordID, OldValue, NewValue, ClientIP)
        VALUES (v_user, 'UPDATE', 'TRAN_DAU', :NEW.MaTranDau, v_old_json, v_new_json, v_ip);
    END IF;
END;
/

