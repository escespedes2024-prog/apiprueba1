CREATE TABLE IF NOT EXISTS cursos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    f_inicio DATE NOT NULL,
    f_fin DATE NULL,
    cupo_max INT NULL DEFAULT 30,
    dias_semana JSON NULL,
    hora_inicio TIME NULL,
    hora_fin TIME NULL,
    tiene_pago TINYINT(1) NOT NULL DEFAULT 0,
    monto_inscripcion DECIMAL(10,2) NULL DEFAULT 0.00,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
);
