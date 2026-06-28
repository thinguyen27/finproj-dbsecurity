package com.hcmute.sportms.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.hcmute.sportms.dto.request.PhanCongTTRequest;
import com.hcmute.sportms.dto.response.AssignmentResponse;
import com.hcmute.sportms.entity.PhanCongTT;
import com.hcmute.sportms.entity.UserInfo;
import com.hcmute.sportms.repository.PhanCongTTRepository;
import com.hcmute.sportms.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PhanCongTTService {
	private final UserRepository userRepo;
    private final PhanCongTTRepository phanCongRepo;
    public List<UserInfo> findByVaiTro(String vaiTro){
        return userRepo.findByVaiTro(vaiTro);
    }
    public List<UserInfo> getAllReferees() {
        return userRepo.findByVaiTroIgnoreCase("ROLE_TT");
    }

    public List<UserInfo> getAllSupervisors() {
        return userRepo.findByVaiTroIgnoreCase("ROLE_GS");
    }

    @Transactional
    public void saveAssignment(PhanCongTTRequest request) {

        phanCongRepo.deleteByMaTranDau(request.getMaTranDau());

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
