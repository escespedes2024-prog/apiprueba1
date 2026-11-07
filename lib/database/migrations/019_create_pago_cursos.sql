CREATE TABLE IF NOT EXISTS pago_cursos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    inscripcion_id BIGINT UNSIGNED NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago VARCHAR(255) NOT NULL,
    comprobante VARCHAR(255) NULL,
    registrado_por BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX pago_cursos_inscripcion_id_foreign (inscripcion_id),
    INDEX pago_cursos_registrado_por_foreign (registrado_por),
    CONSTRAINT pago_cursos_inscripcion_id_foreign FOREIGN KEY (inscripcion_id) REFERENCES inscripciones (id) ON DELETE CASCADE,
    CONSTRAINT pago_cursos_registrado_por_foreign FOREIGN KEY (registrado_por) REFERENCES users (id) ON DELETE SET NULL
);
