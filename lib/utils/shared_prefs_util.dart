import 'package:shared_preferences/shared_preferences.dart';
import '../controller/models/models.dart';

class SharedPrefsUtil {
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';
  static const String _keyRememberMe = 'rememberMe';
  static const String _keyUserId = 'userId';
  static const String _keyTeamIds = 'teamIds';
  static const String _keyUserName = 'userName';
  static const String _keyUserCorreo = 'userCorreo';
  static const String _keyCategorias = 'categorias';
  static const String _keyNombresEquipos = 'nombresEquipos';
  static const String _keyIdesCategorias = 'idesCategorias';
  static const String _defaultTheme = 'defaultTheme';

  static Future<void> saveUserData(
    String email,
    String password,
    bool rememberMe,
    Usuario usuario,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, usuario.idUsuario);
    await prefs.setStringList(_keyTeamIds, usuario.idesEquipos);
    await prefs.setString(_keyUserName, usuario.nombre);
    await prefs.setString(_keyUserCorreo, usuario.correo);
    await prefs.setString(_keyCategorias, usuario.categorias);
    await prefs.setStringList(_keyNombresEquipos, usuario.nombresEquipos);
    await prefs.setStringList(_keyIdesCategorias, usuario.idesCategorias);

    if (rememberMe) {
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
    } else {
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPassword);
    }

    await prefs.setBool(_keyRememberMe, rememberMe);
  }

  static Future<Map<String, dynamic>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail) ?? '';
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    final userId = prefs.getString(_keyUserId) ?? '';
    final teamIds = prefs.getStringList(_keyTeamIds) ?? [];
    final userName = prefs.getString(_keyUserName) ?? '';
    final userCorreo = prefs.getString(_keyUserCorreo) ?? '';
    final categorias = prefs.getString(_keyCategorias) ?? '';
    final nombresEquipos = prefs.getStringList(_keyNombresEquipos) ?? [];
    final idesCategorias = prefs.getStringList(_keyIdesCategorias) ?? [];

    return {
      'email': email,
      'rememberMe': rememberMe,
      'userId': userId,
      'teamIds': teamIds,
      'userName': userName,
      'userCorreo': userCorreo,
      'categorias': categorias,
      'nombresEquipos': nombresEquipos,
      'idesCategorias': idesCategorias,
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyRememberMe);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyTeamIds);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserCorreo);
    await prefs.remove(_keyCategorias);
    await prefs.remove(_keyNombresEquipos);
    await prefs.remove(_keyIdesCategorias);
  }

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId) ?? '';
  }
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword) ?? '';
  }

  static Future<List<String>> getTeamIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyTeamIds) ?? [];
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<void> setTeamIds(List<String> teamIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyTeamIds, teamIds);
  }

  static Future<void> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, userName);
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  static Future<List<String>> getTeamNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyNombresEquipos) ?? [];
  }
}
