package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.request.UpdateScoreRequest;
import com.hcmute.sportms.dto.response.MyMatchDTO;
import com.hcmute.sportms.entity.DoiThiDau;
import com.hcmute.sportms.entity.GiaiDau;
import com.hcmute.sportms.entity.SanThiDau;
import com.hcmute.sportms.entity.TranDau;
import com.hcmute.sportms.entity.VTranDau;
import com.hcmute.sportms.repository.GiaiDauRepository;
import com.hcmute.sportms.repository.SanThiDauRepository;
import com.hcmute.sportms.repository.TeamRepository;
import com.hcmute.sportms.repository.TranDauRepository;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TranDauService {

    private final TranDauRepository tranDauRepository;
    private final TeamRepository doiThiDauRepository;
    private final SanThiDauRepository sanRepository;
    private final GiaiDauRepository giaiDauRepository;
    @Transactional
    public TranDau capNhatDienBienTranDau(String maTranDau, UpdateScoreRequest request) {
        // 1. Kiểm tra trận đấu có tồn tại không
        TranDau tranDau = tranDauRepository.findById(maTranDau)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trận đấu với mã: " + maTranDau));

        // 2. Business Logic: Chỉ cho phép cập nhật khi trận đấu đang diễn ra
        if (!"PLAYING".equals(tranDau.getTrangThaiTran())) {
            throw new RuntimeException("Chỉ có thể cập nhật tỷ số khi trận đấu đang diễn ra (PLAYING)!");
        }

        // 3. Cập nhật các thông số
        tranDau.setTySoDoiA(request.getTySoDoiA());
        tranDau.setTySoDoiB(request.getTySoDoiB());
        
        if (request.getTheVangDoiA() != null) tranDau.setTheVangDoiA(request.getTheVangDoiA());
        if (request.getTheVangDoiB() != null) tranDau.setTheVangDoiB(request.getTheVangDoiB());
        if (request.getTheDoDoiA() != null) tranDau.setTheDoDoiA(request.getTheDoDoiA());
        if (request.getTheDoDoiB() != null) tranDau.setTheDoDoiB(request.getTheDoDoiB());

        // 4. Lưu xuống DB. AOP + OLS/VPD sẽ chặn nếu Trọng tài này không được phân công bắt trận này.
        return tranDauRepository.save(tranDau);
    }

    @Transactional(readOnly = true)
    public List<TranDau> getAllMatches() {
        return tranDauRepository.findByIsDeleted("N");
    }
    
    public List<VTranDau> getUpcomingMatches(String maDoi){
        return tranDauRepository.findUpcomingByTeam(maDoi);
    }

    public List<VTranDau> getPastMatches(String maDoi){
        return tranDauRepository.findPastByTeam(maDoi);
    }
    public List<TranDau> layDanhSachTranTheoGiai(String maGiai) {
        return tranDauRepository.findByMaGiai(maGiai);
    }
    public TranDau findById(String maTranDau) {

        return tranDauRepository.findById(maTranDau)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trận đấu"));
    }

    public void updateResult(TranDau match) {

        TranDau old = tranDauRepository.findById(match.getMaTranDau())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trận đấu"));

        old.setTySoDoiA(match.getTySoDoiA());
        old.setTySoDoiB(match.getTySoDoiB());

        old.setTheVangDoiA(match.getTheVangDoiA());
        old.setTheDoDoiA(match.getTheDoDoiA());

        old.setTheVangDoiB(match.getTheVangDoiB());
        old.setTheDoDoiB(match.getTheDoDoiB());

        old.setTrangThaiTran(match.getTrangThaiTran());

        old.setKetQuaStatus(match.getKetQuaStatus());

        tranDauRepository.save(old);
    }
    @Transactional
    public void save(TranDau match){
    	if (match.getMaDoiA() != null
    	        && match.getMaDoiB() != null
    	        && match.getMaDoiA().equals(match.getMaDoiB())) {

    	    throw new RuntimeException("Hai đội không được trùng nhau.");
    	}
    	if (match.getMaTranDau() == null || match.getMaTranDau().isBlank()) {

    	    match.setMaTranDau(generateMatchCode());

    	    tranDauRepository.save(match);

        }else{

            TranDau old =
                    tranDauRepository.findById(match.getMaTranDau())
                    .orElseThrow();

            old.setMaGiai(match.getMaGiai());
            old.setMaDoiA(match.getMaDoiA());
            old.setMaDoiB(match.getMaDoiB());
            old.setMaSan(match.getMaSan());
            old.setNgayGioThiDau(match.getNgayGioThiDau());
            old.setVongDau(match.getVongDau());

            tranDauRepository.save(old);
        }
    }
    @Transactional
    public void delete(String id){

        TranDau match = tranDauRepository.findById(id)
                .orElseThrow();

        match.setIsDeleted("Y");

        tranDauRepository.save(match);

    }
    public List<DoiThiDau> getAllTeams(){
        return doiThiDauRepository.findAll();
    }

    public List<SanThiDau> getAllStadiums(){
        return sanRepository.findAll();
    }

    public List<GiaiDau> getAllTournaments(){
        return giaiDauRepository.findAll();
    }
    private String generateMatchCode() {

        String maxCode = tranDauRepository.findMaxMatchCode();

        if (maxCode == null) {
            return "TD01";
        }

        int number = Integer.parseInt(maxCode.substring(2));

        number++;

        return String.format("TD%02d", number);
    }
    
    public List<MyMatchDTO> getMatchesForReferee(String username) {
        List<Object[]> results = tranDauRepository.findMatchesByRefereeUsername(username);
        
        return results.stream().map(row -> MyMatchDTO.builder()
                .maTranDau((String) row[0])
                .maDoiA((String) row[1])
                .maDoiB((String) row[2])
                .tySoDoiA(row[3] != null ? ((Number) row[3]).intValue() : 0)
                .tySoDoiB(row[4] != null ? ((Number) row[4]).intValue() : 0)
                .trangThaiTran((String) row[5])
                .ngayGioThiDau(row[6] != null ? row[6].toString() : "")
                .vongDau(row[7] != null ? ((Number) row[7]).intValue() : 1)
                .build()
        ).collect(Collectors.toList());
    }
}