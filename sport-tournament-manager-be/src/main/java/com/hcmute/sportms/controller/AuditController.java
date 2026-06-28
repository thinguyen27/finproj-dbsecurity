package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.response.AuditLogResponse;
import com.hcmute.sportms.service.AuditService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Controller
@RequestMapping("/audit")
@RequiredArgsConstructor
public class AuditController {
    private final AuditService auditService;

    @GetMapping("/logs")
    @ResponseBody // THÊM Ở ĐÂY: Báo cho Spring biết hàm này trả về JSON API, không phải HTML
    public ResponseEntity<List<AuditLogResponse>> getAuditLogs() {
        return ResponseEntity.ok(auditService.getParsedAuditLogs());
    }


    @GetMapping("")
    public String dashboard(Authentication authentication, Model model) {

        String role = authentication.getAuthorities()
                .iterator()
                .next()
                .getAuthority();

        model.addAttribute("currentRole", role);

        model.addAttribute("auditLogs", auditService.getLatestLogs());
        model.addAttribute("actionStats", auditService.getActionStats());
        model.addAttribute("objectStats", auditService.getObjectStats());
        model.addAttribute("timelineStats", auditService.getTimelineStats());

        return "audit/audit-dashboard";
    }
}