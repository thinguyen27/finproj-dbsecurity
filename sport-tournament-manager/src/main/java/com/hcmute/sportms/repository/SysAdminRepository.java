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
 // Lấy danh sách Quyền Hệ Thống (Ví dụ: CREATE SESSION, CREATE USER)
    public List<Map<String, Object>> getSystemPrivileges(String granteeName) {
        String sql = """
            SELECT PRIVILEGE, ADMIN_OPTION 
            FROM DBA_SYS_PRIVS 
            WHERE GRANTEE = ?
        """;
        return jdbcTemplate.queryForList(sql, granteeName.toUpperCase());
    }

    // Lấy danh sách Quyền Đối Tượng (Ví dụ: SELECT trên bảng TRAN_DAU)
    public List<Map<String, Object>> getObjectPrivileges(String granteeName) {
        String sql = """
            SELECT TABLE_NAME, PRIVILEGE, GRANTABLE 
            FROM DBA_TAB_PRIVS 
            WHERE GRANTEE = ?
        """;
        return jdbcTemplate.queryForList(sql, granteeName.toUpperCase());
    }
}