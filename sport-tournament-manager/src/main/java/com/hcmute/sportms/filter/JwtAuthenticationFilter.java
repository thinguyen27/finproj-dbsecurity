package com.hcmute.sportms.filter;

import com.hcmute.sportms.utils.JwtUtils;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
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
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        String authHeader = request.getHeader("Authorization");
        
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            try {
                // Giải mã Token
                Claims claims = jwtUtils.parseToken(token);
                String username = claims.getSubject();
                String role = claims.get("role", String.class);
                
                // Nếu Token hợp lệ, tạo chứng nhận an ninh cho Request này
                if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    
                    // Nạp role vào danh sách Quyền của Spring Security
                    SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role);
                    
                    // Nhét toàn bộ Claims vào phần Credentials để Aspect phía sau dùng lại (đỡ phải parse JWT 2 lần)
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            username, claims, Collections.singletonList(authority)
                    );
                    
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            } catch (Exception e) {
                log.warn("JWT Filter - Token không hợp lệ hoặc đã hết hạn: {}", e.getMessage());
            }
        }
        
        // Cho phép Request đi tiếp tới Controller
        filterChain.doFilter(request, response);
    }
}