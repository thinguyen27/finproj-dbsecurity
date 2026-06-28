package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.request.PhanCongTTRequest;
import com.hcmute.sportms.dto.request.UpdateScoreRequest;
import com.hcmute.sportms.dto.response.MyMatchDTO;
import com.hcmute.sportms.entity.TranDau;
import com.hcmute.sportms.entity.UserInfo;
import com.hcmute.sportms.service.PhanCongTTService;
import com.hcmute.sportms.service.TranDauService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class TranDauController {

    private final TranDauService tranDauService;
    private final PhanCongTTService phanCongTTService;

    @PutMapping("/{maTranDau}/dien-bien")
    public ResponseEntity<TranDau> capNhatDienBien(
            @PathVariable String maTranDau,
            @Valid @RequestBody UpdateScoreRequest request) {
        
        TranDau response = tranDauService.capNhatDienBienTranDau(maTranDau, request);
        return ResponseEntity.ok(response);
    }
    @GetMapping({"/match"})
    public String viewMatchList(Model model) {
        model.addAttribute("matches", tranDauService.getAllMatches());
        return "/match/match-list";
    }
    
    @GetMapping("/match/result/edit/{id}")
    public String editResult(@PathVariable String id,
                             Authentication authentication,
                             Model model) {

        TranDau match = tranDauService.findById(id);

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("match", match);
        model.addAttribute("currentRole", role);

        return "/match/match-result-form";
    }


    @PostMapping("/match/result/save")
    public String saveResult(@ModelAttribute("match") TranDau match,
                             Authentication authentication) {

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        boolean allowed = authentication.getAuthorities()
                .stream()
                .anyMatch(a ->
                    a.getAuthority().equals("ROLE_BTC")
                    || a.getAuthority().equals("ROLE_TT"));

        if (!allowed) {
            return "redirect:/403";
        }
        
        if(role.equals("ROLE_TT")){

            TranDau old = tranDauService.findById(match.getMaTranDau());

            match.setKetQuaStatus(old.getKetQuaStatus());
        }

        tranDauService.updateResult(match);

        return "redirect:/match";
    }
    @GetMapping("/match/assign")
    public String assignPage(@RequestParam String maTranDau,
                             Authentication authentication,
                             Model model){

        TranDau match = tranDauService.findById(maTranDau);

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("currentMatch", match);

        model.addAttribute("referees",
                phanCongTTService.getAllReferees());

        model.addAttribute("supervisors",
                phanCongTTService.getAllSupervisors());

        model.addAttribute("assignment",
                phanCongTTService.getAssignment(maTranDau));

        model.addAttribute("currentRole", role);
        List<UserInfo> refs = phanCongTTService.getAllReferees();

        System.out.println(refs.size());
        System.out.println(refs);


        return "match/match-assign";
    }
    @PostMapping("/match/assign/save")
    public String saveAssign(@ModelAttribute PhanCongTTRequest request){

        phanCongTTService.saveAssignment(request);

        return "redirect:/match";
    }
    
    @GetMapping("/match/edit/{id}")
    public String editMatch(@PathVariable String id,
                            Authentication authentication,
                            Model model){

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        if(!role.equals("ROLE_BTC")){
            return "redirect:/403";
        }

        TranDau match = tranDauService.findById(id);

        model.addAttribute("match", match);

        model.addAttribute("teams",
                tranDauService.getAllTeams());

        model.addAttribute("stadiums",
                tranDauService.getAllStadiums());

        model.addAttribute("tournaments",
                tranDauService.getAllTournaments());

        model.addAttribute("currentRole", role);

        return "match/match-form";
    }
    @PostMapping("/match/save")
    public String saveMatch(@ModelAttribute TranDau match){

        tranDauService.save(match);

        return "redirect:/match";
    }
    @PostMapping("/match/delete/{id}")
    public String deleteMatch(@PathVariable String id,
                              Authentication authentication){

        if(authentication.getAuthorities()
                .stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_BTC"))){

            return "redirect:/403";
        }

        tranDauService.delete(id);

        return "redirect:/match";
    }
    @GetMapping("/match/add")
    public String addMatch(Authentication authentication,
                           Model model){

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        if(!role.equals("ROLE_BTC")){
            return "redirect:/403";
        }

        model.addAttribute("match", new TranDau());

        model.addAttribute("teams",
                tranDauService.getAllTeams());

        model.addAttribute("stadiums",
                tranDauService.getAllStadiums());

        model.addAttribute("tournaments",
                tranDauService.getAllTournaments());

        model.addAttribute("currentRole", role);

        return "match/match-form";
    }
    @GetMapping("/match/my-matches")
    public String getMyMatches(Authentication authentication, HttpSession session, Model model) {
        
        // 1. Kiểm tra quyền hạn (Chỉ cho phép Trọng tài truy cập)
        String currentRole = authentication.getAuthorities().iterator().next().getAuthority();
        if (!"ROLE_TT".equals(currentRole)) {
            return "error/403"; 
        }

        // 2. Lấy tên tài khoản trọng tài đang đăng nhập
        String username = authentication.getName(); 
        
        // Gán session username nếu frontend yêu cầu hiển thị th:text="${session.username}"
        if (session.getAttribute("username") == null) {
            session.setAttribute("username", username);
        }

        // 3. Lấy dữ liệu lịch phân công
        List<MyMatchDTO> myMatches = tranDauService.getMatchesForReferee(username);
        
        // 4. Đẩy sang view Thymeleaf
        model.addAttribute("myMatches", myMatches);

        return "match/my-matches"; 
    }
    
}