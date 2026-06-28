package com.hcmute.sportms.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "AUDIT_LOG", schema = "SPORTS_OWNER")
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AUDITID")
    private Long auditId;

    @Column(name = "USERNAME")
    private String username;

    @Column(name = "ACTIONTYPE")
    private String actionType;

    @Column(name = "OBJECTNAME")
    private String objectName;

    @Column(name = "RECORDID")
    private String recordId;

    @Lob
    @Column(name = "OLDVALUE")
    private String oldValue;

    @Lob
    @Column(name = "NEWVALUE")
    private String newValue;

    @Column(name = "CLIENTIP")
    private String clientIp;

    @Column(name = "ACTIONTIME")
    private LocalDateTime actionTime;

    @Column(name = "STATUS")
    private String status;
}