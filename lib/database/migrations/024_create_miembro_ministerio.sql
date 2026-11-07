CREATE TABLE IF NOT EXISTS miembro_ministerio (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    miembro_id BIGINT UNSIGNED NOT NULL,
    ministerio_id BIGINT UNSIGNED NOT NULL,
    cargo_id BIGINT UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX miembro_ministerio_miembro_id_foreign (miembro_id),
    INDEX miembro_ministerio_ministerio_id_foreign (ministerio_id),
    INDEX miembro_ministerio_cargo_id_foreign (cargo_id),
    CONSTRAINT miembro_ministerio_miembro_id_foreign FOREIGN KEY (miembro_id) REFERENCES miembros (id) ON DELETE CASCADE,
    CONSTRAINT miembro_ministerio_ministerio_id_foreign FOREIGN KEY (ministerio_id) REFERENCES ministerios (id) ON DELETE CASCADE,
    CONSTRAINT miembro_ministerio_cargo_id_foreign FOREIGN KEY (cargo_id) REFERENCES cargos (id) ON DELETE CASCADE
);
