package com.hcmute.sportms.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hcmute.sportms.entity.PhanCongTT;

public interface PhanCongTTRepository extends JpaRepository<PhanCongTT, Long>{

    List<PhanCongTT> findByMaTranDau(String maTranDau);

    void deleteByMaTranDau(String maTranDau);

}