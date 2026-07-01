package com.hcmute.sportms.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendNewPasswordEmail(String toEmail, String newPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[SPORT MS] Khôi phục mật khẩu tài khoản");
        message.setText("Chào bạn,\n\n"
                + "Bạn đã yêu cầu khôi phục mật khẩu cho hệ thống Quản lý giải đấu thể thao.\n"
                + "Mật khẩu mới của bạn là: " + newPassword + "\n\n"
                + "Vui lòng đăng nhập và tiến hành đổi mật khẩu ngay lập tức để bảo vệ tài khoản.\n"
                + "Trân trọng,\nBan Tổ Chức.");
        
        mailSender.send(message);
    }
}