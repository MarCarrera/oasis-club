/*import UIKit
import Flutter
//import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}*/


import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Asegúrate de que Firebase está configurado

    GeneratedPluginRegistrant.register(with: self)
    
    // Push Notifications
    // Protocolo delegado para interactuar con notificaciones
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    // Autorización del usuario para habilitar notificaciones
    application.registerForRemoteNotifications()
      //Suscribir usuarios a un topic
     // Messaging.messaging().subscribe(toTopic: "pruebaiOS")
      //Delegar funcionalidad de obtencion token
      Messaging.messaging().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Implementa los métodos del protocolo UNUserNotificationCenterDelegate aquí
}
// MARK: - Messagging Delegate
extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, 
                   didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("FCM Token iOS: \(String(describing: fcmToken))")
            
    }
}

// MARK: - UNUserNotificationCenterDelegate
/*extension AppDelegate: UNUserNotificationCenterDelegate {
  // Implementa los métodos del protocolo aquí
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Manejar la notificación mientras la app está en primer plano
    completionHandler([.alert, .badge, .sound])
  }
}*/

