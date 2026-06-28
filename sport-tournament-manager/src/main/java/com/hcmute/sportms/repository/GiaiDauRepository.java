package com.hcmute.sportms.repository;

import com.hcmute.sportms.entity.GiaiDau;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GiaiDauRepository extends JpaRepository<GiaiDau, String> {
	List<GiaiDau> findByIsDeleted(String isDeleted);

	 Optional<GiaiDau> findByMaGiaiAndIsDeleted(
	            String maGiai,
	            String isDeleted
	    );
}