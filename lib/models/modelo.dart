import 'relacion.dart';

class Modelo {
  final String tabla;
  final List<String> clavesPrimarias;
  final List<String> columnas;
  final List<String> ignoradas;
  final List<String> buscables;
  final List<Relacion> relaciones;
  final bool borradoLogico;

  const Modelo({
    required this.tabla,
    required this.clavesPrimarias,
    required this.columnas,
    this.ignoradas = const [],
    this.buscables = const [],
    this.relaciones = const [],
    this.borradoLogico = false,
  });

  List<String> get columnasPublicas =>
      columnas.where((columna) => !ignoradas.contains(columna)).toList();

  List<String> get columnasModificables =>
      columnasPublicas.where((c) => !clavesPrimarias.contains(c)).toList();

  bool esColumna(String nombre) => columnas.contains(nombre);

  bool esColumnaPublica(String nombre) => columnasPublicas.contains(nombre);

  bool get tieneClaveCompuesta => clavesPrimarias.length > 1;

  static const auditoria = ['created_at', 'updated_at', 'deleted_at'];

  Map<String, dynamic> sanear(Map<String, dynamic> cuerpo) {
    final datos = <String, dynamic>{};
    for (final entrada in cuerpo.entries) {
      if (!columnasModificables.contains(entrada.key)) continue;
      if (auditoria.contains(entrada.key)) continue;
      datos[entrada.key] = entrada.value;
    }
    return datos;
  }

  Map<String, dynamic> sanearParaActualizar(Map<String, dynamic> cuerpo) {
    final datos = <String, dynamic>{};
    for (final entrada in cuerpo.entries) {
      if (!columnasModificables.contains(entrada.key)) continue;
      datos[entrada.key] = entrada.value;
    }
    return datos;
  }
}
