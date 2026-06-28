package com.hcmute.sportms.controller;

import com.hcmute.sportms.service.SysAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class SysAdminController {
    private final SysAdminService sysAdminService;

    @GetMapping("/users")
    public ResponseEntity<?> getSystemUsers() {
        return ResponseEntity.ok(sysAdminService.getAllUsersWithPrivileges());
    }

    @PostMapping("/grant")
    public ResponseEntity<?> grantRole(@RequestParam String role, @RequestParam String username) {
        sysAdminService.grantRoleToUser(role, username);
        return ResponseEntity.ok("Cấp quyền " + role + " cho " + username + " thành công.");
    }
}