package com.hcmute.sportms.repository;

import com.hcmute.sportms.entity.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    List<AuditLog> findTop50ByOrderByActionTimeDesc();

    @Query("""
        SELECT a.actionType, COUNT(a)
        FROM AuditLog a
        GROUP BY a.actionType
    """)
    List<Object[]> countByActionType();
    @Query("""
        SELECT a.objectName, COUNT(a)
        FROM AuditLog a
        GROUP BY a.objectName
    """)
    List<Object[]> countByObjectName();

    @Query(value = """
            SELECT TO_CHAR(ACTIONTIME, 'HH24') AS hour, COUNT(*)
            FROM SPORTS_OWNER.AUDIT_LOG
            GROUP BY TO_CHAR(ACTIONTIME, 'HH24')
            ORDER BY hour
        """, nativeQuery = true)
        List<Object[]> countByHour();
}