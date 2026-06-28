package com.hcmute.sportms.controller;

import com.hcmute.sportms.entity.SanThiDau;
import com.hcmute.sportms.service.SanThiDauService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class SanThiDauController {

    private final SanThiDauService sanThiDauService;
    private String getCurrentRole() {
        var auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated()
                || auth.getAuthorities() == null
                || auth.getAuthorities().isEmpty()) {
            return "ANONYMOUS";
        }

        return auth.getAuthorities()
                .stream()
                .findFirst()
                .map(GrantedAuthority::getAuthority)
                .orElse("ANONYMOUS");
    }
    @GetMapping("/stadium")
    public String listStadium(Model model) {

        String role = getCurrentRole();

        model.addAttribute("stadiums", sanThiDauService.getAllStadiums());
        model.addAttribute("currentRole", role);

        return "stadium/stadium-list";
    }

    @GetMapping("/stadium/add")
    public String addStadium(Model model){

        String role = getCurrentRole();

        if(!"ROLE_BTC".equals(role)){
            return "redirect:/403";
        }

        model.addAttribute("stadium", new SanThiDau());
        model.addAttribute("currentRole", role);

        return "stadium/stadium-form";
    }

    @GetMapping("/stadium/edit/{maSan}")
    public String editStadium(@PathVariable String maSan, Model model){

        String role = getCurrentRole();

        if(!"ROLE_BTC".equals(role)){
            return "redirect:/403";
        }

        model.addAttribute("stadium",
                sanThiDauService.findById(maSan));

        model.addAttribute("currentRole", role);

        return "stadium/stadium-form";
    }

    @PostMapping("/stadium/save")
    public String saveStadium(@ModelAttribute("stadium") SanThiDau stadium){

        sanThiDauService.save(stadium);

        return "redirect:/stadium";
    }

    @PostMapping("/stadium/delete/{maSan}")
    public String deleteStadium(@PathVariable String maSan){

        String role = getCurrentRole();

        if(!"ROLE_BTC".equals(role)){
            return "redirect:/403";
        }

        sanThiDauService.delete(maSan);

        return "redirect:/stadium";
    }
}