package com.hcmute.sportms.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "USER_INFO", schema = "SPORTS_OWNER")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserInfo {

    @Id
    @Column(name = "USERNAME", length = 50)
    private String username;

    @Column(name = "HOTEN", nullable = false, length = 100)
    private String hoTen;

    @Column(name = "EMAIL", length = 100)
    private String email;

    @Column(name = "SODIENTHOAI", length = 15)
    private String soDienThoai;

    @Column(name = "PASSWORD_HASH", nullable = false, length = 500)
    private String passwordHash;

    @Column(name = "VAITRO", nullable = false, length = 20)
    private String vaiTro;

    @Column(name = "TRANGTHAI", nullable = false, length = 20)
    private String trangThai = "ACTIVE";

    @Column(name = "MADOI", length = 20)
    private String maDoi;

    @Column(name = "ISDELETED", nullable = false, length = 1)
    private String isDeleted = "N";

}