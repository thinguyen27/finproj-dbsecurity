package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hcmute.sportms.entity.UserInfo;
import com.hcmute.sportms.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;
    @GetMapping("")
    public String list(Authentication authentication,
                       Model model){

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("users",
                userService.findAll());

        model.addAttribute("currentRole", role);

        return "user/user-list";
    }
    @GetMapping("/add")
    public String addUser(Authentication authentication,
                          Model model) {

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("currentRole", role);

        model.addAttribute("user", new UserInfo());

        model.addAttribute("teams", userService.getAllTeams());

        return "user/add-user";
    }
    @GetMapping("/edit/{username}")
    public String editUser(@PathVariable String username,
                           Authentication authentication,
                           Model model){

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("currentRole", role);

        model.addAttribute("user",
                userService.findById(username));

        model.addAttribute("teams",
                userService.getAllTeams());

        return "/user/add-user";
    }
    @PostMapping("/save")
    public String save(@ModelAttribute UserInfo user){

        userService.save(user);

        return "redirect:/user";

    }
    @PostMapping("/delete/{username}")
    public String delete(@PathVariable String username){

        userService.delete(username);

        return "redirect:/user";

    }
}
