-- XÓA OLS POLICY CŨ (nếu tồn tại)
BEGIN
    SA_POLICY_ADMIN.REMOVE_TABLE_POLICY(
        policy_name => 'SPORT_POLICY',
        schema_name => 'SPORTS_OWNER',
        table_name  => 'THANH_VIEN_DOI'
    );
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    SA_SYSDBA.DROP_POLICY('SPORT_POLICY');
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- XÓA REDACTION POLICY CŨ (nếu tồn tại)
BEGIN
    DBMS_REDACT.DROP_POLICY(
        object_schema => 'SPORTS_OWNER',
        object_name   => 'THANH_VIEN_DOI',
        policy_name   => 'REDACT_MEMBER'
    );
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Tạo policy cho OLS
BEGIN
    SA_SYSDBA.CREATE_POLICY(
        policy_name => 'SPORT_POLICY',
        column_name => 'OLS_LABEL'
    );
END;
/
-- Tạo Security Levels
BEGIN

SA_COMPONENTS.CREATE_LEVEL(
'SPORT_POLICY',
100,
'PUBLIC',
'Cong khai'
);

SA_COMPONENTS.CREATE_LEVEL(
'SPORT_POLICY',
200,
'INTERNAL',
'Noi bo'
);

SA_COMPONENTS.CREATE_LEVEL(
'SPORT_POLICY',
300,
'CONFIDENTIAL',
'Nhay cam'
);

SA_COMPONENTS.CREATE_LEVEL(
'SPORT_POLICY',
400,
'SECRET',
'Tuyet mat'
);

END;
/

-- Ta không tạo Compartments vì nó sẽ dư và xung đột với VPD
-- Tạo group 
BEGIN

SA_COMPONENTS.CREATE_GROUP(
'SPORT_POLICY',
1,
'BTC',
'Ban To Chuc'
);

SA_COMPONENTS.CREATE_GROUP(
'SPORT_POLICY',
2,
'TD',
'Truong Doan'
);

SA_COMPONENTS.CREATE_GROUP(
'SPORT_POLICY',
3,
'TT',
'Trong Tai'
);

SA_COMPONENTS.CREATE_GROUP(
'SPORT_POLICY',
4,
'GS',
'Giam Sat'
);

END;
/


-- 5. Labels
-- BTC
BEGIN
SA_LABEL_ADMIN.CREATE_LABEL(
'SPORT_POLICY',
4001,
'SECRET::BTC'
);
END;
/

-- Trưởng đoàn
BEGIN
SA_LABEL_ADMIN.CREATE_LABEL(
'SPORT_POLICY',
3001,
'CONFIDENTIAL::TD'
);
END;
/


-- Trọng tài
BEGIN
SA_LABEL_ADMIN.CREATE_LABEL(
'SPORT_POLICY',
2001,
'INTERNAL::TT'
);
END;
/


-- GS
BEGIN
SA_LABEL_ADMIN.CREATE_LABEL(
'SPORT_POLICY',
1001,
'PUBLIC::GS'
);
END;
/


-- 6. Áp policy vào bảng VAN_DONG_VIEN

BEGIN

SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
    policy_name  => 'SPORT_POLICY',
    schema_name  => 'SPORTS_OWNER',
    table_name   => 'THANH_VIEN_DOI',
    table_options=>'READ_CONTROL,WRITE_CONTROL'
);

END;
/

-- Toàn bộ dữ liệu thành viên sẽ mang nhãn: CONFIDENTIAL::TD và VPD mới là thứ quyết định ai được xem đội nào.
UPDATE SPORTS_OWNER.THANH_VIEN_DOI
SET OLS_LABEL =
    CHAR_TO_LABEL(
        'SPORT_POLICY',
        'CONFIDENTIAL::TD'
    );

COMMIT;

-- 8. Gán clearance cho user
-- Cho SPORTS_OWNER
BEGIN

SA_USER_ADMIN.SET_USER_LABELS(
policy_name=>'SPORT_POLICY',
user_name=>'SPORTS_OWNER',
max_read_label=>'SECRET::BTC',
max_write_label=>'SECRET::BTC'
);

END;
/

-- Gán clearance cho BTC
BEGIN

SA_USER_ADMIN.SET_USER_LABELS(
    policy_name     => 'SPORT_POLICY',
    user_name       => 'BTC_APP',
    max_read_label  => 'SECRET::BTC',
    max_write_label => 'SECRET::BTC'
);

END;
/

-- Trưởng đoàn
BEGIN

SA_USER_ADMIN.SET_USER_LABELS(
    policy_name     => 'SPORT_POLICY',
    user_name       => 'TD_APP',
    max_read_label  => 'CONFIDENTIAL::TD',
    max_write_label => 'CONFIDENTIAL::TD'
);

END;
/


--  Trọng tài
BEGIN

SA_USER_ADMIN.SET_USER_LABELS(
    policy_name     => 'SPORT_POLICY',
    user_name       => 'TT_APP',
    max_read_label  => 'INTERNAL::TT',
    max_write_label => 'INTERNAL::TT'
);

END;
/

-- GS
BEGIN

SA_USER_ADMIN.SET_USER_LABELS(
    policy_name     => 'SPORT_POLICY',
    user_name       => 'GS_APP',
    max_read_label  => 'PUBLIC::GS',
    max_write_label => 'PUBLIC::GS'
);

END;
/


-- PHẦN II : DATA REDACTION
-- 1. CCCD
BEGIN

DBMS_REDACT.ADD_POLICY(
    object_schema => 'SPORTS_OWNER',
    object_name   => 'THANH_VIEN_DOI',
    column_name   => 'CCCD',

    policy_name   => 'REDACT_MEMBER',

    function_type => DBMS_REDACT.FULL,

    expression =>
    q'[
       SYS_CONTEXT('SPORT_CTX','ROLE')
       IN ('ROLE_GS','ROLE_TT')
    ]'
);

END;
/

-- SDT
BEGIN

DBMS_REDACT.ALTER_POLICY(
    object_schema       => 'SPORTS_OWNER',
    object_name         => 'THANH_VIEN_DOI',
    policy_name         => 'REDACT_MEMBER',

    action              => DBMS_REDACT.ADD_COLUMN,

    column_name         => 'SoDienThoai',

    function_type       => DBMS_REDACT.PARTIAL,

    function_parameters => 'VVVVVV,VVVV,*,4'
);

END;
/


-- Email
BEGIN

DBMS_REDACT.ALTER_POLICY(
    object_schema => 'SPORTS_OWNER',
    object_name   => 'THANH_VIEN_DOI',
    policy_name   => 'REDACT_MEMBER',

    action        => DBMS_REDACT.ADD_COLUMN,

    column_name   => 'EmailThanhVien',

    function_type => DBMS_REDACT.FULL
);

END;
/

-- Thông tin sức khỏe
BEGIN

DBMS_REDACT.ALTER_POLICY(
    object_schema => 'SPORTS_OWNER',
    object_name   => 'THANH_VIEN_DOI',
    policy_name   => 'REDACT_MEMBER',

    action        => DBMS_REDACT.ADD_COLUMN,

    column_name   => 'ThongTinSucKhoe',

    function_type => DBMS_REDACT.FULL
);

END;
/

-- Tạo trigger để gán nhãn OLS cho các bản ghi mới được thêm vào bảng THANH_VIEN_DOI
CREATE OR REPLACE TRIGGER TRG_MEMBER_LABEL
BEFORE INSERT ON SPORTS_OWNER.THANH_VIEN_DOI
FOR EACH ROW
BEGIN
    IF :NEW.OLS_LABEL IS NULL THEN
        :NEW.OLS_LABEL :=
        CHAR_TO_LABEL(
            'SPORT_POLICY',
            'CONFIDENTIAL::TD'
        );
    END IF;
END;
/

