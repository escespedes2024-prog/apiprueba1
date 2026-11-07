CREATE TABLE IF NOT EXISTS miembros (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20) NULL,
    f_nacimiento DATE NULL,
    estado ENUM('activo', 'inactivo', 'visita') NOT NULL DEFAULT 'activo',
    direccion VARCHAR(200) NULL,
    fecha_ingreso DATE NULL,
    sexo ENUM('M', 'F', 'otro') NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
);
