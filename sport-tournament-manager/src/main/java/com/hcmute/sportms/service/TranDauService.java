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
    
    // Đã bổ sung Transactional để tránh lỗi rỗng Context
    @Transactional(readOnly = true)
    public List<VTranDau> getUpcomingMatches(String maDoi){
        return tranDauRepository.findUpcomingByTeam(maDoi);
    }

    // Đã bổ sung Transactional để tránh lỗi rỗng Context
    @Transactional(readOnly = true)
    public List<VTranDau> getPastMatches(String maDoi){
        return tranDauRepository.findPastByTeam(maDoi);
    }

    // Đã bổ sung Transactional để tránh lỗi rỗng Context
    @Transactional(readOnly = true)
    public List<TranDau> layDanhSachTranTheoGiai(String maGiai) {
        return tranDauRepository.findByMaGiai(maGiai);
    }

    // Đã bổ sung Transactional để tránh lỗi rỗng Context khi tìm kiếm
    @Transactional(readOnly = true)
    public TranDau findById(String maTranDau) {
        return tranDauRepository.findById(maTranDau)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trận đấu"));
    }

    @Transactional
    public void updateResult(TranDau match) {
        TranDau old = tranDauRepository.findById(match.getMaTranDau())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trận đấu"));

        if (match.getTySoDoiA() != null) old.setTySoDoiA(match.getTySoDoiA());
        if (match.getTySoDoiB() != null) old.setTySoDoiB(match.getTySoDoiB());
        if (match.getTheVangDoiA() != null) old.setTheVangDoiA(match.getTheVangDoiA());
        if (match.getTheDoDoiA() != null) old.setTheDoDoiA(match.getTheDoDoiA());
        if (match.getTheVangDoiB() != null) old.setTheVangDoiB(match.getTheVangDoiB());
        if (match.getTheDoDoiB() != null) old.setTheDoDoiB(match.getTheDoDoiB());
        if (match.getTrangThaiTran() != null) old.setTrangThaiTran(match.getTrangThaiTran());
        if (match.getKetQuaStatus() != null) old.setKetQuaStatus(match.getKetQuaStatus());

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
        } else {
            TranDau old = tranDauRepository.findById(match.getMaTranDau()).orElseThrow();
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
        TranDau match = tranDauRepository.findById(id).orElseThrow();
        match.setIsDeleted("Y");
        tranDauRepository.save(match);
    }

    @Transactional(readOnly = true)
    public List<DoiThiDau> getAllTeams(){
        return doiThiDauRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<SanThiDau> getAllStadiums(){
        return sanRepository.findAll();
    }

    @Transactional(readOnly = true)
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
    
    @Transactional(readOnly = true)
    public List<MyMatchDTO> getMatchesForReferee(String username) {

        List<Object[]> results =
                tranDauRepository.findMatchesByRefereeUsername(username);

        return results.stream().map(row -> MyMatchDTO.builder()

                .maTranDau((String) row[0])

                .maDoiA((String) row[1])
                .maDoiB((String) row[2])

                .tenDoiA((String) row[3])
                .tenDoiB((String) row[4])

                .tySoDoiA(row[5] != null ? ((Number) row[5]).intValue() : 0)
                .tySoDoiB(row[6] != null ? ((Number) row[6]).intValue() : 0)

                .trangThaiTran((String) row[7])

                .ngayGioThiDau(row[8] != null ? row[8].toString() : "")

                .vongDau(row[9] != null ? ((Number) row[9]).intValue() : 1)

                .build())

                .collect(Collectors.toList());
    }
}