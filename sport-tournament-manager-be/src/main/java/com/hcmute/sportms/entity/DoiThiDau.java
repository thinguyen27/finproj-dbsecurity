package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "DOI_THI_DAU", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoiThiDau {

    @Id
    @Column(name = "MADOI", length = 20)
    private String maDoi;

    @Column(name = "TENDOI", nullable = false, length = 100)
    private String tenDoi;

    @Column(name = "TRUONGDOAN_USERNAME", nullable = false, length = 50)
    private String truongDoan_Username;

    @Column(name = "SANNHA", length = 100)
    private String sanNha;

    @Column(name = "NGAYTHANHLAP")
    private LocalDate ngayThanhLap;

    @Column(name = "ISDELETED", nullable = false, length = 1)
    private String isDeleted = "N";
    
    @ManyToOne
    @JoinColumn(name = "MAGIAI")
    private GiaiDau giaiDau;
}