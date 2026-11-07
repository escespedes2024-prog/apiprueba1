CREATE TABLE IF NOT EXISTS docentes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_miembro BIGINT UNSIGNED NOT NULL,
    especialidad VARCHAR(150) NULL,
    titulo VARCHAR(150) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX docentes_id_miembro_foreign (id_miembro),
    CONSTRAINT docentes_id_miembro_foreign FOREIGN KEY (id_miembro) REFERENCES miembros (id) ON DELETE CASCADE
);
