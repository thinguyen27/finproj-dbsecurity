package com.hcmute.sportms.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "V_TRAN_DAU")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VTranDau {

    @Id
    @Column(name = "MATRANDAU")
    private String maTranDau;

    @Column(name = "MAGIAI")
    private String maGiai;

    @Column(name = "TENGIAI")
    private String tenGiai;

    @Column(name = "MADOIA")
    private String maDoiA;

    @Column(name = "TENDOIA")
    private String tenDoiA;

    @Column(name = "MADOIB")
    private String maDoiB;

    @Column(name = "TENDOIB")
    private String tenDoiB;

    @Column(name = "VONGDAU")
    private Integer vongDau;

    @Column(name = "NGAYGIOTHIDAU")
    private LocalDateTime ngayGioThiDau;

    @Column(name = "MASAN")
    private String maSan;

    @Column(name = "TENSAN")
    private String tenSan;

    @Column(name = "TYSODOIA")
    private Integer tySoDoiA;

    @Column(name = "TYSODOIB")
    private Integer tySoDoiB;

    @Column(name = "THEVANGDOIA")
    private Integer theVangDoiA;

    @Column(name = "THEVANGDOIB")
    private Integer theVangDoiB;

    @Column(name = "THEDODOIA")
    private Integer theDoDoiA;

    @Column(name = "THEDODOIB")
    private Integer theDoDoiB;

    @Column(name = "TRANGTHAITRAN")
    private String trangThaiTran;

    @Column(name = "KETQUASTATUS")
    private String ketQuaStatus;

    @Column(name = "NGUOIDUYETKETQUA")
    private String nguoiDuyetKetQua;

    @Column(name = "NGAYDUYETKETQUA")
    private LocalDateTime ngayDuyetKetQua;

    @Column(name = "ISDELETED")
    private String isDeleted;
}