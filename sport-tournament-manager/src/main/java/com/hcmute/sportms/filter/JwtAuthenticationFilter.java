package com.hcmute.sportms.filter;

import com.hcmute.sportms.utils.JwtUtils;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {
	
    private final JwtUtils jwtUtils;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String token = null;

        // ======================
        // 1. Đọc từ Authorization Header (API)
        // ======================
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        }

        // ======================
        // 2. Nếu không có thì đọc từ Cookie (Web)
        // ======================
        if (token == null && request.getCookies() != null) {

            for (Cookie cookie : request.getCookies()) {

                if ("jwt_token".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
        
                }

            }
        }

        System.out.println("===== JWT FILTER =====");
        System.out.println("URI = " + request.getRequestURI());
        System.out.println("TOKEN = " + token);
        System.out.println("--------------------------------");
        System.out.println(request.getMethod() + " " + request.getRequestURI());

        if (token != null) {

            try {

                Claims claims = jwtUtils.parseToken(token);

                String username = claims.getSubject();
                String role = claims.get("role", String.class);
                role = role.toUpperCase();
                System.out.println("USERNAME = " + username);
                System.out.println("ROLE = " + role);

                if (SecurityContextHolder.getContext().getAuthentication() == null) {

                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(
                                    username,
                                    claims,
                                    Collections.singletonList(
                                            new SimpleGrantedAuthority(role))
                            );

                    SecurityContextHolder.getContext()
                            .setAuthentication(authentication);

                    System.out.println("SET AUTH SUCCESS");
                }

            } catch (Exception e) {
                SecurityContextHolder.clearContext(); // PHẢI XÓA khi token không hợp lệ
                log.error("Authentication failed: {}", e.getMessage());
            }
        }

        filterChain.doFilter(request, response);

        System.out.println("DONE " + request.getRequestURI());
        return;
    }
}