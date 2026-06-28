package com.hcmute.sportms.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.hcmute.sportms.entity.DoiThiDau;

@Repository
public interface TeamRepository extends JpaRepository<DoiThiDau, String> {
    // Truy vấn danh sách đội (có thể lọc theo MaGiai nếu cần)
    List<DoiThiDau> findAll();
    List<DoiThiDau> findByGiaiDau_MaGiai(String maGiai);
}
