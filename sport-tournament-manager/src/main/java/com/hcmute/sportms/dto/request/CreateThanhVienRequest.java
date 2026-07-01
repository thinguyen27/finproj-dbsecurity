package com.hcmute.sportms.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import java.time.LocalDate;

@Data
public class CreateThanhVienRequest {
    
    @NotBlank(message = "Mã đội không được để trống")
    private String maDoi;

    @NotBlank(message = "Tên thành viên không được để trống")
    private String tenThanhVien;
    private String maThanhVien;
    @NotBlank(message = "Loại thành viên không được để trống")
    @Pattern(regexp = "^(CAU_THU|HLV_TRUONG|HLV_PHO|BAC_SI)$", message = "Loại thành viên không hợp lệ")
    private String loaiThanhVien;

    private LocalDate ngaySinh;
    private String gioiTinh;
    private Integer soAo;
    private String cccd;
    private String soDienThoai;
    private String emailThanhVien;
    private String thongTinSucKhoe;
}