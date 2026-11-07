CREATE TABLE IF NOT EXISTS ingresos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_actividad BIGINT UNSIGNED NULL,
    id_culto BIGINT UNSIGNED NULL,
    pago_curso_id BIGINT UNSIGNED NULL,
    monto_total DECIMAL(12,2) NOT NULL,
    fecha DATE NOT NULL,
    tipo VARCHAR(100) NULL,
    metodo_pago VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX ingresos_id_actividad_foreign (id_actividad),
    INDEX ingresos_id_culto_foreign (id_culto),
    INDEX ingresos_pago_curso_id_foreign (pago_curso_id),
    CONSTRAINT ingresos_id_actividad_foreign FOREIGN KEY (id_actividad) REFERENCES actividades (id) ON DELETE SET NULL,
    CONSTRAINT ingresos_id_culto_foreign FOREIGN KEY (id_culto) REFERENCES cultos (id_culto) ON DELETE SET NULL,
    CONSTRAINT ingresos_pago_curso_id_foreign FOREIGN KEY (pago_curso_id) REFERENCES pago_cursos (id) ON DELETE SET NULL
);
