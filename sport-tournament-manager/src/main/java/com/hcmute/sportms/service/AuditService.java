package com.hcmute.sportms.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmute.sportms.dto.response.AuditLogResponse;
import com.hcmute.sportms.repository.AuditRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuditService {
    private final AuditRepository auditRepository;
    private final ObjectMapper objectMapper;

    public List<AuditLogResponse> getParsedAuditLogs() {
        List<Map<String, Object>> rawLogs = auditRepository.fetchRawAuditLogs();

        return rawLogs.stream().map(row -> {
            AuditLogResponse dto = new AuditLogResponse();
            dto.setAuditId(((Number) row.get("AUDITID")).longValue());
            dto.setUsername((String) row.get("USERNAME"));
            dto.setActionType((String) row.get("ACTIONTYPE"));
            dto.setObjectName((String) row.get("OBJECTNAME"));
            dto.setRecordId((String) row.get("RECORDID"));
            dto.setClientIp((String) row.get("CLIENTIP"));
            dto.setStatus((String) row.get("STATUS"));
            
            Timestamp actionTime = (Timestamp) row.get("ACTIONTIME");
            if (actionTime != null) {
                dto.setActionTime(actionTime.toLocalDateTime());
            }

            // Parse CLOB to JSON Node
            dto.setOldValue(parseClobToJson((String) row.get("OLDVALUE"), dto.getAuditId()));
            dto.setNewValue(parseClobToJson((String) row.get("NEWVALUE"), dto.getAuditId()));

            return dto;
        }).collect(Collectors.toList());
    }

    private JsonNode parseClobToJson(String clobData, Long auditId) {
        if (clobData == null || clobData.trim().isEmpty()) {
            return null;
        }
        try {
            return objectMapper.readTree(clobData);
        } catch (Exception e) {
            log.warn("Không thể parse JSON Audit tại ID: {}. Dữ liệu thô: {}", auditId, clobData);
            return null;
        }
    }
}