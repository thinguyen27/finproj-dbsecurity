package com.hcmute.sportms.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateScoreRequest {

    @NotNull(message = "Tỷ số đội A không được null")
    @Min(value = 0, message = "Tỷ số không được âm")
    private Integer tySoDoiA;

    @NotNull(message = "Tỷ số đội B không được null")
    @Min(value = 0, message = "Tỷ số không được âm")
    private Integer tySoDoiB;

    @Min(0) private Integer theVangDoiA;
    @Min(0) private Integer theVangDoiB;
    @Min(0) private Integer theDoDoiA;
    @Min(0) private Integer theDoDoiB;
}