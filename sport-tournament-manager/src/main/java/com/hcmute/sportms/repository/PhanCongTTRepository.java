package com.hcmute.sportms.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hcmute.sportms.entity.PhanCongTT;

public interface PhanCongTTRepository extends JpaRepository<PhanCongTT, Long>{

    List<PhanCongTT> findByMaTranDau(String maTranDau);

    // THÊM 2 ANNOTATION NÀY ĐỂ ÉP DELETE NGAY LẬP TỨC DƯỚI DB
    @Modifying
    @Query("DELETE FROM PhanCongTT p WHERE p.maTranDau = :maTranDau")
    void deleteByMaTranDau(@Param("maTranDau") String maTranDau);

}