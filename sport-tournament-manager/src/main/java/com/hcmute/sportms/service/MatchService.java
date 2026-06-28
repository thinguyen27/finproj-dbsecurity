package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.MatchDto;
import com.hcmute.sportms.repository.MatchRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MatchService {
    private final MatchRepository matchRepository;

    public MatchService(MatchRepository matchRepository) {
        this.matchRepository = matchRepository;
    }

    // LƯU Ý SỐNG CÒN: Kích hoạt kết nối Context xuống Oracle VPD
    @Transactional(readOnly = true)
    public List<MatchDto> getAllMatches() {
        return matchRepository.findAllMatches();
    }
}