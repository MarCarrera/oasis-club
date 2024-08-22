import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/models.dart';

// Consulta para login
Future<http.Response> makeLoginRequest(String correo, String contrasena) {
  var data = {
    'opcion': '450',
    'correo': correo,
    'contrasena': contrasena,
    'tokenBitala': token,
  };
  return http.post(Uri.parse(apiUrl), body: data);
}

Usuario processLoginResponse(String responseBody) {
  if (responseBody.contains('Contrasena incorrecta')) {
    throw 'Contraseña incorrecta';
  } else if (responseBody.contains('Correo invalido')) {
    throw 'Correo inválido';
  }
  try {
    var jsonResponse = jsonDecode(responseBody) as List;
    if (jsonResponse.isNotEmpty) {
      return Usuario.fromJson(jsonResponse[0]);
    } else {
      throw 'Usuario no encontrado.';
    }
  } catch (e) {
    throw 'Error en el formato de respuesta.';
  }
}

// Consultar datos para vista de perfil
Future<ProfileData?> fetchUserProfile(String idUsuario) async {
  var data = {
    'opcion': '451',
    'id_usuario': idUsuario,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      if (jsonResponse.isNotEmpty) {
        return ProfileData.fromJson(jsonResponse[0]);
      } else {
        throw Exception('Perfil no encontrado');
      }
    } else {
      throw Exception('Error al obtener perfil');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// Editar correo electrónico y/o contraseña
Future<bool> updateUserCredentials(
    String idUsuario, String nuevoCorreo, String nuevaContrasena) async {
  var data = {
    'opcion': '452',
    'id_usuario': idUsuario,
    'correo': nuevoCorreo,
    'contrasena': nuevaContrasena,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar credenciales');
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

// Enviar token a bd al iniciar sesion
Future<bool> sendTokenUser(String idUsuario, String tokenFCM) async {
  var data = {
    'opcion': '85',
    'id_usuario': idUsuario,
    'nuevo_token': tokenFCM,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al enviar token');
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

// Consulta para obtener entrenamientos
Future<List<Entrenamiento>> fetchEntrenamientos(String teamId) async {
  var data = {
    'opcion': '465',
    'id_equipo': teamId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((item) => Entrenamiento.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener entrenamientos');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

// Consulta para obtener el próximo partido
Future<ProximoPartido?> fetchNextMatch(String teamId) async {
  var data = {
    'opcion': '460',
    'id_equipo': teamId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        return ProximoPartido.fromJson(jsonResponse[0]);
      } else {
        throw Exception(
            'No se encontró el próximo partido o el formato de la respuesta es incorrecto');
      }
    } else {
      throw Exception(
          'Error al obtener el próximo partido: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// Subir imagen de perfil
Future<bool> uploadProfileImage(String userId, File imageFile) async {
  final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
    ..fields['opcion'] = '454'
    ..fields['id_usuario'] = userId
    ..fields['tokenBitala'] = token
    ..files
        .add(await http.MultipartFile.fromPath('foto_perfil', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Error al subir la imagen: ${response.statusCode}');
    return false;
  }
}

// Eliminar imagen de perfil
Future<bool> deleteProfileImage(String userId) async {
  var data = {
    'opcion': '455',
    'id_usuario': userId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al eliminar la imagen: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

// Obtener estadísticas de jugador
Future<List<EstadisticasJugador>?> fetchPlayerStats(String userId) async {
  var data = {
    'opcion': '470',
    'id_usuario': userId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse
            .map((item) => EstadisticasJugador.fromJson(item))
            .toList();
      } else {
        throw Exception('Formato de respuesta incorrecto');
      }
    } else {
      throw Exception(
          'Error al obtener las estadísticas del jugador: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

//Obtener partidos Jugados por Equipo
Future<List<PartidoJugado>> fetchPartidosJugados(String teamId) async {
  var data = {
    'opcion': '461',
    'id_equipo': teamId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((item) => PartidoJugado.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los partidos jugados');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

// Obtener noticias por ID de usuario
Future<List<Noticia>> fetchNoticias(String userId) async {
  var data = {
    'opcion': '462',
    'id_usuario': userId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((item) => Noticia.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener noticias');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

//PETICIONES MAR////////////////////////////

//Obtener Notificaciones de usuario
Future<List<Notificaciones>?> fetchNotificationsUser(String userId) async {
  var data = {
    'opcion': '340',
    'id_usuario': userId,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      //print('Response body: ${response.body}');

      var jsonResponse = jsonDecode(response.body);
      ('Notificaciones de usuario::: $jsonResponse');
      if (jsonResponse is List) {
        return jsonResponse
            .map((item) => Notificaciones.fromJson(item))
            .toList();
      } else {
        throw Exception('Formato de respuesta incorrecto');
      }
    } else {
      throw Exception(
          'Error al obtener las notificaciones del jugador: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

Future<void> fetchDeleteNotificationsUser(String idNot) async {
  var data = {
    'opcion': '341',
    'id_notificacion': idNot,
    'tokenBitala': token,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      //print('Response body: ${response.body}');

      var jsonResponse = jsonDecode(response.body);
      print('Eliminar notificacion::: $jsonResponse');
      return jsonResponse;
    } else {
      throw Exception(
          'Error al obtener las notificaciones del jugador: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
