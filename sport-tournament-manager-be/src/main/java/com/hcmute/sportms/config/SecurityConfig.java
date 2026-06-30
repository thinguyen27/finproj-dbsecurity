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
            	    // Static resources
            	    .requestMatchers("/css/**", "/js/**", "/images/**", "/webjars/**", "/assets/**").permitAll()
            	    .requestMatchers("/login", "/signup", "/forgot-password", "/", "/index", "/home").permitAll()
            	    .requestMatchers("/api/auth/login", "/api/auth/logout").permitAll()
            	    
            	    // 1. Phân hệ MATCH
            	    .requestMatchers("/match/my-matches").hasAuthority("ROLE_TT") 
            	    .requestMatchers("/match", "/match/list", "/match/detail/**").permitAll() 
            	    
            	    // 2. Phân hệ TEAM & TOURNAMENT
            	    .requestMatchers("/team/list", "/team/detail/**", "/tournament/list", "/tournament/detail/**", "/stadium/**").permitAll()
            	    .requestMatchers("/team/add/**", "/team/delete/**", "/user/**").hasAuthority("ROLE_BTC")
            	    .requestMatchers("/team/edit/**").hasAnyAuthority("ROLE_BTC", "ROLE_TD")
            	    
            	    // 3. Phân hệ ADMIN & AUDIT
            	    .requestMatchers("/admin/**").hasAuthority("ROLE_BTC")
            	    .requestMatchers("/audit/**").hasAnyAuthority("ROLE_BTC", "ROLE_GS")
            	    
            	    // Các API khác bắt buộc phải có Token hợp lệ
            	    .anyRequest().authenticated()
            	)
            // Đẩy bộ lọc JWT của chúng ta lên kiểm tra trước tiên
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
            
        return http.build();
    }
}