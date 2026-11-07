CREATE TABLE IF NOT EXISTS lideres_iglesia (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cargo BIGINT UNSIGNED NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NULL,
    fecha_inicio DATE NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX lideres_iglesia_id_cargo_foreign (id_cargo),
    CONSTRAINT lideres_iglesia_id_cargo_foreign FOREIGN KEY (id_cargo) REFERENCES cargos (id) ON DELETE CASCADE
);
