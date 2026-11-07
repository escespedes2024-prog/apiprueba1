CREATE TABLE IF NOT EXISTS actividades (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ministerio BIGINT UNSIGNED NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    fecha DATE NOT NULL,
    lugar VARCHAR(200) NULL,
    estado ENUM('planificada', 'en_curso', 'completada', 'cancelada') NOT NULL DEFAULT 'planificada',
    descripcion TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX actividades_id_ministerio_foreign (id_ministerio),
    CONSTRAINT actividades_id_ministerio_foreign FOREIGN KEY (id_ministerio) REFERENCES ministerios (id) ON DELETE CASCADE
);
