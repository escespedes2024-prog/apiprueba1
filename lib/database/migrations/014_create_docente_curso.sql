CREATE TABLE IF NOT EXISTS docente_curso (
    id_docente BIGINT UNSIGNED NOT NULL,
    id_curso BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    PRIMARY KEY (id_docente, id_curso),
    INDEX docente_curso_id_docente_foreign (id_docente),
    INDEX docente_curso_id_curso_foreign (id_curso),
    CONSTRAINT docente_curso_id_docente_foreign FOREIGN KEY (id_docente) REFERENCES docentes (id) ON DELETE CASCADE,
    CONSTRAINT docente_curso_id_curso_foreign FOREIGN KEY (id_curso) REFERENCES cursos (id) ON DELETE CASCADE
);
