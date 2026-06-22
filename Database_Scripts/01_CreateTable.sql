SET SERVEROUTPUT ON;
SET ECHO ON;

-- Kết nối trực tiếp vào schema chủ sở hữu dữ liệu giải đấu
CONN SPORTS_OWNER/CNTT2026!;

-- Sử dụng PL/SQL động quét qua từ điển dữ liệu để tự động xóa sạch các bảng cũ theo đúng thứ tự ràng buộc
BEGIN
    FOR t IN (
        SELECT table_name
        FROM user_tables
        WHERE table_name IN (
            'AUDIT_LOG',
            'PHAN_CONG_TRAN_DAU',
            'TRAN_DAU',
            'SAN_THI_DAU',
            'THANH_VIEN_DOI',
            'DOI_THI_DAU',
            'GIAI_DAU',
            'USER_INFO'
        )
    )
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Bảng USER_INFO: Lưu trữ thông tin tài khoản đăng nhập, cấu hình vai trò phục vụ phân quyền RBAC và mã đội phục vụ VPD Context cách ly dữ liệu
CREATE TABLE USER_INFO (
    Username        VARCHAR2(50) PRIMARY KEY,
    HoTen           NVARCHAR2(100) NOT NULL,
    Email           VARCHAR2(100),
    SoDienThoai     VARCHAR2(15),
    Password_Hash   VARCHAR2(500) NOT NULL,
    VaiTro          VARCHAR2(20) NOT NULL,
    TrangThai       VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    MaDoi           VARCHAR2(20),
    IsDeleted       CHAR(1) DEFAULT 'N' NOT NULL,
    
    CONSTRAINT UK_USER_EMAIL    UNIQUE (Email),
    CONSTRAINT CHK_USER_ROLE    CHECK (VaiTro IN ('Role_BTC','Role_TD','Role_TT','Role_GS')),
    CONSTRAINT CHK_USER_STATUS  CHECK (TrangThai IN ('ACTIVE','LOCKED')),
    CONSTRAINT CHK_USER_DELETE  CHECK (IsDeleted IN ('Y','N'))
);

-- Bảng GIAI_DAU: Quản lý vòng đời tổ chức, thời gian và trạng thái hiện tại của các giải đấu thể thao trong hệ thống
CREATE TABLE GIAI_DAU (
    MaGiai          VARCHAR2(20) PRIMARY KEY,
    TenGiai         NVARCHAR2(200) NOT NULL,
    NamToChuc       NUMBER(4) NOT NULL,
    NgayBatDau      DATE NOT NULL,
    NgayKetThuc     DATE,
    TrangThai       VARCHAR2(20) DEFAULT 'REGISTRATION' NOT NULL,
    IsDeleted       CHAR(1) DEFAULT 'N' NOT NULL,
    
    CONSTRAINT CHK_GIAI_STATUS  CHECK (TrangThai IN ('REGISTRATION','PLAYING','FINISHED')),
    CONSTRAINT CHK_GIAI_DELETE  CHECK (IsDeleted IN ('Y','N'))
);

-- Bảng SAN_THI_DAU: Danh mục thông tin các sân vận động, địa chỉ và sức chứa phục vụ công tác xếp lịch thi đấu trận đấu chuyên nghiệp
CREATE TABLE SAN_THI_DAU (
    MaSan           VARCHAR2(20) PRIMARY KEY,
    TenSan          NVARCHAR2(100) NOT NULL,
    DiaChi          NVARCHAR2(200),
    SucChua         NUMBER(10),
    MoTa            NVARCHAR2(500)
);

-- Bảng DOI_THI_DAU: Quản lý các câu lạc bộ tham gia, đóng vai trò ranh giới cô lập dữ liệu (VPD Boundary) và miền biệt lập cho OLS Compartment
CREATE TABLE DOI_THI_DAU (
    MaDoi               VARCHAR2(20) PRIMARY KEY,
    MaGiai              VARCHAR2(20) NOT NULL,
    TenDoi              NVARCHAR2(100) NOT NULL,
    TruongDoan_Username VARCHAR2(50) NOT NULL,
    SanNha              NVARCHAR2(100),
    NgayThanhLap        DATE,
    IsDeleted           CHAR(1) DEFAULT 'N' NOT NULL,
    
    CONSTRAINT FK_DOI_GIAI        FOREIGN KEY (MaGiai) REFERENCES GIAI_DAU(MaGiai),
    CONSTRAINT FK_DOI_TRUONGDOAN  FOREIGN KEY (TruongDoan_Username) REFERENCES USER_INFO(Username),
    CONSTRAINT UK_DOI_GIAI_TEN    UNIQUE (MaGiai, TenDoi),
    CONSTRAINT CHK_DOI_DELETE     CHECK (IsDeleted IN ('Y','N'))
);

-- Thiết lập liên kết khóa ngoại an toàn từ tài khoản người dùng sang bảng đội bóng sau khi thực thể đội bóng được khởi tạo thành công
ALTER TABLE USER_INFO ADD CONSTRAINT FK_USER_DOI 
    FOREIGN KEY (MaDoi) REFERENCES DOI_THI_DAU(MaDoi);

-- Bảng THANH_VIEN_DOI: Lưu thông tin chi tiết nhân sự của đội (Cầu thủ, HLV, Y tế), là mục tiêu cốt lõi áp dụng chính sách VPD, Masking và cột nhãn OLS
CREATE TABLE THANH_VIEN_DOI (
    MaThanhVien         VARCHAR2(20) PRIMARY KEY,
    MaDoi               VARCHAR2(20) NOT NULL,
    TenThanhVien        NVARCHAR2(100) NOT NULL,
    LoaiThanhVien       VARCHAR2(20) NOT NULL,
    NgaySinh            DATE,
    GioiTinh            NVARCHAR2(10),
    SoAo                NUMBER(2),
    CCCD                VARCHAR2(20),   
    SoDienThoai         VARCHAR2(15),   
    EmailThanhVien      VARCHAR2(100),  
    ThongTinSucKhoe     NVARCHAR2(500), 
    OLS_LABEL           NUMBER(10),         
    IsDeleted           CHAR(1) DEFAULT 'N' NOT NULL,
    
    CONSTRAINT CHK_LOAI_THANHVIEN CHECK (LoaiThanhVien IN ('CAU_THU','HLV_TRUONG','HLV_PHO','BAC_SI')),
    CONSTRAINT FK_THANHVIEN_DOI   FOREIGN KEY (MaDoi) REFERENCES DOI_THI_DAU(MaDoi),
    CONSTRAINT CHK_THANHVIEN_DEL  CHECK (IsDeleted IN ('Y','N')),
    CONSTRAINT UK_DOI_SOAO        UNIQUE (MaDoi, SoAo)
);

-- Bảng TRAN_DAU: Quản lý lịch thi đấu, tích hợp kết quả tỷ số, thẻ phạt và luồng phê duyệt chuyên môn phục vụ lớp ABAC nâng cao và phân quyền mức cột
CREATE TABLE TRAN_DAU (
    MaTranDau           VARCHAR2(20) PRIMARY KEY,
    MaGiai              VARCHAR2(20) NOT NULL,
    MaDoiA              VARCHAR2(20) NOT NULL,
    MaDoiB              VARCHAR2(20) NOT NULL,
    VongDau             NUMBER(2),
    NgayGioThiDau       TIMESTAMP NOT NULL,
    MaSan               VARCHAR2(20),
    TySoDoiA            NUMBER(2) DEFAULT 0,
    TySoDoiB            NUMBER(2) DEFAULT 0,
    TheVangDoiA         NUMBER(2) DEFAULT 0,
    TheVangDoiB         NUMBER(2) DEFAULT 0,
    TheDoDoiA           NUMBER(2) DEFAULT 0,
    TheDoDoiB           NUMBER(2) DEFAULT 0,
    TrangThaiTran       VARCHAR2(20) DEFAULT 'PENDING' NOT NULL,
    KetQuaStatus        VARCHAR2(20) DEFAULT 'PENDING' NOT NULL,
    NguoiDuyetKetQua    VARCHAR2(50),
    NgayDuyetKetQua     TIMESTAMP,
    IsDeleted           CHAR(1) DEFAULT 'N' NOT NULL,
    
    CONSTRAINT FK_TRAN_GIAI       FOREIGN KEY (MaGiai) REFERENCES GIAI_DAU(MaGiai),
    CONSTRAINT FK_TRAN_DOIA       FOREIGN KEY (MaDoiA) REFERENCES DOI_THI_DAU(MaDoi),
    CONSTRAINT FK_TRAN_DOIB       FOREIGN KEY (MaDoiB) REFERENCES DOI_THI_DAU(MaDoi),
    CONSTRAINT FK_TRAN_SAN        FOREIGN KEY (MaSan) REFERENCES SAN_THI_DAU(MaSan),
    CONSTRAINT FK_TRAN_GIAMSAT    FOREIGN KEY (NguoiDuyetKetQua) REFERENCES USER_INFO(Username),
    CONSTRAINT CHK_DOI_KHAC_NHAU  CHECK (MaDoiA <> MaDoiB),
    CONSTRAINT CHK_TRAN_STATUS    CHECK (TrangThaiTran IN ('PENDING','PLAYING','FINISHED')),
    CONSTRAINT CHK_KETQUA_STATUS  CHECK (KetQuaStatus IN ('PENDING','FINAL')),
    CONSTRAINT CHK_TRAN_DELETE    CHECK (IsDeleted IN ('Y','N')),
    CONSTRAINT CHK_TYSO_A         CHECK (TySoDoiA >= 0),
    CONSTRAINT CHK_TYSO_B         CHECK (TySoDoiB >= 0),
    CONSTRAINT CHK_THEVANG_A      CHECK (TheVangDoiA >= 0),
    CONSTRAINT CHK_THEVANG_B      CHECK (TheVangDoiB >= 0),
    CONSTRAINT CHK_THEDO_A        CHECK (TheDoDoiA >= 0),
    CONSTRAINT CHK_THEDO_B        CHECK (TheDoDoiB >= 0)
);

-- Bảng PHAN_CONG_TRAN_DAU: Quản lý tổ trọng tài (chính, phụ, VAR) và giám sát cho từng trận, làm căn cứ truy vấn để hàm chính sách VPD kiểm soát quyền cập nhật kết quả
CREATE TABLE PHAN_CONG_TRAN_DAU (
    MaPhanCong          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    MaTranDau           VARCHAR2(20) NOT NULL,
    Username            VARCHAR2(50) NOT NULL,
    VaiTroTranDau       VARCHAR2(30) NOT NULL,
    
    CONSTRAINT FK_PC_TRAN         FOREIGN KEY (MaTranDau) REFERENCES TRAN_DAU(MaTranDau),
    CONSTRAINT FK_PC_USER         FOREIGN KEY (Username) REFERENCES USER_INFO(Username),
    CONSTRAINT UK_PC_MATCH_USER   UNIQUE (MaTranDau, Username),
    CONSTRAINT CHK_PC_ROLE        CHECK (VaiTroTranDau IN ('MAIN_REFEREE','ASSISTANT_1','ASSISTANT_2','VAR','SUPERVISOR'))
);

-- Bảng AUDIT_LOG: Nhật ký kiểm toán nội bộ của ứng dụng, ghi nhận lại các giá trị JSON cũ/mới phục vụ việc hiển thị dữ liệu biến động trên Security Dashboard
CREATE TABLE AUDIT_LOG (
    AuditID             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username            VARCHAR2(50),
    ActionType          VARCHAR2(20),  
    ObjectName          VARCHAR2(100), 
    RecordID            VARCHAR2(100), 
    OldValue            CLOB,
    NewValue            CLOB,
    ClientIP            VARCHAR2(100),
    ActionTime          TIMESTAMP DEFAULT SYSTIMESTAMP,
    Status              VARCHAR2(20) DEFAULT 'SUCCESS' NOT NULL
);

-- Hệ thống Chỉ mục tối ưu hiệu năng truy vấn cho ứng dụng và đẩy nhanh tốc độ biên dịch mệnh đề WHERE của chính sách bảo mật VPD
CREATE INDEX IDX_USER_ROLE      ON USER_INFO(VaiTro);
CREATE INDEX IDX_USER_TEAM      ON USER_INFO(MaDoi);
CREATE INDEX IDX_THANHVIEN_DOI  ON THANH_VIEN_DOI(MaDoi);
CREATE INDEX IDX_TRAN_GIAI      ON TRAN_DAU(MaGiai);
CREATE INDEX IDX_TRAN_STATUS    ON TRAN_DAU(TrangThaiTran);
CREATE INDEX IDX_KETQUA_STATUS  ON TRAN_DAU(KetQuaStatus);
CREATE INDEX IDX_PC_USER        ON PHAN_CONG_TRAN_DAU(Username);
CREATE INDEX IDX_PC_MATCH       ON PHAN_CONG_TRAN_DAU(MaTranDau);
CREATE INDEX IDX_AUDIT_USER     ON AUDIT_LOG(Username);
CREATE INDEX IDX_AUDIT_TIME     ON AUDIT_LOG(ActionTime);
CREATE INDEX IDX_DOI_GIAI       ON DOI_THI_DAU(MaGiai);
CREATE INDEX IDX_TRAN_DOIA      ON TRAN_DAU(MaDoiA);
CREATE INDEX IDX_TRAN_DOIB      ON TRAN_DAU(MaDoiB);

PROMPT SPORTS TOURNAMENT DATABASE CREATED SUCCESSFULLY