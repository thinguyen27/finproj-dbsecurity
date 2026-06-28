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
                .withProcedureName("PKG_CRYPTO_UTILS.LOGIN_USER") 
                .withoutProcedureColumnMetaDataAccess()
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
    public String hashTest(String password) {
        return jdbcTemplate.queryForObject(
            "SELECT SEC_ADMIN.PKG_CRYPTO_UTILS.HASH_PASSWORD(?) FROM DUAL",
            String.class,
            password
        );
    }
}