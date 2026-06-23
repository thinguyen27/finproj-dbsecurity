package com.hcmute.sportms.service;

import com.hcmute.sportms.repository.SysAdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SysAdminService {
    private final SysAdminRepository sysAdminRepository;

    public List<Map<String, Object>> getAllUsersWithPrivileges() {
        return sysAdminRepository.getSystemUsers();
    }

    @Transactional
    public void grantRoleToUser(String role, String username) {
        // Validation chống SQL Injection trên lệnh DDL
        if (!role.matches("^[A-Z0-9_]+$") || !username.matches("^[A-Z0-9_]+$")) {
            throw new IllegalArgumentException("Dữ liệu Role hoặc Username chứa ký tự không hợp lệ.");
        }
        sysAdminRepository.executeGrantRole(role, username);
    }
}