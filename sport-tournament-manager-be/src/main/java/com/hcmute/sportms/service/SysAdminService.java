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
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getAllUsersWithPrivileges() {
        return sysAdminRepository.getSystemUsers();
    }
    
    @Transactional(readOnly = true)
    public Map<String, Object> getUserOrRolePrivilegesDetails(String granteeName) {
        // 1. Lấy quyền hệ thống
        List<Map<String, Object>> sysPrivs = sysAdminRepository.getSystemPrivileges(granteeName);
        
        // 2. Lấy quyền đối tượng
        List<Map<String, Object>> objPrivs = sysAdminRepository.getObjectPrivileges(granteeName);
        
        // 3. Đóng gói lại thành 1 Map (hoặc bạn có thể tự định nghĩa 1 class DTO) trả về cho Frontend
        return Map.of(
            "grantee", granteeName.toUpperCase(),
            "systemPrivileges", sysPrivs,
            "objectPrivileges", objPrivs
        );
    }

    @Transactional
    public void grantRoleToUser(String role, String username) {
        // Validation chống SQL Injection trên lệnh DDL
    	if (!role.matches("^[a-zA-Z0-9_]+$") || !username.matches("^[a-zA-Z0-9_]+$")) {
    	    throw new IllegalArgumentException("Dữ liệu Role hoặc Username chứa ký tự không hợp lệ.");
    	}
        sysAdminRepository.executeGrantRole(role, username);
    }
}