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
@RequestMapping("/team/member")
@RequiredArgsConstructor
public class ThanhVienController {

    private final ThanhVienService thanhVienService;
    private final TeamService teamService;


    /**
     * API lấy tất cả thành viên
     */
    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<List<ThanhVienDoi>> getAllMembers() {

        return ResponseEntity.ok(
                thanhVienService.layDanhSachThanhVien());
    }

    /**
     * Form thêm thành viên
     */
    @GetMapping("/add")
    public String showAddMemberForm(
            @RequestParam String maDoi,
            Model model) {

        CreateThanhVienRequest request = new CreateThanhVienRequest();
        request.setMaDoi(maDoi);

        model.addAttribute("member", request);

        model.addAttribute(
                "currentTeam",
                teamService.findById(maDoi));

        return "team/player-form";
    }

    /**
     * Form sửa thành viên
     */
    @GetMapping("/edit/{id}")
    public String showEditMemberForm(
            @PathVariable String id,
            Model model) {

        ThanhVienDoi member =
                thanhVienService.findById(id);

        CreateThanhVienRequest request =
                new CreateThanhVienRequest();

        request.setMaThanhVien(member.getMaThanhVien());
        request.setMaDoi(member.getMaDoi());
        request.setTenThanhVien(member.getTenThanhVien());
        request.setNgaySinh(member.getNgaySinh());
        request.setGioiTinh(member.getGioiTinh());
        request.setLoaiThanhVien(member.getLoaiThanhVien());
        request.setSoAo(member.getSoAo());
        request.setCccd(member.getCccd());
        request.setSoDienThoai(member.getSoDienThoai());
        request.setEmailThanhVien(member.getEmailThanhVien());
        request.setThongTinSucKhoe(member.getThongTinSucKhoe());

        model.addAttribute("member", request);

        model.addAttribute(
                "currentTeam",
                teamService.findById(member.getMaDoi()));

        return "team/player-form";
    }

    /**
     * Lưu thành viên
     */
    @PostMapping("/save")
    public String saveMember(
            @Valid @ModelAttribute("member")
            CreateThanhVienRequest request) {

        if (request.getMaThanhVien() == null
                || request.getMaThanhVien().isBlank()) {

            thanhVienService.themMoiThanhVien(request);

        } else {

            thanhVienService.capNhatThanhVien(request);
        }

        return "redirect:/team/detail/" + request.getMaDoi();
    }

    /**
     * Xóa thành viên
     */
    @GetMapping("/delete/{id}")
    public String deleteMember(
            @PathVariable String id) {

        ThanhVienDoi member =
                thanhVienService.findById(id);

        String maDoi = member.getMaDoi();

        thanhVienService.delete(id);

        return "redirect:/team/detail/" + maDoi;
    }

    /**
     * API thêm thành viên
     */
    @PostMapping("/api")
    @ResponseBody
    public ResponseEntity<ThanhVienDoi> createMember(
            @Valid @RequestBody CreateThanhVienRequest request) {

        return ResponseEntity.ok(
                thanhVienService.themMoiThanhVien(request));
    }

}