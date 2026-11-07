CREATE TABLE IF NOT EXISTS seguimiento_actividades (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_actividad BIGINT UNSIGNED NOT NULL,
    fecha_registro DATE NOT NULL,
    estado VARCHAR(50) NOT NULL,
    observacion TEXT NULL,
    responsable VARCHAR(100) NULL,
    porcentaje_avance DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX seguimiento_actividades_id_actividad_foreign (id_actividad),
    CONSTRAINT seguimiento_actividades_id_actividad_foreign FOREIGN KEY (id_actividad) REFERENCES actividades (id) ON DELETE CASCADE
);
