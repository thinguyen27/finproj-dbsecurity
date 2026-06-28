package com.hcmute.sportms.repository;

import com.hcmute.sportms.dto.response.MatchDto;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
public class MatchRepository {
    private final JdbcTemplate jdbcTemplate;

    public MatchRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<MatchDto> findAllMatches() {
        String sql = "SELECT t.MaTranDau, t.MaGiai, t.VongDau, t.NgayGioThiDau, " +
                     "t.TrangThaiTran, t.KetQuaStatus, t.TySoDoiA, t.TySoDoiB, " +
                     "da.TenDoi AS TenDoiA, db.TenDoi AS TenDoiB, s.TenSan " +
                     "FROM SPORTS_OWNER.TRAN_DAU t " +
                     "LEFT JOIN SPORTS_OWNER.DOI_THI_DAU da ON t.MaDoiA = da.MaDoi " +
                     "LEFT JOIN SPORTS_OWNER.DOI_THI_DAU db ON t.MaDoiB = db.MaDoi " +
                     "LEFT JOIN SPORTS_OWNER.SAN_THI_DAU s ON t.MaSan = s.MaSan " +
                     "ORDER BY t.NgayGioThiDau ASC";

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            MatchDto dto = new MatchDto();
            dto.setMaTranDau(rs.getString("MaTranDau"));
            dto.setMaGiai(rs.getString("MaGiai"));
            dto.setVongDau(rs.getInt("VongDau"));
            
            Timestamp ts = rs.getTimestamp("NgayGioThiDau");
            if (ts != null) {
                dto.setNgayGioThiDau(ts.toLocalDateTime());
            }
            
            dto.setTrangThaiTran(rs.getString("TrangThaiTran"));
            dto.setKetQuaStatus(rs.getString("KetQuaStatus"));
            dto.setTySoDoiA(rs.getObject("TySoDoiA", Integer.class));
            dto.setTySoDoiB(rs.getObject("TySoDoiB", Integer.class));
            dto.setTenDoiA(rs.getString("TenDoiA"));
            dto.setTenDoiB(rs.getString("TenDoiB"));
            dto.setTenSan(rs.getString("TenSan"));
            
            return dto;
        });
    }
}