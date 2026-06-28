package com.hcmute.sportms.repository;

import com.hcmute.sportms.entity.TranDau;
import com.hcmute.sportms.entity.VTranDau;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TranDauRepository extends JpaRepository<TranDau, String> {
	List<TranDau> findByIsDeleted(String isDeleted);
	@Query("""
			SELECT t
			FROM TranDau t
			JOIN FETCH t.doiA
			JOIN FETCH t.doiB
			LEFT JOIN FETCH t.sanThiDau
			""")
			List<TranDau> findAllWithTeams();
	
	@Query("""
			SELECT t
			FROM VTranDau t
			WHERE (t.maDoiA = :maDoi OR t.maDoiB = :maDoi)
			AND t.ngayGioThiDau >= CURRENT_TIMESTAMP
			ORDER BY t.ngayGioThiDau
			""")
			List<VTranDau> findUpcomingByTeam(@Param("maDoi") String maDoi);
	
	@Query("""
			SELECT t
			FROM VTranDau t
			WHERE (t.maDoiA = :maDoi OR t.maDoiB = :maDoi)
			AND t.ngayGioThiDau < CURRENT_TIMESTAMP
			ORDER BY t.ngayGioThiDau DESC
			""")
			List<VTranDau> findPastByTeam(@Param("maDoi") String maDoi);
	
	List<TranDau> findByMaGiai(String maGiai);
	
	Optional<TranDau> findByMaTranDau(String maTranDau);
	
	
	@Query(value = """
	        SELECT 
	            t.MATRANDAU, 
	            t.MADOIA, 
	            t.MADOIB, 
	            t.TYSODOIA, 
	            t.TYSODOIB, 
	            t.TRANGTHAITRAN, 
	            TO_CHAR(t.NGAYGIOTHIDAU, 'YYYY-MM-DD HH24:MI:SS'), 
	            t.VONGDAU
	        FROM SPORTS_OWNER.TRAN_DAU t
	        INNER JOIN SPORTS_OWNER.PHAN_CONG_TRAN_DAU pc ON t.MATRANDAU = pc.MaTranDau
	        WHERE pc.Username = :username
	          AND pc.VaiTroTranDau IN ('MAIN_REFEREE', 'ASSISTANT_1', 'ASSISTANT_2', 'VAR')
	        ORDER BY t.NGAYGIOTHIDAU DESC
	    """, nativeQuery = true)
	    List<Object[]> findMatchesByRefereeUsername(@Param("username") String username);

	    
	    @Query(value = "SELECT MAX(t.MATRANDAU) FROM SPORTS_OWNER.TRAN_DAU t", nativeQuery = true)
	    String findMaxMatchCode();
}