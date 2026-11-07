CREATE TABLE IF NOT EXISTS sesiones (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_curso BIGINT UNSIGNED NOT NULL,
    id_docente BIGINT UNSIGNED NULL,
    fecha DATE NOT NULL,
    hora TIME NULL,
    tema VARCHAR(200) NULL,
    observacion TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX sesiones_id_curso_foreign (id_curso),
    INDEX sesiones_id_docente_foreign (id_docente),
    CONSTRAINT sesiones_id_curso_foreign FOREIGN KEY (id_curso) REFERENCES cursos (id) ON DELETE CASCADE,
    CONSTRAINT sesiones_id_docente_foreign FOREIGN KEY (id_docente) REFERENCES docentes (id) ON DELETE SET NULL
);
