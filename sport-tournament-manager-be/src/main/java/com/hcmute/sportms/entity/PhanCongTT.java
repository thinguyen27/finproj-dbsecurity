package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "PHAN_CONG_TRAN_DAU", schema = "SPORTS_OWNER")
@Data
public class PhanCongTT {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MAPHANCONG")
    private Long maPhanCong;

    @Column(name = "MATRANDAU")
    private String maTranDau;

    @Column(name = "USERNAME")
    private String username;

    @Column(name = "VAITROTRANDAU")
    private String vaiTroTranDau;
}