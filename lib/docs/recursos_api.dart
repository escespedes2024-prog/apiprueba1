import '../models/actividad.dart';
import '../models/asistencia_sesion.dart';
import '../models/auditoria.dart';
import '../models/cargo.dart';
import '../models/contrato.dart';
import '../models/curso.dart';
import '../models/culto.dart';
import '../models/docente.dart';
import '../models/docente_curso.dart';
import '../models/egreso.dart';
import '../models/ingreso.dart';
import '../models/inscripcion.dart';
import '../models/lider_iglesia.dart';
import '../models/miembro.dart';
import '../models/miembro_ministerio.dart';
import '../models/ministerio.dart';
import '../models/modelo.dart';
import '../models/pago_curso.dart';
import '../models/perfil_usuario.dart';
import '../models/registra.dart';
import '../models/rol.dart';
import '../models/rol_usuario.dart';
import '../models/seguimiento_actividad.dart';
import '../models/sesion.dart';
import '../models/token_acceso.dart';
import '../models/usuario.dart';

/// Recurso expuesto por la API y el modelo que describe su tabla.
class RecursoApi {
  final String nombre;
  final String descripcion;
  final Modelo modelo;

  const RecursoApi({
    required this.nombre,
    required this.descripcion,
    required this.modelo,
  });
}

/// Registro central de recursos.
///
/// Se usa para construir la documentacion OpenAPI y el indice `/api`, de modo
/// que ambos se mantengan sincronizados con los modelos.
const recursosApi = <RecursoApi>[
  RecursoApi(
    nombre: 'miembros',
    descripcion: 'Miembros de la iglesia',
    modelo: modeloMiembro,
  ),
  RecursoApi(
    nombre: 'ministerios',
    descripcion: 'Ministerios',
    modelo: modeloMinisterio,
  ),
  RecursoApi(
    nombre: 'docentes',
    descripcion: 'Docentes',
    modelo: modeloDocente,
  ),
  RecursoApi(
    nombre: 'actividades',
    descripcion: 'Actividades',
    modelo: modeloActividad,
  ),
  RecursoApi(
    nombre: 'seguimientos',
    descripcion: 'Seguimiento de actividades',
    modelo: modeloSeguimientoActividad,
  ),
  RecursoApi(
    nombre: 'cursos',
    descripcion: 'Cursos biblicos',
    modelo: modeloCurso,
  ),
  RecursoApi(
    nombre: 'sesiones',
    descripcion: 'Sesiones de clase',
    modelo: modeloSesion,
  ),
  RecursoApi(
    nombre: 'contratos',
    descripcion: 'Contratos',
    modelo: modeloContrato,
  ),
  RecursoApi(nombre: 'cultos', descripcion: 'Cultos', modelo: modeloCulto),
  RecursoApi(
    nombre: 'ingresos',
    descripcion: 'Ingresos',
    modelo: modeloIngreso,
  ),
  RecursoApi(nombre: 'egresos', descripcion: 'Egresos', modelo: modeloEgreso),
  RecursoApi(
    nombre: 'cargos',
    descripcion: 'Cargos eclesiasticos',
    modelo: modeloCargo,
  ),
  RecursoApi(
    nombre: 'lideres-iglesia',
    descripcion: 'Lideres de la iglesia',
    modelo: modeloLiderIglesia,
  ),
  RecursoApi(
    nombre: 'inscripciones',
    descripcion: 'Inscripciones a cursos',
    modelo: modeloInscripcion,
  ),
  RecursoApi(
    nombre: 'pagos-cursos',
    descripcion: 'Pagos de cursos',
    modelo: modeloPagoCurso,
  ),
  RecursoApi(
    nombre: 'asistencias',
    descripcion: 'Asistencias a sesiones',
    modelo: modeloAsistenciaSesion,
  ),
  RecursoApi(
    nombre: 'registros',
    descripcion: 'Registro de asistencia por sesion',
    modelo: modeloRegistra,
  ),
  RecursoApi(
    nombre: 'docentes-cursos',
    descripcion: 'Asignacion docente-curso',
    modelo: modeloDocenteCurso,
  ),
  RecursoApi(
    nombre: 'miembros-ministerios',
    descripcion: 'Miembros por ministerio',
    modelo: modeloMiembroMinisterio,
  ),
  RecursoApi(
    nombre: 'usuarios',
    descripcion: 'Usuarios del sistema',
    modelo: modeloUsuario,
  ),
  RecursoApi(nombre: 'roles', descripcion: 'Roles', modelo: modeloRol),
  RecursoApi(
    nombre: 'roles-usuarios',
    descripcion: 'Roles asignados a usuarios',
    modelo: modeloRolUsuario,
  ),
  RecursoApi(
    nombre: 'perfiles-usuario',
    descripcion: 'Perfiles de usuario',
    modelo: modeloPerfilUsuario,
  ),
  RecursoApi(
    nombre: 'tokens',
    descripcion: 'Tokens de acceso personal',
    modelo: modeloTokenAcceso,
  ),
  RecursoApi(
    nombre: 'auditorias',
    descripcion: 'Auditorias',
    modelo: modeloAuditoria,
  ),
];
