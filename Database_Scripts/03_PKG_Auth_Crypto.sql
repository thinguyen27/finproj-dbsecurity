conn SEC_ADMIN/"SEC_ADMIN";
-- 1. Khởi tạo Package Specification
CREATE OR REPLACE PACKAGE SEC_ADMIN.PKG_CRYPTO_UTILS AS
    -- Hàm băm mật khẩu
    FUNCTION HASH_PASSWORD(p_plain_text IN VARCHAR2) RETURN VARCHAR2;
    -- Hàm xác thực đăng nhập
    FUNCTION VERIFY_PASSWORD(p_plain_text IN VARCHAR2, p_hashed_text IN VARCHAR2) RETURN BOOLEAN;
END PKG_CRYPTO_UTILS;
/

-- 2. Triển khai nội dung Package (Package Body)
CREATE OR REPLACE PACKAGE BODY SEC_ADMIN.PKG_CRYPTO_UTILS AS

    -- Hàm thực hiện băm mật khẩu bằng thuật toán SHA-256
    FUNCTION HASH_PASSWORD(p_plain_text IN VARCHAR2) RETURN VARCHAR2 IS
        v_raw_input RAW(128);
        v_hashed_raw RAW(128);
    BEGIN
        -- Bỏ qua nếu giá trị rỗng
        IF p_plain_text IS NULL THEN
            RETURN NULL;
        END IF;

        -- Chuyển chuỗi đầu vào sang định dạng RAW (bắt buộc đối với DBMS_CRYPTO)
        v_raw_input := UTL_I18N.STRING_TO_RAW(p_plain_text, 'AL32UTF8');
        
        -- Thực thi băm SHA-256 bằng hàm HASH của DBMS_CRYPTO
        v_hashed_raw := DBMS_CRYPTO.HASH(
            src => v_raw_input, 
            typ => DBMS_CRYPTO.HASH_SH256
        );
        
        -- Chuyển đổi chuỗi RAW đã băm thành định dạng HEX để dễ lưu trữ dưới DB
        RETURN RAWTOHEX(v_hashed_raw);
    END HASH_PASSWORD;

    -- Hàm so sánh mật khẩu lúc người dùng đăng nhập
    FUNCTION VERIFY_PASSWORD(p_plain_text IN VARCHAR2, p_hashed_text IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Băm mật khẩu người dùng vừa nhập và so khớp với mã băm trong CSDL
        IF HASH_PASSWORD(p_plain_text) = p_hashed_text THEN
            RETURN TRUE;  -- Đăng nhập thành công
        ELSE
            RETURN FALSE; -- Sai mật khẩu
        END IF;
    END VERIFY_PASSWORD;

END PKG_CRYPTO_UTILS;
/

-- ==========================================
-- PHÂN QUYỀN SỬ DỤNG PACKAGE
-- (Chạy bằng tài khoản SEC_ADMIN)
-- Cấp quyền cho Role_BTC để ứng dụng Web có thể gọi hàm băm khi tạo User
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO Role_BTC;
-- Cấp quyền cho SPORTS_OWNER để thao tác kiểm tra nếu cần
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO SPORTS_OWNER;