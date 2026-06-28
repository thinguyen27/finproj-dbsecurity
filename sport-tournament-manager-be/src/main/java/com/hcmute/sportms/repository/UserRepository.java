package com.hcmute.sportms.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.hcmute.sportms.entity.UserInfo;

@Repository
public interface UserRepository
        extends JpaRepository<UserInfo, String> {

    List<UserInfo> findByVaiTro(String vaiTro);
    List<UserInfo> findByVaiTroIgnoreCase(String vaiTro);
    List<UserInfo> findByIsDeleted(String isDeleted);
    
}
