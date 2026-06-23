package com.hcmute.sportms.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtils {

    @Value("${jwt.secret}")
    private String secretString;

    @Value("${jwt.expiration}")
    private long expirationMs;

    private SecretKey key;

    @PostConstruct
    public void init() {
        // Khởi tạo khóa mã hóa từ chuỗi secret trong properties
        this.key = Keys.hmacShaKeyFor(secretString.getBytes());
    }

    // 1. Sinh Token khi Login thành công
    public String generateToken(String username, String role, String teamId) {
        return Jwts.builder()
                .subject(username)
                .claim("role", role)
                .claim("teamId", teamId != null ? teamId : "NONE")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(key)
                .compact();
    }

    // 2. Giải mã Token để lấy thông tin (dùng cho Aspect)
    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}