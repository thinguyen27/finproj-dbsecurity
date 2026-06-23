package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.request.LoginRequest;
import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.authenticate(request.getUsername(), request.getPassword()));
    }
}