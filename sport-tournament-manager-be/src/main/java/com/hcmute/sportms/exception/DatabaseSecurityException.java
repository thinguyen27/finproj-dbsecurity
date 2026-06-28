package com.hcmute.sportms.exception;

public class DatabaseSecurityException extends RuntimeException {
    public DatabaseSecurityException(String message) {
        super(message);
    }
}