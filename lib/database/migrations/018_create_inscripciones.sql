CREATE TABLE IF NOT EXISTS inscripciones (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    miembro_id BIGINT UNSIGNED NOT NULL,
    curso_id BIGINT UNSIGNED NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    estado VARCHAR(255) NOT NULL DEFAULT 'Activo',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    INDEX inscripciones_miembro_id_foreign (miembro_id),
    INDEX inscripciones_curso_id_foreign (curso_id),
    CONSTRAINT inscripciones_miembro_id_foreign FOREIGN KEY (miembro_id) REFERENCES miembros (id) ON DELETE CASCADE,
    CONSTRAINT inscripciones_curso_id_foreign FOREIGN KEY (curso_id) REFERENCES cursos (id) ON DELETE CASCADE
);
