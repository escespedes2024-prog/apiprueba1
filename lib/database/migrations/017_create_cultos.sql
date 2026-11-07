CREATE TABLE IF NOT EXISTS cultos (
    id_culto BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    id_lider_iglesia BIGINT UNSIGNED NULL,
    dia_semana ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') NOT NULL,
    hora TIME NOT NULL,
    descripcion TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX cultos_id_lider_iglesia_foreign (id_lider_iglesia),
    CONSTRAINT cultos_id_lider_iglesia_foreign FOREIGN KEY (id_lider_iglesia) REFERENCES lideres_iglesia (id) ON DELETE SET NULL
);
