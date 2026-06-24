package com.hcmute.sportms.config;

import com.hcmute.sportms.filter.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable) // Tắt CSRF vì Web dùng JWT (Stateless)
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                // 1. Mở cửa tự do cho API Đăng nhập
                .requestMatchers("/api/auth/login").permitAll()
                
                // 2. KHÓA CHẾT: Chỉ Ban Tổ Chức mới được dùng API Quản trị Hệ thống
                .requestMatchers("/api/admin/**").hasAuthority("Role_BTC")
                
                // 3. Phân quyền API Audit (Ban Tổ Chức và Giám Sát được xem)
                .requestMatchers("/api/audit/**").hasAnyAuthority("Role_BTC", "Role_GS")
                
                // 4. Các API khác bắt buộc phải có Token hợp lệ
                .anyRequest().authenticated()
            )
            // Đẩy bộ lọc JWT của chúng ta lên kiểm tra trước tiên
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
            
        return http.build();
    }
}