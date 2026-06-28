package com.hcmute.sportms.repository;

import com.hcmute.sportms.entity.SanThiDau;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SanThiDauRepository extends JpaRepository<SanThiDau, String> {
}