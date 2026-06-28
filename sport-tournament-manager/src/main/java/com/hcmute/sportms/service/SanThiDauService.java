package com.hcmute.sportms.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.hcmute.sportms.entity.SanThiDau;
import com.hcmute.sportms.repository.SanThiDauRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SanThiDauService {
	 private final SanThiDauRepository sanRepository;

	    public List<SanThiDau> getAllStadiums(){

	        return sanRepository.findAll();
	    }

	    public SanThiDau findById(String maSan){

	        return sanRepository.findById(maSan)
	                .orElseThrow(() ->
	                        new RuntimeException("Không tìm thấy sân."));
	    }

	    @Transactional
	    public void save(SanThiDau stadium){

	        if(stadium.getMaSan() == null || stadium.getMaSan().isBlank()){
	            throw new RuntimeException("Vui lòng nhập mã sân.");
	        }

	        if(!sanRepository.existsById(stadium.getMaSan())){
	            sanRepository.save(stadium);
	            return;
	        }

	        SanThiDau old = sanRepository.findById(stadium.getMaSan())
	                .orElseThrow();

	        old.setTenSan(stadium.getTenSan());
	        old.setDiaChi(stadium.getDiaChi());
	        old.setSucChua(stadium.getSucChua());
	        old.setMoTa(stadium.getMoTa());

	        sanRepository.save(old);
	    }
	    @Transactional
	    public void delete(String maSan){

	        SanThiDau san = sanRepository.findById(maSan)
	                .orElseThrow(() -> new RuntimeException("Không tìm thấy sân"));

	        try{
	            sanRepository.delete(san);
	        }catch(Exception e){
	            throw new RuntimeException("Không thể xóa vì sân đang được sử dụng.");
	        }
	    }


}
