package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.request.CreateThanhVienRequest;
import com.hcmute.sportms.entity.ThanhVienDoi;
import com.hcmute.sportms.service.TeamService;
import com.hcmute.sportms.service.ThanhVienService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/team")
@RequiredArgsConstructor
public class ThanhVienController {

    private final ThanhVienService thanhVienService;
    private final TeamService teamService;
    @GetMapping("/detail/{maDoi}")
    public String viewTeamMembers(@PathVariable String maDoi, Model model) {

        model.addAttribute("currentTeam", teamService.findById(maDoi));

        model.addAttribute("memberList",
                thanhVienService.layDanhSachThanhVienCuaDoi(maDoi));

        return "team/team-detail";
    }
    @GetMapping
    public ResponseEntity<List<ThanhVienDoi>> layDanhSachThanhVien() {
        return ResponseEntity.ok(thanhVienService.layDanhSachThanhVien());
    }

    @PostMapping
    public ResponseEntity<ThanhVienDoi> themMoiThanhVien(@Valid @RequestBody CreateThanhVienRequest request) {
        ThanhVienDoi response = thanhVienService.themMoiThanhVien(request);
        return ResponseEntity.ok(response);
    }
}