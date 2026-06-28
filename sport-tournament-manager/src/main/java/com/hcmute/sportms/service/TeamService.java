package com.hcmute.sportms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hcmute.sportms.entity.DoiThiDau;
import com.hcmute.sportms.repository.TeamRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TeamService {
    private final TeamRepository teamRepository;

    @Transactional(readOnly = true)
    public List<DoiThiDau> getAllTeams() {
        // VPD trong Oracle sẽ tự động thêm điều kiện lọc vào câu SELECT này
        // dựa trên ngữ cảnh (CONTEXT) của người dùng.
        return teamRepository.findAll();
    }

	public DoiThiDau getTeamById(String maDoi) {
		return teamRepository.findById(maDoi).orElseThrow();
	}

    public List<DoiThiDau> findAll() {
        return teamRepository.findAll();
    }

    public DoiThiDau findById(String maDoi) {
        return teamRepository.findById(maDoi)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy đội " + maDoi));
    }
    public List<DoiThiDau> layDanhSachTheoGiai(String maGiai){
        return teamRepository.findByGiaiDau_MaGiai(maGiai);
    }
    public DoiThiDau save(DoiThiDau team){

        // nếu thêm mới
        if(team.getMaDoi() == null || team.getMaDoi().isBlank()){
            String maMoi = "D" + System.currentTimeMillis();
            team.setMaDoi(maMoi);
        }

        return teamRepository.save(team);
    }
    @Transactional
    public void delete(String maDoi) {

        DoiThiDau team = teamRepository.findById(maDoi)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đội"));

        teamRepository.delete(team);
    }
}
