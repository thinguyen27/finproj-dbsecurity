package com.hcmute.sportms.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.sql.Types;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class AuthRepository {
    private final JdbcTemplate jdbcTemplate;

    public Map<String, Object> callLoginProcedure(String username, String password) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withSchemaName("SEC_ADMIN")               // 1. Tách riêng tên Schema
                .withCatalogName("PKG_CRYPTO_UTILS")       // 2. Tách riêng tên Package
                .withProcedureName("LOGIN_USER")
                .withoutProcedureColumnMetaDataAccess()    // 3. BẮT BUỘC: Tắt dò tìm Metadata tự động
                .declareParameters(
                        new SqlParameter("p_username", Types.VARCHAR),
                        new SqlParameter("p_password", Types.VARCHAR),
                        new SqlOutParameter("p_status", Types.VARCHAR),
                        new SqlOutParameter("p_role", Types.VARCHAR),
                        new SqlOutParameter("p_team_id", Types.VARCHAR)
                );

        return jdbcCall.execute(new MapSqlParameterSource()
                .addValue("p_username", username)
                .addValue("p_password", password));
    }
    
 // Gọi Oracle để băm pass và cập nhật luôn theo Email
    public boolean resetPasswordByEmail(String email, String plainNewPassword) {
        String sql = "UPDATE SPORTS_OWNER.USER_INFO " +
                     "SET Password_Hash = SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD(?) " +
                     "WHERE Email = ?";
        int rowsAffected = jdbcTemplate.update(sql, plainNewPassword, email);
        return rowsAffected > 0; // Trả về true nếu tìm thấy email và update thành công
    }
    
    public boolean registerUser(String username, String rawPassword, String fullName, String email, String phone) {
        String sql = "INSERT INTO SPORTS_OWNER.USER_INFO (Username, HoTen, Email, SoDienThoai, Password_Hash, VaiTro) " +
                     "VALUES (?, ?, ?, ?, SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD(?), 'Role_GS')";
                     
        int rowsAffected = jdbcTemplate.update(sql, username, fullName, email, phone, rawPassword);
        return rowsAffected > 0;
    }

    public boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE SPORTS_OWNER.USER_INFO " +
                     "SET Password_Hash = SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD(?) " +
                     "WHERE Username = ?";
        int rowsAffected = jdbcTemplate.update(sql, newPassword, username);
        return rowsAffected > 0;
    }
}