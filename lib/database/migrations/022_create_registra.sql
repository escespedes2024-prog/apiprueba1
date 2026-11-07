CREATE TABLE IF NOT EXISTS registra (
    id_miembro BIGINT UNSIGNED NOT NULL,
    id_sesion BIGINT UNSIGNED NOT NULL,
    estado ENUM('presente', 'ausente', 'justificado') NOT NULL DEFAULT 'presente',
    observacion TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id_miembro, id_sesion),
    INDEX registra_id_miembro_foreign (id_miembro),
    INDEX registra_id_sesion_foreign (id_sesion),
    CONSTRAINT registra_id_miembro_foreign FOREIGN KEY (id_miembro) REFERENCES miembros (id) ON DELETE CASCADE,
    CONSTRAINT registra_id_sesion_foreign FOREIGN KEY (id_sesion) REFERENCES sesiones (id) ON DELETE CASCADE
);
