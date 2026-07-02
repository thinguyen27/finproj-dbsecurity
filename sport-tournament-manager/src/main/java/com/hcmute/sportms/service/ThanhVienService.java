package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.request.CreateThanhVienRequest;
import com.hcmute.sportms.entity.ThanhVienDoi;
import com.hcmute.sportms.repository.ThanhVienDoiRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhVienService {

    private final ThanhVienDoiRepository thanhVienRepository;

    /**
     * Lấy toàn bộ thành viên.
     * VPD sẽ tự lọc dữ liệu theo Context.
     */
    @Transactional(readOnly = true)
    public List<ThanhVienDoi> layDanhSachThanhVien() {
        return thanhVienRepository.findAll();
    }

    /**
     * Lấy danh sách thành viên của một đội.
     */
    @Transactional(readOnly = true)
    public List<ThanhVienDoi> layDanhSachThanhVienCuaDoi(String maDoi) {
        return thanhVienRepository.findByMaDoi(maDoi);
    }

    /**
     * Tìm thành viên theo mã.
     */
    @Transactional(readOnly = true)
    public ThanhVienDoi findById(String maThanhVien) {

        return thanhVienRepository.findById(maThanhVien)
                .orElseThrow(() ->
                        new EntityNotFoundException(
                                "Không tìm thấy thành viên: " + maThanhVien));
    }

    /**
     * Thêm mới thành viên.
     */
    @Transactional
    public ThanhVienDoi themMoiThanhVien(CreateThanhVienRequest request) {

        ThanhVienDoi tv = new ThanhVienDoi();

        String lastId = thanhVienRepository.findLastMemberId(request.getMaDoi());

        int next = 1;

        if (lastId != null) {
            next = Integer.parseInt(lastId.substring(lastId.lastIndexOf("_") + 1)) + 1;
        }

        String ma = String.format("TV_%s_%02d", request.getMaDoi(), next);

        tv.setMaThanhVien(ma);

        tv.setMaDoi(request.getMaDoi());
        tv.setTenThanhVien(request.getTenThanhVien());
        tv.setLoaiThanhVien(request.getLoaiThanhVien());
        tv.setNgaySinh(request.getNgaySinh());
        tv.setGioiTinh(request.getGioiTinh());
        tv.setSoAo(request.getSoAo());
        tv.setCccd(request.getCccd());
        tv.setSoDienThoai(request.getSoDienThoai());
        tv.setEmailThanhVien(request.getEmailThanhVien());
        tv.setThongTinSucKhoe(request.getThongTinSucKhoe());

        // Đã xóa bỏ phần tv.setOlsLabel(100); vì bảng THANH_VIEN_DOI không có cột này

        return thanhVienRepository.save(tv);
    }

    /**
     * Cập nhật thành viên.
     */
    @Transactional
    public ThanhVienDoi capNhatThanhVien(CreateThanhVienRequest request) {

        ThanhVienDoi tv = findById(request.getMaThanhVien());

        tv.setMaDoi(request.getMaDoi());
        tv.setTenThanhVien(request.getTenThanhVien());
        tv.setLoaiThanhVien(request.getLoaiThanhVien());
        tv.setNgaySinh(request.getNgaySinh());
        tv.setGioiTinh(request.getGioiTinh());
        tv.setSoAo(request.getSoAo());
        tv.setCccd(request.getCccd());
        tv.setSoDienThoai(request.getSoDienThoai());
        tv.setEmailThanhVien(request.getEmailThanhVien());
        tv.setThongTinSucKhoe(request.getThongTinSucKhoe());

        return thanhVienRepository.save(tv);
    }

    /**
     * Xóa thành viên.
     */
    @Transactional
    public void delete(String maThanhVien) {

        ThanhVienDoi tv = findById(maThanhVien);

        thanhVienRepository.delete(tv);
    }

}