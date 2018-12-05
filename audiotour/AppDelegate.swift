import UIKit
// import UserNotifications
// UNUserNotificationCenterDelegate
//fileprivate let playAudioActionIdentifier = "PLAY_AUDIO_IDENTIFIER"
//fileprivate let playAudioCategoryIdentifier = "PLAY_AUDIO_CATEGORY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let audioManager = AudioManager.shared
  let locationManager = LocationManager.shared

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // UNUserNotificationCenter.current().delegate = self
    // registerForPushNotifications()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    audioManager.setup(audio: locationManager.next["audio"].stringValue)
    // sendPlayAudioNotification()
  }

//  func sendPlayAudioNotification() {
//    let content = UNMutableNotificationContent()
//    content.title = "Play Audio"
//    content.body = "xxx"
//    content.categoryIdentifier = playAudioCategoryIdentifier
//
//    let timeInSeconds: TimeInterval = 1
//    let identifier = "playAudio"
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
//                                                    repeats: false)
//
//    let request = UNNotificationRequest(identifier: identifier,
//                                        content: content,
//                                        trigger: trigger)
//
//    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//      if error != nil {
//        print("Error adding notification with identifier: \(identifier)")
//      }
//    })
//  }

//  func registerForPushNotifications() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//      (granted, error) in
//      print("Permission granted: \(granted)")
//      guard granted else { return }
//
//      let playAudioAction = UNNotificationAction(identifier: playAudioActionIdentifier,
//                                                 title: "Play",
//                                                 options: [])
//
//      let playAudioCategory = UNNotificationCategory(identifier: playAudioCategoryIdentifier,
//                                                     actions: [playAudioAction],
//                                                     intentIdentifiers: [],
//                                                     options:[])
//
//      UNUserNotificationCenter.current().setNotificationCategories([playAudioCategory])
//
//      self.getNotificationSettings()
//    }
//  }

//  func getNotificationSettings() {
//    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//      print("Notification settings: \(settings)")
//      guard settings.authorizationStatus == .authorized else { return }
//      DispatchQueue.main.async(execute: {
//        UIApplication.shared.registerForRemoteNotifications()
//      })
//    }
//  }

//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler cb: @escaping () -> Void) {
//    if (response.actionIdentifier == playAudioActionIdentifier) {
//      audioManager.playAudio()
//    }
//    cb()
//  }
//
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }

  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {}
}
