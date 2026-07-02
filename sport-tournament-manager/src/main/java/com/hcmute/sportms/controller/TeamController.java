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

        model.addAttribute("currentTeam", teamService.findById(maDoi));
        model.addAttribute("memberList", thanhVienService.layDanhSachThanhVienCuaDoi(maDoi));

        return "team/team-detail";
    }

    /**
     * Danh sách trận đấu của đội
     */
    @GetMapping("/match")
    public String teamMatches(
            @RequestParam String maDoi,
            Model model) {

        model.addAttribute("currentTeam", teamService.findById(maDoi));
        model.addAttribute("upcomingMatches", tranDauService.getUpcomingMatches(maDoi));
        model.addAttribute("pastMatches", tranDauService.getPastMatches(maDoi));

        return "team/team-match";
    }

    /**
     * Form thêm đội (Hỗ trợ cả trường hợp CÓ và KHÔNG CÓ mã giải đấu truyền vào)
     */
    @GetMapping({"/add", "/add/{maGiai}"})
    public String showAddTeamForm(
            @PathVariable(required = false) String maGiai,
            Model model) {

        DoiThiDau team = new DoiThiDau();

        if (maGiai != null && !maGiai.isEmpty()) {
            // Trường hợp 1: Có mã giải trên URL -> Gắn sẵn giải đấu cho đội
            team.setGiaiDau(giaiDauService.layGiaiDauTheoMa(maGiai));
        } else {
            // Trường hợp 2: Truy cập /team/add -> Trả về toàn bộ danh sách giải đấu để người dùng tự chọn
            model.addAttribute("tournaments", giaiDauService.layDanhSachGiaiDau());
        }

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

        model.addAttribute("team", teamService.findById(maDoi));
        // Khi sửa đội cũng có thể cần danh sách giải đấu nếu bạn cho phép đổi giải
        model.addAttribute("tournaments", giaiDauService.layDanhSachGiaiDau());
        model.addAttribute("users", userService.getTruongDoan());

        return "team/team-form";
    }

    /**
     * Lưu đội
     */
    @PostMapping("/save")
    public String saveTeam(@ModelAttribute DoiThiDau team) {
        
        // KIỂM TRA BẮT BUỘC: Database quy định cột MaGiai là NOT NULL.
        // Chặn ngay từ Controller nếu người dùng quên chọn Giải Đấu trên Form.
        if (team.getGiaiDau() == null || 
            team.getGiaiDau().getMaGiai() == null || 
            team.getGiaiDau().getMaGiai().trim().isEmpty()) {
            
            // Ném ra thông báo lỗi để nhắc nhở
            throw new IllegalArgumentException("THAO TÁC LỖI: Bắt buộc phải chọn một Giải Đấu cho đội bóng (Không được để trống)!");
        }

        // Sau khi đã chắc chắn có mã giải đấu, thực hiện lưu bình thường
        teamService.save(team);

        // Chuyển hướng về trang chi tiết của giải đấu đó
        return "redirect:/tournament/detail/" + team.getGiaiDau().getMaGiai();
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