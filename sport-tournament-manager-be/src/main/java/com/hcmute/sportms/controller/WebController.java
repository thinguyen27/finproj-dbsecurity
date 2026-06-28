package com.hcmute.sportms.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.hcmute.sportms.entity.TranDau;
import com.hcmute.sportms.repository.TranDauRepository;
import com.hcmute.sportms.service.GiaiDauService;
import com.hcmute.sportms.service.ThanhVienService;
import com.hcmute.sportms.service.TranDauService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class WebController {
	private final TranDauRepository tranDauRepository;
    private final GiaiDauService giaiDauService;
    @GetMapping("/login") public String loginPage() { return "auth/login"; }
    
    @GetMapping({"/", "/home"})
    public String home(Model model) {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();

    	System.out.println("AUTH = " + auth);
    	System.out.println("NAME = " + auth.getName());
    	System.out.println("CLASS = " + auth.getClass().getName());
        // Lấy danh sách trận đấu từ CSDL
    	List<TranDau> matches = tranDauRepository.findAllWithTeams();
        model.addAttribute("matches", matches); // Biến này khớp với ${matches} trong home.html
        return "home";
    }
    

    
}
