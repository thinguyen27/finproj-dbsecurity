package com.hcmute.sportms.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.hcmute.sportms.entity.DoiThiDau;
import com.hcmute.sportms.entity.UserInfo;
import com.hcmute.sportms.repository.TeamRepository;
import com.hcmute.sportms.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final TeamRepository doiRepository;
    public List<UserInfo> getTruongDoan() {
        return userRepository.findByVaiTro("ROLE_TD");
    }
    public List<UserInfo> getReferees() {
        return userRepository.findByVaiTro("ROLE_TT");
    }

    public List<UserInfo> getSupervisors() {
        return userRepository.findByVaiTro("ROLE_GS");
    }
    public List<UserInfo> getAllReferees() {
        return userRepository.findByVaiTroIgnoreCase("ROLE_TT");
    }

    public List<UserInfo> getAllSupervisors() {
        return userRepository.findByVaiTroIgnoreCase("ROLE_GS");
    }
    public List<UserInfo> findAll(){

        return userRepository.findByIsDeleted("N");

    }

    public UserInfo findById(String username){

        return userRepository.findById(username)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy người dùng"));

    }

    @Transactional
    public void save(UserInfo user){

        // Thêm mới
        if(!userRepository.existsById(user.getUsername())){

        	userRepository.save(user);

            return;
        }

        // Cập nhật
        UserInfo old = userRepository.findById(user.getUsername())
                .orElseThrow();

        old.setHoTen(user.getHoTen());
        old.setEmail(user.getEmail());
        old.setSoDienThoai(user.getSoDienThoai());
        old.setVaiTro(user.getVaiTro());
        old.setTrangThai(user.getTrangThai());
        old.setMaDoi(user.getMaDoi());

        userRepository.save(old);

    }

    @Transactional
    public void delete(String username){

        UserInfo user = userRepository.findById(username)
                .orElseThrow();

        user.setIsDeleted("Y");

        userRepository.save(user);

    }
    public List<DoiThiDau> getAllTeams() {
        return doiRepository.findAll();
    }
}
