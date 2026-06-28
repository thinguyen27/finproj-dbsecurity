package com.hcmute.sportms.exception;

import lombok.extern.slf4j.Slf4j;

import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.util.Map;
import java.sql.SQLException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

	@ExceptionHandler(DataAccessException.class)
    public ResponseEntity<Map<String, Object>> handleDatabaseException(DataAccessException ex) {
        log.error("Database Error: ", ex);
        
        String errorMessage = "Đã xảy ra lỗi hệ thống truy xuất dữ liệu.";
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

        // Bóc tách nguyên nhân gốc rễ (Root Cause) từ cơ sở dữ liệu ném lên
        Throwable rootCause = ex.getRootCause();
        if (rootCause instanceof SQLException) {
            String sqlMessage = rootCause.getMessage();
            
            // BẪY LỖI 1: Lỗi Oracle VPD (Cố tình Thêm/Sửa/Xóa dữ liệu sai Context)
            if (sqlMessage.contains("ORA-28115")) {
                errorMessage = "Vi phạm chính sách bảo mật (VPD): Bạn không có quyền thao tác trên dữ liệu của đơn vị khác!";
                status = HttpStatus.FORBIDDEN; // Trả về 403 thay vì 500
            } 
            // BẪY LỖI 2: Lỗi Oracle Label Security (OLS)
            // Tùy thuộc vào cách cấu hình, OLS thường giới hạn quyền Read/Write. 
            // Nếu người dùng cố tình cập nhật dữ liệu có nhãn cao hơn quyền của họ.
            else if (sqlMessage.contains("ORA-12416") || sqlMessage.contains("OLS")) { 
                errorMessage = "Vi phạm nhãn bảo mật (OLS): Bạn không đủ cấp độ bảo mật để thao tác dữ liệu này!";
                status = HttpStatus.FORBIDDEN;
            }
            // Thêm các bẫy ORA khác nếu cần (ví dụ Unique Constraint: ORA-00001)
            else if (sqlMessage.contains("ORA-00001")) {
                errorMessage = "Dữ liệu đã tồn tại trong hệ thống (Trùng khóa).";
                status = HttpStatus.CONFLICT; // 409
            }
        }

        return ResponseEntity.status(status)
                .body(Map.of("success", false, "message", errorMessage));
    }

    @ExceptionHandler(DatabaseSecurityException.class)
    public ResponseEntity<Map<String, Object>> handleSecurityException(DatabaseSecurityException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "message", ex.getMessage()));
    }
    
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleValidationException(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("success", false, "message", ex.getMessage()));
    }
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, Object>> handleBusinessLogicException(RuntimeException ex) {
        log.warn("Business Logic Warning: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("success", false, "message", ex.getMessage()));
    }
}