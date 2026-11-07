CREATE TABLE IF NOT EXISTS asistencias_sesion (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    miembro_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    sesion_id BIGINT UNSIGNED NOT NULL,
    estado VARCHAR(255) NOT NULL,
    observacion TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX asistencias_sesion_miembro_id_foreign (miembro_id),
    INDEX asistencias_sesion_user_id_foreign (user_id),
    INDEX asistencias_sesion_sesion_id_foreign (sesion_id),
    CONSTRAINT asistencias_sesion_miembro_id_foreign FOREIGN KEY (miembro_id) REFERENCES miembros (id) ON DELETE CASCADE,
    CONSTRAINT asistencias_sesion_user_id_foreign FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT asistencias_sesion_sesion_id_foreign FOREIGN KEY (sesion_id) REFERENCES sesiones (id) ON DELETE CASCADE
);
