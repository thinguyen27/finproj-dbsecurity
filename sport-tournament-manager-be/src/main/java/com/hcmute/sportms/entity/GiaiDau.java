package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "GIAI_DAU", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GiaiDau {

    @Id
    @Column(name = "MAGIAI", length = 20)
    private String maGiai;

    @Column(name = "TENGIAI", nullable = false, length = 200)
    private String tenGiai;

    @Column(name = "NAMTOCHUC", nullable = false)
    private Integer namToChuc;

    @Column(name = "NGAYBATDAU", nullable = false)
    private LocalDate ngayBatDau;

    @Column(name = "NGAYKETTHUC")
    private LocalDate ngayKetThuc;

    @Column(name = "TRANGTHAI", nullable = false, length = 20)
    private String trangThai = "REGISTRATION";

    @Column(name = "ISDELETED", nullable = false, length = 1)
    private String isDeleted = "N";
}