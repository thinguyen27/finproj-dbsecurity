SET SERVEROUTPUT ON;
SET ECHO ON;

CONN SPORTS_OWNER/CNTT2026!;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- BAT DAU DON DEP DU LIEU ---');

    -- 1. Bẻ gãy liên kết vòng để tránh lỗi vướng khóa ngoại (ORA-02292)
    UPDATE USER_INFO SET MaDoi = NULL;
    
    -- 2. Xóa các bảng con (Chứa nhiều khóa ngoại)
    DELETE FROM PHAN_CONG_TRAN_DAU;
    DELETE FROM TRAN_DAU;
    DELETE FROM THANH_VIEN_DOI;
    
    -- 3. Xóa các bảng cha (Thực thể gốc)
    DELETE FROM DOI_THI_DAU;
    DELETE FROM USER_INFO;
    DELETE FROM SAN_THI_DAU;
    DELETE FROM GIAI_DAU;
    
    -- 4. Dọn rác trong nhật ký kiểm toán do Trigger sinh ra lúc Delete
    DELETE FROM AUDIT_LOG;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- HOAN TAT XOA SACH DU LIEU MAU ---');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Loi xay ra: ' || SQLERRM);
END;
/