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
                    .requestMatchers("/css/**", "/js/**", "/images/**", "/static/**").permitAll()
                    
                    // Thu hẹp lại, chỉ thả cửa trang chủ, đăng nhập, quên mật khẩu
                    .requestMatchers("/", "/home", "/login", "/register", "/forgot-password", "/reset-password", "/error").permitAll()                
                    .requestMatchers("/api/auth/**").permitAll()
                    
                    // Khóa bảo vệ trang Giao diện Dashboard và API (Cả 2 đều yêu cầu quyền BTC)
                    .requestMatchers("/audit-dashboard", "/api/audit/**").hasAnyAuthority("ROLE_BTC")                    
                    // Tất cả các trang HTML nghiệp vụ khác như /my-matches,... phải đăng nhập mới xem được
                    .anyRequest().authenticated()
                )
            // Đẩy bộ lọc JWT của chúng ta lên kiểm tra trước tiên
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
            
        return http.build();
    }
}