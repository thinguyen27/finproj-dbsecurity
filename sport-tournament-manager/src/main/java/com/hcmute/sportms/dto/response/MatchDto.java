package com.hcmute.sportms.dto.response;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class MatchDto {
    private String maTranDau;
    private String maGiai;
    private String tenDoiA;
    private String tenDoiB;
    private Integer vongDau;
    private LocalDateTime ngayGioThiDau;
    private String tenSan;
    private String trangThaiTran;
    private String ketQuaStatus;
    private Integer tySoDoiA;
    private Integer tySoDoiB;
}