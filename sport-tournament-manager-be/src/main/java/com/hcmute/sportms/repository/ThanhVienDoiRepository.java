package com.hcmute.sportms.repository;

import com.hcmute.sportms.entity.ThanhVienDoi;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ThanhVienDoiRepository extends JpaRepository<ThanhVienDoi, String> {
	List<ThanhVienDoi> findByMaDoi(String maDoi);
}