package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "TRAN_DAU", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TranDau {

    @Id
    @Column(name = "MATRANDAU", length = 20)
    private String maTranDau;

    @Column(name = "MAGIAI", nullable = false, length = 20)
    private String maGiai;

    @Column(name = "MADOIA", nullable = false, length = 20)
    private String maDoiA;

    @Column(name = "MADOIB", nullable = false, length = 20)
    private String maDoiB;

    @Column(name = "VONGDAU")
    private Integer vongDau;

    @Column(name = "NGAYGIOTHIDAU", nullable = false)
    private LocalDateTime ngayGioThiDau;

    @Column(name = "MASAN", length = 20)
    private String maSan;

    @Column(name = "TYSODOIA")
    private Integer tySoDoiA = 0;

    @Column(name = "TYSODOIB")
    private Integer tySoDoiB = 0;

    @Column(name = "THEVANGDOIA")
    private Integer theVangDoiA = 0;

    @Column(name = "THEVANGDOIB")
    private Integer theVangDoiB = 0;

    @Column(name = "THEDODOIA")
    private Integer theDoDoiA = 0;

    @Column(name = "THEDODOIB")
    private Integer theDoDoiB = 0;

    @Column(name = "TRANGTHAITRAN", nullable = false, length = 20)
    private String trangThaiTran = "PENDING";

    @Column(name = "KETQUASTATUS", nullable = false, length = 20)
    private String ketQuaStatus = "PENDING";

    @Column(name = "NGUOIDUYETKETQUA", length = 50)
    private String nguoiDuyetKetQua;

    @Column(name = "NGAYDUYETKETQUA")
    private LocalDateTime ngayDuyetKetQua;

    @Column(name = "ISDELETED", nullable = false, length = 1)
    private String isDeleted = "N";
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MADOIA", referencedColumnName = "MADOI",
                insertable = false, updatable = false)
    private DoiThiDau doiA;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MADOIB", referencedColumnName = "MADOI",
                insertable = false, updatable = false)
    private DoiThiDau doiB;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
        name = "MASAN",
        referencedColumnName = "MASAN",
        insertable = false,
        updatable = false
    )
    private SanThiDau sanThiDau;
}