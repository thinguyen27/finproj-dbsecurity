package com.hcmute.sportms.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.hcmute.sportms.entity.GiaiDau;
import com.hcmute.sportms.repository.GiaiDauRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GiaiDauService {
	private final GiaiDauRepository giaiDauRepository;

	public List<GiaiDau> layDanhSachGiaiDau() {
	    return giaiDauRepository.findByIsDeleted("N");
	}

	public GiaiDau layGiaiDauTheoMa(String maGiai){

	    return giaiDauRepository
	            .findByMaGiaiAndIsDeleted(
	                    maGiai,
	                    "N"
	            )
	            .orElseThrow(
	                () -> new RuntimeException(
	                        "Không tìm thấy giải đấu"
	                )
	            );
	}

	public void luuGiaiDau(GiaiDau giaiDau) {

		if (giaiDau.getMaGiai() == null || giaiDau.getMaGiai().isEmpty()) {

			long count = giaiDauRepository.count() + 1;

			String maMoi = String.format("GD%03d", count);

			giaiDau.setMaGiai(maMoi);
		}

		giaiDauRepository.save(giaiDau);
	}

	@Transactional
	public void xoaGiaiDau(String maGiai){

	    GiaiDau gd = giaiDauRepository
	            .findById(maGiai)
	            .orElseThrow(
	                () -> new RuntimeException(
	                        "Không tìm thấy giải đấu"
	                )
	            );

	    gd.setIsDeleted("Y");

	    giaiDauRepository.save(gd);
	}

}
