package com.hcmute.sportms.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class SysAdminRepository {
    private final JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> getSystemUsers() {
        String sql = """
            SELECT u.USERNAME, u.ACCOUNT_STATUS, u.CREATED, r.GRANTED_ROLE 
            FROM DBA_USERS u
            LEFT JOIN DBA_ROLE_PRIVS r ON u.USERNAME = r.GRANTEE
            WHERE u.USERNAME IN (SELECT Username FROM SPORTS_OWNER.USER_INFO)
        """;
        return jdbcTemplate.queryForList(sql);
    }

    public void executeGrantRole(String role, String username) {
        String sql = String.format("GRANT %s TO %s", role, username);
        jdbcTemplate.execute(sql);
    }
}