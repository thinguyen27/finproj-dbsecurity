package com.hcmute.sportms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hcmute.sportms.entity.DoiThiDau;
import com.hcmute.sportms.service.GiaiDauService;
import com.hcmute.sportms.service.TeamService;
import com.hcmute.sportms.service.TranDauService;
import com.hcmute.sportms.service.UserService;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Controller
@Data
@RequestMapping("/team")
@RequiredArgsConstructor
public class TeamController {

    private final TeamService teamService;
    private final TranDauService tranDauService;
    private final GiaiDauService giaiDauService;
    private final UserService userService;

    @GetMapping("/list")
    public String showList(Model model) {
        model.addAttribute("teams", teamService.getAllTeams());
        return "team/team-list";
    }    
    @GetMapping("/match")
    public String teamMatches(
            @RequestParam String maDoi,
            Model model){

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
    @GetMapping("/add/{maGiai}")
    public String showAddTeamForm(
            @PathVariable String maGiai,
            Model model) {

        DoiThiDau team = new DoiThiDau();

        team.setGiaiDau(
                giaiDauService.layGiaiDauTheoMa(maGiai));

        model.addAttribute("team", team);

        model.addAttribute(
                "users",
                userService.getTruongDoan()
        );

        return "team/team-form";
    }
    @GetMapping("/edit/{maDoi}")
    public String showEditForm(@PathVariable String maDoi,
                               Model model) {

        DoiThiDau team = teamService.findById(maDoi);

        model.addAttribute("team", team);
        model.addAttribute("users", userService.getTruongDoan());

        return "team/team-form";
    }
    @GetMapping("/delete/{maDoi}")
    public String deleteTeam(@PathVariable String maDoi) {

        teamService.delete(maDoi);

        return "redirect:/team/list";
    }
    @PostMapping("/save")
    public String saveTeam(
            @ModelAttribute DoiThiDau team){

        teamService.save(team);

        return "redirect:/tournament/detail/" 
               + team.getGiaiDau().getMaGiai();
    }
    
}
