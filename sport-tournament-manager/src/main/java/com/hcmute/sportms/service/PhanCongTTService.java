package com.hcmute.sportms.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
// SỬ DỤNG TRANSACTION CỦA SPRING ĐỂ HỖ TRỢ readOnly VÀ AOP TỐT NHẤT
import org.springframework.transaction.annotation.Transactional;

import com.hcmute.sportms.dto.request.PhanCongTTRequest;
import com.hcmute.sportms.dto.response.AssignmentResponse;
import com.hcmute.sportms.entity.PhanCongTT;
import com.hcmute.sportms.entity.UserInfo;
import com.hcmute.sportms.repository.PhanCongTTRepository;
import com.hcmute.sportms.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PhanCongTTService {
    private final UserRepository userRepo;
    private final PhanCongTTRepository phanCongRepo;
    
    @Transactional(readOnly = true)
    public List<UserInfo> findByVaiTro(String vaiTro){
        return userRepo.findByVaiTro(vaiTro);
    }
    
    @Transactional(readOnly = true)
    public List<UserInfo> getAllReferees() {
        return userRepo.findByVaiTroIgnoreCase("ROLE_TT");
    }

    @Transactional(readOnly = true)
    public List<UserInfo> getAllSupervisors() {
        return userRepo.findByVaiTroIgnoreCase("ROLE_GS");
    }

    @Transactional
    public void saveAssignment(PhanCongTTRequest request) {
        // 1. Kiểm tra 1 người không được làm nhiều vị trí trong 1 trận đấu
        Set<String> uniqueUsers = new HashSet<>();
        uniqueUsers.add(request.getMainReferee());
        uniqueUsers.add(request.getAssistant1());
        uniqueUsers.add(request.getAssistant2());
        uniqueUsers.add(request.getVarReferee());
        uniqueUsers.add(request.getSupervisor());
        
        if (uniqueUsers.size() < 5) {
            throw new RuntimeException("Lỗi: Một người không thể đảm nhận nhiều vai trò trong cùng một trận đấu!");
        }

        // 2. Xóa các phân công cũ (Đã được cấu hình @Modifying bên Repository để chạy ngay lập tức)
        phanCongRepo.deleteByMaTranDau(request.getMaTranDau());

        // 3. Phân công mới
        save(request.getMaTranDau(), request.getMainReferee(), "MAIN_REFEREE");
        save(request.getMaTranDau(), request.getAssistant1(), "ASSISTANT_1");
        save(request.getMaTranDau(), request.getAssistant2(), "ASSISTANT_2");
        save(request.getMaTranDau(), request.getVarReferee(), "VAR");
        save(request.getMaTranDau(), request.getSupervisor(), "SUPERVISOR");
    }

    private void save(String maTranDau, String username, String role){
        PhanCongTT pc = new PhanCongTT();
        pc.setMaTranDau(maTranDau);
        pc.setUsername(username);
        pc.setVaiTroTranDau(role);
        phanCongRepo.save(pc);
    }
    
    // THÊM TRANSACTIONAL VÀO ĐÂY ĐỂ ĐÁNH THỨC ORACLE VPD
    @Transactional(readOnly = true)
    public AssignmentResponse getAssignment(String maTranDau) {
        List<PhanCongTT> list = phanCongRepo.findByMaTranDau(maTranDau);
        AssignmentResponse response = new AssignmentResponse();

        for(PhanCongTT pc : list){
            switch (pc.getVaiTroTranDau()){
                case "MAIN_REFEREE":
                    response.setMainReferee(pc.getUsername());
                    break;
                case "ASSISTANT_1":
                    response.setAssistant1(pc.getUsername());
                    break;
                case "ASSISTANT_2":
                    response.setAssistant2(pc.getUsername());
                    break;
                case "VAR":
                    response.setVarReferee(pc.getUsername());
                    break;
                case "SUPERVISOR":
                    response.setSupervisor(pc.getUsername());
                    break;
            }
        }
        return response;
    }
}