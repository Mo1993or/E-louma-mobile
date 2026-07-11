import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications
@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate  {
    func messaging(
      _ messaging: Messaging,
      didReceiveRegistrationToken fcmToken: String?
    ) {
        print("fcmToken \(fcmToken)")
      let tokenDict = ["token": fcmToken ?? ""]
      print("tokenDict \(tokenDict)")
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: tokenDict)
    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
    } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    return super.application(
          application,
          didFinishLaunchingWithOptions: launchOptions
      ) // Returning true will stop the propagation to other packages
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { Messaging.messaging().apnsToken = deviceToken
        print(" deviceToken dpp")
       
        print(" deviceToken \(deviceToken)")
        
      
        
    }
    override func application(_ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
        print("Notification reçue en arrière-plan :", userInfo)
        completionHandler(.newData)
    }

}
