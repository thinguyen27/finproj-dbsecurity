package com.hcmute.sportms.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class AuditRepository {
    private final JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> fetchRawAuditLogs() {
        // Lưu ý: Phải có prefix SPORTS_OWNER. vì đang kết nối bằng SEC_ADMIN
        String sql = """
            SELECT AuditID, Username, ActionType, ObjectName, RecordID, 
                   OldValue, NewValue, ClientIP, ActionTime, Status
            FROM SPORTS_OWNER.AUDIT_LOG 
            ORDER BY ActionTime DESC
        """;
        return jdbcTemplate.queryForList(sql);
    }
}