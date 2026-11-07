import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/service_crud.dart';

const _jsonHeaders = {
  'Content-Type': 'application/json; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
};

Response _json(Object cuerpo, {int status = 200}) {
  return Response(
    status,
    body: jsonEncode(cuerpo),
    headers: _jsonHeaders,
  );
}

Response _error(String mensaje, {int status = 400}) {
  return _json({'message': mensaje}, status: status);
}

Future<Map<String, dynamic>> _cuerpo(Request request) async {
  final texto = await request.readAsString();
  if (texto.trim().isEmpty) return <String, dynamic>{};
  final decodificado = jsonDecode(texto);
  if (decodificado is! Map<String, dynamic>) {
    throw const FormatException('El cuerpo debe ser un objeto JSON');
  }
  return decodificado;
}

int _entero(String? valor, int porDefecto, {int minimo = 1}) {
  final parsed = int.tryParse(valor ?? '');
  if (parsed == null) return porDefecto;
  return parsed < minimo ? minimo : parsed;
}

List<String> _clavesDeUrl(Request request, ServiceCrud service) {
  if (service.modelo.tieneClaveCompuesta) {
    return service.modelo.clavesPrimarias
        .map((clave) => request.params[clave] ?? '')
        .toList();
  }
  return [request.params['id'] ?? ''];
}

Router buildCrudRoutes(ServiceCrud service, String recurso) {
  final router = Router();
  final base = '/api/$recurso';

  final patronShow = service.modelo.tieneClaveCompuesta
      ? '$base/<${service.modelo.clavesPrimarias.join('/<')}>'
      : '$base/<id>';

  final patronAccion = service.modelo.tieneClaveCompuesta
      ? '$base/<${service.modelo.clavesPrimarias.join('/<')}>/<accion>'
      : '$base/<id>/<accion>';

  router.get(base, (Request request) async {
    try {
      final query = request.url.queryParameters;
      final filtros = <String, dynamic>{};
      for (final entrada in query.entries) {
        if (const ['pagina', 'por_pagina', 'buscar', 'orden', 'direccion', 'incluir_eliminados'].contains(entrada.key)) {
          continue;
        }
        if (service.modelo.esColumna(entrada.key)) {
          filtros[entrada.key] = entrada.value;
        }
      }

      final pagina = _entero(query['pagina'], 1);
      final porPagina = _entero(query['por_pagina'], 25, minimo: 1);
      final busqueda = query['buscar'];
      final incluirEliminados = query['incluir_eliminados'] == '1';

      final filas = await service.obtenerTodos(
        filtros: filtros,
        busqueda: busqueda,
        pagina: pagina,
        porPagina: porPagina,
        ordenarPor: query['orden'],
        direccion: query['direccion'] ?? 'asc',
        incluirEliminados: incluirEliminados,
      );

      final total = await service.contar(
        filtros: filtros,
        busqueda: busqueda,
        incluirEliminados: incluirEliminados,
      );

      return _json({
        'data': filas,
        'meta': {
          'pagina': pagina,
          'por_pagina': porPagina,
          'total': total,
          'paginas': porPagina == 0 ? 0 : (total / porPagina).ceil(),
        },
      });
    } catch (e) {
      return _error('No se pudo listar $recurso: $e', status: 500);
    }
  });

  router.get(patronShow, (Request request) async {
    try {
      final registro = await service.obtenerPorId(_clavesDeUrl(request, service));
      if (registro == null) {
        return _error('$recurso no encontrado', status: 404);
      }
      return _json({'data': registro});
    } catch (e) {
      return _error('No se pudo obtener $recurso: $e', status: 500);
    }
  });

  router.post(base, (Request request) async {
    try {
      final cuerpo = await _cuerpo(request);
      if (cuerpo.isEmpty) {
        return _error('El cuerpo de la peticion esta vacio');
      }
      final creado = await service.crear(cuerpo);
      if (creado == null) {
        return _error('No se pudo crear $recurso: revisa los campos requeridos');
      }
      return _json({
        'message': '$recurso creado correctamente',
        'data': creado,
      }, status: 201);
    } on FormatException catch (e) {
      return _error(e.message);
    } catch (e) {
      return _error('No se pudo crear $recurso: $e', status: 500);
    }
  });

  router.put(patronShow, (Request request) async {
    try {
      final claves = _clavesDeUrl(request, service);
      final existente = await service.obtenerPorId(claves);
      if (existente == null) {
        return _error('$recurso no encontrado', status: 404);
      }
      final cuerpo = await _cuerpo(request);
      if (cuerpo.isEmpty) {
        return _error('El cuerpo de la peticion esta vacio');
      }
      final actualizado = await service.actualizar(claves, cuerpo);
      return _json({
        'message': '$recurso actualizado correctamente',
        'data': actualizado,
      });
    } on FormatException catch (e) {
      return _error(e.message);
    } catch (e) {
      return _error('No se pudo actualizar $recurso: $e', status: 500);
    }
  });

  router.delete(patronShow, (Request request) async {
    try {
      final claves = _clavesDeUrl(request, service);
      final existente = await service.obtenerPorId(claves);
      if (existente == null) {
        return _error('$recurso no encontrado', status: 404);
      }
      final eliminado = await service.eliminar(claves);
      if (!eliminado) {
        return _error('No se pudo eliminar $recurso', status: 404);
      }
      return _json({
        'message': service.modelo.borradoLogico
            ? '$recurso eliminado logicamente'
            : '$recurso eliminado correctamente',
      });
    } catch (e) {
      return _error('No se pudo eliminar $recurso: $e', status: 500);
    }
  });

  router.post(patronAccion, (Request request) async {
    final accion = request.params['accion'];
    if (accion != 'restaurar') {
      return _error('Accion desconocida: $accion', status: 404);
    }
    try {
      final restaurado = await service.restaurar(_clavesDeUrl(request, service));
      if (!restaurado) {
        return _error('No se pudo restaurar $recurso', status: 404);
      }
      return _json({'message': '$recurso restaurado correctamente'});
    } catch (e) {
      return _error('No se pudo restaurar $recurso: $e', status: 500);
    }
  });

  return router;
}
