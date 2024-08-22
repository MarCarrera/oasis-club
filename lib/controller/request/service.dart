import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'request.dart';
import 'package:connectivity/connectivity.dart';

// Servicios

class LoginService {
  Future<Usuario?> iniciarSesion(String correo, String contrasena) async {
    try {
      await _checkInternetConnection();
      final response = await makeLoginRequest(correo, contrasena);

      if (response.statusCode == 200) {
        return processLoginResponse(response.body);
      } else {
        throw 'Error en el srvidor, intente más tarde.';
      }
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    }
  }
}

class HomeService {
  Future<List<Entrenamiento>> cargarEntrenamientos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamIds = prefs.getStringList('teamIds');
      //print('idEquipo en service: $teamIds');

      if (teamIds == null || teamIds.isEmpty) {
        throw 'No se pudo obtener el ID del equipo.';
      }

      List<Entrenamiento> allEntrenamientos = [];
      for (String teamId in teamIds) {
        var entrenamientos = await fetchEntrenamientos(teamId);
        if (entrenamientos.isNotEmpty) {
          allEntrenamientos.addAll(entrenamientos);
        }
      }

      if (allEntrenamientos.isNotEmpty) {
        return allEntrenamientos;
      } else {
        throw 'No hay entrenamientos disponibles.';
      }
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al cargar entrenamientos: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }

  Future<Map<String, List<Entrenamiento>>> cargarEntrenamientosPorEquipo(
      String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamIds = prefs.getStringList('teamIds');
      final nombresEquipos = prefs.getStringList('nombresEquipos');
      //print('idEquipo en service: $teamIds');

      if (teamIds == null ||
          teamIds.isEmpty ||
          nombresEquipos == null ||
          nombresEquipos.isEmpty) {
        throw 'No se pudo obtener el ID o nombre del equipo.';
      }

      Map<String, List<Entrenamiento>> entrenamientosPorEquipo = {};
      for (int i = 0; i < teamIds.length; i++) {
        var entrenamientos = await fetchEntrenamientos(teamIds[i]);
        if (entrenamientos.isNotEmpty) {
          entrenamientosPorEquipo[nombresEquipos[i]] = entrenamientos;
        }
      }

      return entrenamientosPorEquipo;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al cargar entrenamientos por equipo: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }
}

class ProfileService {
  Future<ProfileData?> obtenerPerfil(String idUsuario) async {
    try {
      var profileData = await fetchUserProfile(idUsuario);
      if (profileData == null) {
        throw 'Perfil no encontrado.';
      }
      return profileData;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al obtener perfil: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }

  Future<bool> actualizarCorreo(String idUsuario, String nuevoCorreo) async {
    try {
      var updated = await updateUserCredentials(idUsuario, nuevoCorreo, '');
      if (!updated) {
        throw 'No se pudo actualizar el correo.';
      }
      return updated;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al actualizar correo: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }

  Future<bool> actualizarContrasena(
      String idUsuario, String nuevaContrasena) async {
    try {
      var updated = await updateUserCredentials(idUsuario, '', nuevaContrasena);
      if (!updated) {
        throw 'No se pudo actualizar la contraseña.';
      }
      return updated;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al actualizar contraseña: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }

  Future<bool> enviarTokenUsuario(String idUsuario, String tokenFCM) async {
    try {
      var updated = await sendTokenUser(idUsuario, tokenFCM);
      if (!updated) {
        throw 'No se pudo enviar el token.';
      }
      return updated;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al enviar token: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }
}

class NextMatchService {
  Future<List<ProximoPartido>> obtenerProximosPartidos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamIds = prefs.getStringList('teamIds');

      if (teamIds == null || teamIds.isEmpty) {
        throw 'No se pudo obtener los IDs de los equipos.';
      }

      List<ProximoPartido> proximosPartidos = [];
      for (String teamId in teamIds) {
        try {
          var partido = await fetchNextMatch(teamId);
          if (partido != null) {
            proximosPartidos.add(partido);
          }
        } catch (e) {
          print('Error al obtener partido para el equipo $teamId: $e');
        }
      }

      if (proximosPartidos.isEmpty) {
        print('No hay partidos disponibles para los equipos del usuario.');
      }

      return proximosPartidos;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al obtener los próximos partidos: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }
}

class ImageUploadService {
  Future<bool> subirImagenPerfil(String userId, File imageFile) async {
    try {
      var success = await uploadProfileImage(userId, imageFile);
      if (!success) {
        throw 'No se pudo subir la imagen de perfil.';
      }
      return success;
    } on SocketException {
      throw 'Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al subir la imagen: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }

  Future<bool> eliminarImagenPerfil(String userId) async {
    try {
      var success = await deleteProfileImage(userId);
      if (!success) {
        throw 'No se pudo eliminar la imagen de perfil.';
      }
      return success;
    } on SocketException {
      throw 'Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al eliminar la imagen: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }
}

class PlayerStatsService {
  Future<List<EstadisticasJugador>> obtenerEstadisticasJugador(
      String userId) async {
    try {
      var response = await fetchPlayerStats(userId);

      if (response == null || response.isEmpty) {
        print('No se pudieron obtener las estadísticas del jugador.');
        return [];
      }

      return response;
    } on SocketException {
      print('No se pudo conectar. Verifique su conexión a internet.');
      return [];
    } on HttpException {
      print('Error en el servidor, intente más tarde.');
      return [];
    } on FormatException {
      print('Error en el formato de respuesta.');
      return [];
    } catch (e) {
      print('Ocurrió un error inesperado: $e');
      return [];
    }
  }
}

class PartidosJugadosService {
  Future<List<PartidoJugado>> cargarPartidosJugados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamIds = prefs.getStringList('teamIds');
      print('idEquipo en service: $teamIds');

      if (teamIds == null || teamIds.isEmpty) {
        return [];
      }

      List<PartidoJugado> allPartidosJugados = [];
      for (String teamId in teamIds) {
        var partidosJugados = await fetchPartidosJugados(teamId);
        if (partidosJugados.isNotEmpty) {
          allPartidosJugados.addAll(partidosJugados);
        }
      }

      return allPartidosJugados;
    } on SocketException {
      print('Error de conexión: No se pudo conectar a internet.');
      return [];
    } on HttpException {
      print('Error de servidor: Intente más tarde.');
      return [];
    } on FormatException {
      print('Error de formato: Respuesta no válida.');
      return [];
    } catch (e) {
      print('Error al cargar partidos jugados: $e');
      return [];
    }
  }

  Future<Map<String, List<PartidoJugado>>> cargarPartidosJugadosPorEquipo(
      String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamIds = prefs.getStringList('teamIds');
      final nombresEquipos = prefs.getStringList('nombresEquipos');
      print('idEquipo en service: $teamIds');

      if (teamIds == null ||
          teamIds.isEmpty ||
          nombresEquipos == null ||
          nombresEquipos.isEmpty) {
        return {};
      }

      Map<String, List<PartidoJugado>> partidosJugadosPorEquipo = {};
      for (int i = 0; i < teamIds.length; i++) {
        var partidosJugados = await fetchPartidosJugados(teamIds[i]);
        if (partidosJugados.isNotEmpty) {
          partidosJugadosPorEquipo[nombresEquipos[i]] = partidosJugados;
        }
      }

      return partidosJugadosPorEquipo;
    } on SocketException {
      print('Error de conexión: No se pudo conectar a internet.');
      return {};
    } on HttpException {
      print('Error de servidor: Intente más tarde.');
      return {};
    } on FormatException {
      print('Error de formato: Respuesta no válida.');
      return {};
    } catch (e) {
      print('Error al cargar partidos jugados por equipo: $e');
      return {};
    }
  }
}

class NoticiasService {
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        return [];
      }

      print('UserID para obtener noticias: $userId');
      List<Noticia> response = await fetchNoticias(userId);

      return response.isEmpty ? [] : response;
    } on SocketException {
      print('Error de conexión: No se pudo conectar a internet.');
      return [];
    } on HttpException {
      print('Error de servidor: Intente más tarde.');
      return [];
    } on FormatException {
      print('Error de formato: Respuesta no válida.');
      return [];
    } catch (e) {
      print('Error al obtener noticias: $e');
      return [];
    }
  }
}

//PETICIONES MAR////////////////////////////
class NotificationsService {
  Future<List<Notificaciones>> obtenerNotificacionesJugador(
      String userId) async {
    try {
      var response = await fetchNotificationsUser(userId);

      if (response == null || response.isEmpty) {
        print('No se pudieron obtener las notificaciones del jugador.');
        return [];
      }

      return response;
    } on SocketException {
      print('No se pudo conectar. Verifique su conexión a internet.');
      return [];
    } on HttpException {
      print('Error en el servidor, intente más tarde.');
      return [];
    } on FormatException {
      print('Error en el formato de respuesta.');
      return [];
    } catch (e) {
      print('Ocurrió un error inesperado: $e');
      return [];
    }
  }

  Future<void> eliminarNotificacionesJugador(String idNot) async {
    try {
      var response = await fetchDeleteNotificationsUser(idNot);
      return response;
    } on SocketException {
      throw 'No se pudo conectar. Verifique su conexión a internet.';
    } on HttpException {
      throw 'Error en el srvidor, intente más tarde.';
    } on FormatException {
      throw 'Error en el formato de respuesta.';
    } catch (e) {
      print('Error al obtener las notificaciones del jugador: $e');
      throw 'Ocurrió un error inesperado. Por favor, inténtelo nuevamente.';
    }
  }
}
