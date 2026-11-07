class Relacion {
  final String alias;
  final String tabla;
  final String claveLocal;
  final String claveRemota;
  final List<String> columnas;
  final bool esUna;
  final bool borradoLogico;

  const Relacion.una({
    required this.alias,
    required this.tabla,
    required this.claveLocal,
    required this.claveRemota,
    required this.columnas,
    this.borradoLogico = false,
  }) : esUna = true;

  const Relacion.varias({
    required this.alias,
    required this.tabla,
    required this.claveLocal,
    required this.claveRemota,
    required this.columnas,
    this.borradoLogico = true,
  }) : esUna = false;
}
