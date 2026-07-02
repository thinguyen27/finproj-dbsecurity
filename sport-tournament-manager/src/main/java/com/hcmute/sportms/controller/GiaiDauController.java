package com.hcmute.sportms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.hcmute.sportms.entity.GiaiDau;
import com.hcmute.sportms.service.GiaiDauService;
import com.hcmute.sportms.service.TeamService;
import com.hcmute.sportms.service.TranDauService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class GiaiDauController {
	private final GiaiDauService giaiDauService;
	private final TeamService doiThiDauService;
	private final TranDauService tranDauService;
	
	@GetMapping({"/tournament", "/tournament/list"})
	public String showTournamentList(Model model) {

	    model.addAttribute(
	            "list",
	            giaiDauService.layDanhSachGiaiDau()
	    );

	    return "/tournament/tournament-list";
	}
    
	@GetMapping("/tournament/detail/{maGiai}")
	public String showTournamentDetail(
	        @PathVariable String maGiai,
	        Model model) {

	    model.addAttribute(
	            "currentTournament",
	            giaiDauService.layGiaiDauTheoMa(maGiai));

	    model.addAttribute(
	            "teamList",
	            doiThiDauService.layDanhSachTheoGiai(maGiai));

	    model.addAttribute(
	            "matchList",
	            tranDauService.layDanhSachTranTheoGiai(maGiai));

	    return "tournament/tournament-detail";
	}
	
    @GetMapping("/tournament/add")
    public String showAddForm(Model model) {

        model.addAttribute("tournament", new GiaiDau());

        return "tournament/tournament-form";
    }

    @GetMapping("/tournament/edit/{maGiai}")
    public String showEditForm(@PathVariable String maGiai, Model model) {

        model.addAttribute(
                "tournament",
                giaiDauService.layGiaiDauTheoMa(maGiai)
        );

        return "tournament/tournament-form";
    }

    @PostMapping("/tournament/save")
    public String saveTournament(
            @ModelAttribute("tournament") GiaiDau giaiDau) {

        giaiDauService.luuGiaiDau(giaiDau);

        return "redirect:/tournament";
    }

    @PostMapping("/tournament/delete/{maGiai}")
    public String deleteTournament(
            @PathVariable String maGiai) {

        giaiDauService.xoaGiaiDau(maGiai);

        return "redirect:/tournament";
    }
}