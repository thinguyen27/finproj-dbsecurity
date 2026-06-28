package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.request.CreateThanhVienRequest;
import com.hcmute.sportms.entity.ThanhVienDoi;
import com.hcmute.sportms.repository.ThanhVienDoiRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhVienService {

    private final ThanhVienDoiRepository thanhVienRepository;

    // Lấy danh sách thành viên. 
    // Nhờ VPD, hàm findAll() này sẽ CHỈ trả về dữ liệu của đội mà Trưởng đoàn đang quản lý.
    @Transactional(readOnly = true)
    public List<ThanhVienDoi> layDanhSachThanhVien() {
        return thanhVienRepository.findAll();
    }

    // Thêm mới thành viên
    @Transactional
    public ThanhVienDoi themMoiThanhVien(CreateThanhVienRequest request) {
        ThanhVienDoi vdv = new ThanhVienDoi();
        // Cấp mã ngẫu nhiên (hoặc bạn có thể tự viết logic tự tăng)
        vdv.setMaThanhVien("VDV-" + UUID.randomUUID().toString().substring(0, 15)); 
        vdv.setMaDoi(request.getMaDoi());
        vdv.setTenThanhVien(request.getTenThanhVien());
        vdv.setLoaiThanhVien(request.getLoaiThanhVien());
        vdv.setNgaySinh(request.getNgaySinh());
        vdv.setGioiTinh(request.getGioiTinh());
        vdv.setSoAo(request.getSoAo());
        vdv.setCccd(request.getCccd());
        vdv.setSoDienThoai(request.getSoDienThoai());
        vdv.setEmailThanhVien(request.getEmailThanhVien());
        vdv.setThongTinSucKhoe(request.getThongTinSucKhoe());
        
        // Mặc định cho OLS Label (có thể để null cho CSDL tự trigger hoặc set mặc định)
        vdv.setOlsLabel(100); // Ví dụ: 100 là mức PUBLIC

        // Lưu xuống DB. Nếu maDoi không khớp với Context, CSDL sẽ tự văng lỗi.
        return thanhVienRepository.save(vdv);
    }
    
    @Transactional(readOnly = true) // Aspect sẽ nạp Context tại đây
    public List<ThanhVienDoi> layDanhSachThanhVienCuaDoi(String maDoi) {
        return thanhVienRepository.findByMaDoi(maDoi);
    }
}