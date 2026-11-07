CREATE TABLE IF NOT EXISTS ministerios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    id_lider BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    liderable_type VARCHAR(255) NULL,
    liderable_id BIGINT UNSIGNED NULL,
    INDEX ministerios_id_lider_foreign (id_lider),
    INDEX ministerios_liderable_type_liderable_id_index (liderable_type, liderable_id),
    CONSTRAINT ministerios_id_lider_foreign FOREIGN KEY (id_lider) REFERENCES miembros (id) ON DELETE SET NULL
);
