import 'dart:async';
import 'dart:io';
import 'package:clubfutbol/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/request/service.dart';
import '../../utils/shared_prefs_util.dart';

class PushNotifications {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = StreamController.broadcast();
//get estatico que retorna el messageStream
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //cuando se recibe una notificacion se añade al stream, en este caso el titulo
    print('Data recibida: ${message.data}');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('Data recibida: ${message.data}');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('Data recibida: ${message.data}');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
    String userId = await SharedPrefsUtil.getUserId();
    if(userId.isNotEmpty){
      MyAppABH.navigatorKey.currentState
          ?.pushNamed('/notificationView', arguments: argumento);
    }else{
      MyAppABH.navigatorKey.currentState
          ?.pushNamed('/', arguments: argumento);
    }
  }

  static Future initializeApp() async {
    bool success = false;
    String userId = await SharedPrefsUtil.getUserId();
    //inicializar firebase
    await Firebase.initializeApp();
    // Pedir permisos para notificaciones
    await _requestPermissions();
    try {
      token = await FirebaseMessaging.instance.getToken();
      success =
          await ProfileService().enviarTokenUsuario(userId, token.toString());
      if (success) {
        print('Estado: $success');
        print('idUsuario: $userId');
        print('Token usuario: $token');
      }
      // Guardar el token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('UserToken', token ?? '');
    } catch (e) {
      print('Error obteniendo el token: $e');
      print('Estado: $success');
      print('idUsuario: $userId');
      print('Token usuario: $token');
    }

//Handlers
//cuando la aplicacion esta en segundo plano pero no se ha destruido o cerrado
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    //cuando la aplicacion esta abierta
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    //cuando la app esta cerrada y se debe abrir
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permiso de notificaciones concedido');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permiso de notificaciones provisional concedido');
    } else {
      print('Permiso de notificaciones denegado');
    }
  }

  static closeStreams() {
    _messageStream.close();
  }
}
