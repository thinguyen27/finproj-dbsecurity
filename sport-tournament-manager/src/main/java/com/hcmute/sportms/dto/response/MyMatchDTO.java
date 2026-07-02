package com.hcmute.sportms.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MyMatchDTO {
    private String maTranDau;
    private String maDoiA;
    private String maDoiB;
    private String tenDoiA;
    private String tenDoiB;
    private Integer tySoDoiA;
    private Integer tySoDoiB;
    private String trangThaiTran;
    private String ngayGioThiDau;
    private Integer vongDau;
}