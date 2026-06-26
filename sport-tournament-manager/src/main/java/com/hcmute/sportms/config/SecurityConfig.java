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
                // 1. Mở khóa toàn bộ file tĩnh (CSS, JS, Hình ảnh) để giao diện không bị vỡ
                .requestMatchers("/css/**", "/js/**", "/images/**", "/static/**").permitAll()
                
                // 2. Mở khóa cho CÁC ĐƯỜNG DẪN GIAO DIỆN (Frontend URL)
                // Phải mở khóa để trình duyệt load được khung file HTML
                .requestMatchers("/", "/login", "/forgot-password", "/audit-dashboard", "/error").permitAll()                
                // 3. Mở khóa API Đăng nhập của Backend
                .requestMatchers("/api/auth/**").permitAll()
                
                // 4. KHÓA CHẾT: Phân quyền API Quản trị (Chỉ Ban Tổ Chức)
                .requestMatchers("/api/admin/**").hasAuthority("Role_BTC")
                
                // 5. Phân quyền API Audit (Ban Tổ Chức và Giám Sát được xem)
                .requestMatchers("/api/audit/**").hasAnyAuthority("Role_BTC", "Role_GS")
                
                // 6. Các API và đường dẫn khác bắt buộc phải có Token hợp lệ
                .anyRequest().authenticated()
            )
            // Đẩy bộ lọc JWT của chúng ta lên kiểm tra trước tiên
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
            
        return http.build();
    }
}