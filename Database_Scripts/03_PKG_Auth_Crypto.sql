SET SERVEROUTPUT ON;
SET ECHO ON;

-- Kết nối bằng tài khoản quản trị an ninh mật mã
CONN SEC_ADMIN/SEC_ADMIN;

-- Khởi tạo Đặc tả Package (Package Specification) quản trị mật mã và luồng đăng nhập hệ thống
CREATE OR REPLACE PACKAGE SEC_ADMIN.PKG_CRYPTO_UTILS
AUTHID DEFINER -- Thực thi bằng quyền của SEC_ADMIN để bảo vệ cấu trúc truy cập dữ liệu bảng hệ thống
AS
    -- Hàm băm mật khẩu bảo mật một chiều kết hợp kỹ thuật Salt
    FUNCTION HASH_PASSWORD(
        p_plain_text IN VARCHAR2
    )
    RETURN VARCHAR2;

    -- Thủ tục xử lý xác thực đăng nhập tích hợp đồng bộ nạp vùng nhớ đệm Context cho VPD
    PROCEDURE LOGIN_USER(
        p_username   IN  VARCHAR2,
        p_password   IN  VARCHAR2,
        p_status     OUT VARCHAR2, -- 'SUCCESS', 'WRONG_PASSWORD', 'ACCOUNT_LOCKED', 'DELETED', 'SYSTEM_ERROR'
        p_role       OUT VARCHAR2,
        p_team_id    OUT VARCHAR2
    );
END PKG_CRYPTO_UTILS;
/

-- Triển khai nội dung thực thi chi tiết bên trong Package (Package Body)
CREATE OR REPLACE PACKAGE BODY SEC_ADMIN.PKG_CRYPTO_UTILS
AS
    -- Hàm thực hiện băm mật khẩu bằng thuật toán SHA-256 kết hợp chuỗi Muối (Salt)
    FUNCTION HASH_PASSWORD(
        p_plain_text IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
        v_raw_input  RAW(128);
        v_hashed_raw RAW(128);
        -- Chuỗi Salt tĩnh nâng cao tính chống chịu trước các cuộc tấn công Rainbow Table
        c_salt CONSTANT VARCHAR2(50) := '#SPORTS_SECURITY_2026';
    BEGIN
        IF p_plain_text IS NULL THEN
            RETURN NULL;
        END IF;

        -- Ghép chuỗi mật khẩu rõ với chuỗi muối và chuyển đổi sang định dạng RAW đáp ứng DBMS_CRYPTO
        v_raw_input := UTL_I18N.STRING_TO_RAW(p_plain_text || c_salt, 'AL32UTF8');

        -- Thực hiện băm mật khẩu bảo mật theo tiêu chuẩn SHA-256
        v_hashed_raw := DBMS_CRYPTO.HASH(
            src => v_raw_input,
            typ => DBMS_CRYPTO.HASH_SH256
        );

        -- Chuyển đổi chuỗi RAW đã băm sang định dạng chuỗi HEX viết hoa để dễ dàng lưu trữ
        RETURN RAWTOHEX(v_hashed_raw);
    END HASH_PASSWORD;

    -- Thủ tục kiểm tra thông tin tài khoản và nạp Ngữ cảnh an toàn (Context)
    PROCEDURE LOGIN_USER(
        p_username   IN  VARCHAR2,
        p_password   IN  VARCHAR2,
        p_status     OUT VARCHAR2,
        p_role       OUT VARCHAR2,
        p_team_id    OUT VARCHAR2
    )
    IS
        v_stored_hash VARCHAR2(500);
        v_trang_thai  VARCHAR2(20);
        v_is_deleted  CHAR(1);
        v_input_hash  VARCHAR2(500);
    BEGIN
        -- Khởi tạo trạng thái mặc định ban đầu là từ chối xác thực
        p_status  := 'WRONG_PASSWORD';
        p_role    := NULL;
        p_team_id := NULL;

        -- Truy xuất thông tin tài khoản từ schema nghiệp vụ dữ liệu giải đấu
        BEGIN
            SELECT Password_Hash, VaiTro, TrangThai, MaDoi, IsDeleted
            INTO v_stored_hash, p_role, v_trang_thai, p_team_id, v_is_deleted
            FROM SPORTS_OWNER.USER_INFO
            WHERE UPPER(Username) = UPPER(p_username);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_status := 'WRONG_PASSWORD'; -- Thông báo chung để chống khai thác lỗ hổng dò tìm Username
                RETURN;
            WHEN TOO_MANY_ROWS THEN
                p_status := 'SYSTEM_ERROR'; -- Xử lý lỗi ngoại lệ nếu dữ liệu tài khoản bị trùng lặp hệ thống
                RETURN;
        END;

        -- Kiểm tra trạng thái xóa mềm (Soft Delete) của tài khoản người dùng
        IF v_is_deleted = 'Y' THEN
            p_status := 'DELETED';
            RETURN;
        END IF;

        -- Kiểm tra trạng thái khóa hành chính của tài khoản
        IF v_trang_thai = 'LOCKED' THEN
            p_status := 'ACCOUNT_LOCKED';
            RETURN;
        END IF;

        -- Thực hiện băm chuỗi mật khẩu người dùng nhập vào kèm chuỗi muối đối soát
        v_input_hash := HASH_PASSWORD(p_password);

        -- Nếu kết quả so khớp chuỗi băm hoàn toàn trùng khớp
        IF v_input_hash = v_stored_hash THEN
            p_status := 'SUCCESS';

            -- Đảm bảo ngay khi xác thực thành công mức Database Session, Context sẽ được nạp thông số tự động
            BEGIN
                SEC_ADMIN.PKG_SPORT_CONTEXT.INITIALIZE_SESSION(
                    p_username,
                    p_role,
                    p_team_id
                );
            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'SYSTEM_ERROR';
                    RETURN;
            END;
        ELSE
            p_status := 'WRONG_PASSWORD';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            -- Chặn đứng toàn bộ rò rỉ mã lỗi vết hệ thống ra bên ngoài tệp giao diện Web
            p_status  := 'SYSTEM_ERROR';
            p_role    := NULL;
            p_team_id := NULL;
    END LOGIN_USER;

END PKG_CRYPTO_UTILS;
/

-- Cấp quyền thực thi Package bảo mật cho Ban Tổ Chức (Role_BTC) để gọi băm mật khẩu khi thêm mới User từ Web UI
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO Role_BTC;

-- Cấp quyền thực thi cho SPORTS_OWNER và các nhóm vai trò nghiệp vụ khác để kết nối luồng xác thực đăng nhập
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO SPORTS_OWNER;
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO Role_TD;
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO Role_TT;
GRANT EXECUTE ON SEC_ADMIN.PKG_CRYPTO_UTILS TO Role_GS;

PROMPT CRYPTO AND AUTHENTICATION PACKAGE CONFIGURED SUCCESSFULLY