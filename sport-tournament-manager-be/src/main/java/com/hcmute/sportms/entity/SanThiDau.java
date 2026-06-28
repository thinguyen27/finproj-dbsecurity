package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "SAN_THI_DAU", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SanThiDau {

    @Id
    @Column(name = "MASAN", length = 20)
    private String maSan;

    @Column(name = "TENSAN", nullable = false, length = 100)
    private String tenSan;

    @Column(name = "DIACHI", length = 200)
    private String diaChi;

    @Column(name = "SUCCHUA")
    private Integer sucChua;

    @Column(name = "MOTA", length = 500)
    private String moTa;
}