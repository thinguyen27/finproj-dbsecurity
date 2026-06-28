package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "THANH_VIEN_DOI", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ThanhVienDoi {

    @Id
    @Column(name = "MATHANHVIEN", length = 20)
    private String maThanhVien;

    @Column(name = "MADOI", nullable = false, length = 20)
    private String maDoi;

    @Column(name = "TENTHANHVIEN", nullable = false, length = 100)
    private String tenThanhVien;

    @Column(name = "LOAITHANHVIEN", nullable = false, length = 20)
    private String loaiThanhVien;

    @Column(name = "NGAYSINH")
    private LocalDate ngaySinh;

    @Column(name = "GIOITINH", length = 10)
    private String gioiTinh;

    @Column(name = "SOAO")
    private Integer soAo;

    @Column(name = "CCCD", length = 20)
    private String cccd;

    @Column(name = "SODIENTHOAI", length = 15)
    private String soDienThoai;

    @Column(name = "EMAILTHANHVIEN", length = 100)
    private String emailThanhVien;

    @Column(name = "THONGTINSUCKHOE", length = 500)
    private String thongTinSucKhoe;

    @Column(name = "OLS_LABEL")
    private Integer olsLabel;

    @Column(name = "ISDELETED", nullable = false, length = 1)
    private String isDeleted = "N";
}