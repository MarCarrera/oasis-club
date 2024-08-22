import 'package:clubfutbol/Notifications/notifications_view.dart';
import 'package:clubfutbol/Theme/theme_notifier.dart';
import 'package:clubfutbol/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Home/splash_screen.dart';
import 'src/push_provider/push_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.initializeApp();
  // Suscripción al tema
  await FirebaseMessaging.instance.subscribeToTopic('topic1');
  await loadTheme();
  runApp(MyAppABH());
}

class MyAppABH extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyAppABH({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/notificationView': (context) => NotificationView(
                id: ModalRoute.of(context)!.settings.arguments as String),
          },
        );
      },
    );
  }
}
