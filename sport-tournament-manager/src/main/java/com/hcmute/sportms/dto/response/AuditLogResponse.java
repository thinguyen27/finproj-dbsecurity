package com.hcmute.sportms.dto.response;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AuditLogResponse {
    private Long auditId;
    private String username;
    private String actionType;
    private String objectName;
    private String recordId;
    private JsonNode oldValue;
    private JsonNode newValue;
    private String clientIp;
    private LocalDateTime actionTime;
    private String status;
}