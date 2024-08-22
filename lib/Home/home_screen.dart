import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:clubfutbol/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Notifications/notifications_view.dart';
import '../src/push_provider/push_notifications.dart';
import 'inicio_page.dart';
import 'statistics_page.dart';
import 'profile_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.notificationCount = 0});
  late int notificationCount;

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static final List<Widget> _widgetOptions = <Widget>[
    InicioPage(),
    StatisticsPage(),
    const ProfileScreen(),
  ];

  Future<String> _getGreeting() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'Usuario';
    return getGreeting(userName);
  }

  String getGreeting(String userName) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días, $userName';
    } else if (hour < 18) {
      return 'Buenas tardes, $userName';
    } else {
      return 'Buenas noches, $userName';
    }
  }

  Future<void> _clearNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notificationCount');
    setState(() {
      _notificationCount = 0;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  //LOCAL NOTIFICATIONS ///////////////////////////////////////////////////////////////////////
  //local notifications
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;

  final List<String> _notifications =
      []; // Lista para almacenar las notificaciones
  int _notificationCount = 0;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //canal de notificaciones
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null &&
        android != null &&
        (Platform.isAndroid || Platform.isIOS)) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // // TODO Personalizar para no utilizar el por defecto
            icon: 'launcher_icon2',
          ),
          iOS: DarwinNotificationDetails(
            sound:
                'default', // Usa un sonido personalizado si lo has incluido en tu proyecto
            presentAlert:
                true, // Muestra una alerta cuando llega la notificación
            presentBadge:
                true, // Actualiza la insignia del icono de la aplicación
            presentSound:
                true, // Reproduce un sonido cuando llega la notificación
          ),
        ),
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    setupFlutterNotifications().then((value) {
      FirebaseMessaging.onMessage.listen(showFlutterNotification);
    });
    PushNotifications.messagesStream.listen((data) async {
      setState(() {
        _notifications.add(data);
        _notificationCount = _notifications.length;
      });
      // Guardar el valor en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notificationCount', _notificationCount);
    });

    _loadNotificationCount(); // Cargar el valor almacenado al iniciar
  }

  Future<void> _loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationCount = prefs.getInt('notificationCount') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? FutureBuilder<String>(
                future: _getGreeting(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return FadeInLeft(
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: size.width * 0.09),
                            child: Text(
                              snapshot.data ?? 'Bienvenido',
                              style: GoogleFonts.mulish(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: !isDarkMode
                                      ? primaryColorOrange
                                      : colorTextDark1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              )
            : _selectedIndex == 1
                ? FadeInLeft(
                    duration: const Duration(seconds: 1),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: size.width * 0.09),
                          child: Text(
                            'Estadísticas',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: !isDarkMode
                                    ? primaryColorOrange
                                    : colorTextDark1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    _clearNotificationCount();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => NotificationView(
                                id: '',
                              )),
                    );
                  },
                  child: Stack(children: [
                    Container(
                      width: _notificationCount > 0
                          ? size.width * 0.2
                          : size.width * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications),
                      ),
                    ),
                    if (_notificationCount > 0)
                      Positioned(
                        right: 14,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: primaryColorOrange,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: 24.0,
                            maxHeight: 24.0,
                          ),
                          child: Center(
                            child: Text(
                              _notificationCount <= 9
                                  ? '${_notificationCount}'
                                  : '9+',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _notificationCount <= 9 ? 12 : 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions.map((widget) {
          if (widget is InicioPage) {
            // Pasar el contador de notificaciones
            return InicioPage();
          }
          if (widget is StatisticsPage) {
            // Pasar el contador de notificaciones
            return StatisticsPage();
          }
          return widget;
        }).toList(),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(index);
        },
        items: [
          SalomonBottomBarItem(
              icon: Icon(Icons.home,
                  color: !isDarkMode
                      ? const Color.fromARGB(255, 21, 62, 164)
                      : Colors.white),
              title: Text(
                'Inicio',
                style: TextStyle(
                    color: !isDarkMode
                        ? const Color.fromARGB(255, 21, 62, 164)
                        : Colors.white),
              ),
              selectedColor: !isDarkMode
                  ? const Color.fromARGB(255, 21, 62, 164)
                  : Colors.white),
          SalomonBottomBarItem(
              icon: Icon(Icons.bar_chart,
                  color: !isDarkMode
                      ? const Color.fromARGB(255, 199, 164, 41)
                      : Colors.white),
              title: Text(
                'Estadísticas',
                style: TextStyle(
                    color: !isDarkMode
                        ? const Color.fromARGB(255, 199, 164, 41)
                        : Colors.white),
              ),
              selectedColor: !isDarkMode
                  ? const Color.fromARGB(255, 199, 164, 41)
                  : Colors.white),
          SalomonBottomBarItem(
              icon: Icon(Icons.person,
                  color: !isDarkMode ? primaryColorOrange : Colors.white),
              title: Text(
                'Perfil',
                style: TextStyle(
                    color: !isDarkMode ? primaryColorOrange : Colors.white),
              ),
              selectedColor: !isDarkMode ? primaryColorOrange : Colors.white),
        ],
      ),
    );
  }
}
