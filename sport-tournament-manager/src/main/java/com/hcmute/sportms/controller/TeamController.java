package com.hcmute.sportms.controller;

import com.hcmute.sportms.entity.DoiThiDau;
import com.hcmute.sportms.service.GiaiDauService;
import com.hcmute.sportms.service.TeamService;
import com.hcmute.sportms.service.ThanhVienService;
import com.hcmute.sportms.service.TranDauService;
import com.hcmute.sportms.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/team")
@RequiredArgsConstructor
public class TeamController {

    private final TeamService teamService;
    private final TranDauService tranDauService;
    private final GiaiDauService giaiDauService;
    private final UserService userService;
    private final ThanhVienService thanhVienService;
    /**
     * Danh sách đội
     */
    @GetMapping("/list")
    public String showList(Model model) {

        model.addAttribute("teams", teamService.getAllTeams());

        return "team/team-list";
    }

    /**
     * Hiển thị danh sách thành viên của đội
     */
    @GetMapping("/detail/{maDoi}")
    public String viewTeamMembers(
            @PathVariable String maDoi,
            Model model) {

        model.addAttribute(
                "currentTeam",
                teamService.findById(maDoi));

        model.addAttribute(
                "memberList",
                thanhVienService.layDanhSachThanhVienCuaDoi(maDoi));

        return "team/team-detail";
    }

    /**
     * Danh sách trận đấu của đội
     */
    @GetMapping("/match")
    public String teamMatches(
            @RequestParam String maDoi,
            Model model) {

        model.addAttribute(
                "currentTeam",
                teamService.findById(maDoi));

        model.addAttribute(
                "upcomingMatches",
                tranDauService.getUpcomingMatches(maDoi));

        model.addAttribute(
                "pastMatches",
                tranDauService.getPastMatches(maDoi));

        return "team/team-match";
    }

    /**
     * Form thêm đội
     */
    @GetMapping("/add/{maGiai}")
    public String showAddTeamForm(
            @PathVariable String maGiai,
            Model model) {

        DoiThiDau team = new DoiThiDau();

        team.setGiaiDau(
                giaiDauService.layGiaiDauTheoMa(maGiai));

        model.addAttribute("team", team);
        model.addAttribute("users", userService.getTruongDoan());

        return "team/team-form";
    }

    /**
     * Form sửa đội
     */
    @GetMapping("/edit/{maDoi}")
    public String showEditForm(
            @PathVariable String maDoi,
            Model model) {

        model.addAttribute(
                "team",
                teamService.findById(maDoi));

        model.addAttribute(
                "users",
                userService.getTruongDoan());

        return "team/team-form";
    }

    /**
     * Lưu đội
     */
    @PostMapping("/save")
    public String saveTeam(
            @ModelAttribute DoiThiDau team) {

        teamService.save(team);

        return "redirect:/tournament/detail/"
                + team.getGiaiDau().getMaGiai();
    }

    /**
     * Xóa đội
     */
    @GetMapping("/delete/{maDoi}")
    public String deleteTeam(
            @PathVariable String maDoi) {

        teamService.delete(maDoi);

        return "redirect:/team/list";
    }

}