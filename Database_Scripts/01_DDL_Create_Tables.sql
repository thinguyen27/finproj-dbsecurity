-- 1. BẢNG THÔNG TIN NGƯỜI DÙNG
-- Kết nối trực tiếp với DBA_USERS của Oracle thông qua cột Username
CREATE TABLE USER_INFO (
    Username VARCHAR2(50) PRIMARY KEY,
    HoTen VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100),
    SoDienThoai VARCHAR2(15),
    Password_Hash VARCHAR2(256)
);

-- 2. BẢNG ĐỘI THI ĐẤU
-- Đóng vai trò là Compartment trong Oracle Label Security (OLS)
CREATE TABLE DOI_THI_DAU (
    MaDoi VARCHAR2(20) PRIMARY KEY,
    TenDoi VARCHAR2(100) NOT NULL,
    TruongDoan_Username VARCHAR2(50) NOT NULL,
    NgayThanhLap DATE,
    CONSTRAINT FK_Doi_User FOREIGN KEY (TruongDoan_Username) REFERENCES USER_INFO(Username)
);

-- 3. BẢNG VẬN ĐỘNG VIÊN
-- Bảng trọng tâm áp dụng Data Masking và VPD cho Trưởng đoàn
CREATE TABLE VAN_DONG_VIEN (
    MaVDV VARCHAR2(20) PRIMARY KEY,
    TenVDV VARCHAR2(100) NOT NULL,
    MaDoi VARCHAR2(20) NOT NULL,
    NgaySinh DATE,
    GioiTinh VARCHAR2(10),
    CCCD VARCHAR2(20),             -- Target cho DBMS_REDACT
    SDoan VARCHAR2(15),            -- Target cho DBMS_REDACT
    Email_VDV VARCHAR2(100),       -- Target cho DBMS_REDACT
    ThongTinSucKhoe VARCHAR2(255), -- Target cho DBMS_REDACT
    
    CONSTRAINT FK_VDV_Doi FOREIGN KEY (MaDoi) REFERENCES DOI_THI_DAU(MaDoi)
);

-- 4. BẢNG LỊCH THI ĐẤU
-- Phân luồng giới hạn quyền cập nhật cho Trọng tài
CREATE TABLE LICH_THI_DAU (
    MaTranDau VARCHAR2(20) PRIMARY KEY,
    MaDoiA VARCHAR2(20) NOT NULL,
    MaDoiB VARCHAR2(20) NOT NULL,
    NgayGioThiDau TIMESTAMP NOT NULL,
    DiaDiem VARCHAR2(100),
    TrongTai_Username VARCHAR2(50) NOT NULL,
    CONSTRAINT CHK_HaiDoiKhacNhau CHECK (MaDoiA <> MaDoiB),
    CONSTRAINT FK_LTD_DoiA FOREIGN KEY (MaDoiA) REFERENCES DOI_THI_DAU(MaDoi),
    CONSTRAINT FK_LTD_DoiB FOREIGN KEY (MaDoiB) REFERENCES DOI_THI_DAU(MaDoi),
    CONSTRAINT FK_LTD_TrongTai FOREIGN KEY (TrongTai_Username) REFERENCES USER_INFO(Username)
);

-- 5. BẢNG KẾT QUẢ TRẬN ĐẤU
-- Bảng trọng tâm áp dụng Audit và giới hạn quyền Update mức cột
CREATE TABLE KET_QUA_TRAN_DAU (
    MaTranDau VARCHAR2(20) PRIMARY KEY,
    TySoDoiA NUMBER DEFAULT 0,
    TySoDoiB NUMBER DEFAULT 0,
    ThePhatDoiA NUMBER DEFAULT 0,
    ThePhatDoiB NUMBER DEFAULT 0,
    TrangThai VARCHAR2(20) DEFAULT 'PENDING', 
    
    CONSTRAINT FK_KetQua_TranDau FOREIGN KEY (MaTranDau) REFERENCES LICH_THI_DAU(MaTranDau),
    CONSTRAINT CHK_TrangThai CHECK (TrangThai IN ('PENDING', 'PLAYING', 'FINAL'))
);