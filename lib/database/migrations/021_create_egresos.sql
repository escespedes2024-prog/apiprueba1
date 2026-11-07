CREATE TABLE IF NOT EXISTS egresos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ministerio BIGINT UNSIGNED NULL,
    id_contrato BIGINT UNSIGNED NULL,
    tipo_egreso VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATE NOT NULL,
    responsable VARCHAR(100) NULL,
    comprobante VARCHAR(200) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX egresos_id_ministerio_foreign (id_ministerio),
    INDEX egresos_id_contrato_foreign (id_contrato),
    CONSTRAINT egresos_id_ministerio_foreign FOREIGN KEY (id_ministerio) REFERENCES ministerios (id) ON DELETE SET NULL,
    CONSTRAINT egresos_id_contrato_foreign FOREIGN KEY (id_contrato) REFERENCES contratos (id) ON DELETE SET NULL
);
