import UIKit
import UserNotifications

fileprivate let playAudioActionIdentifier = "PLAY_AUDIO_IDENTIFIER"
fileprivate let playAudioCategoryIdentifier = "PLAY_AUDIO_CATEGORY"
fileprivate let directionsCategoryIdentifier = "DIRECTIONS_CATEGORY"

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

  static let shared = NotificationManager()
  let audioManager = AudioManager.shared
  var nextAddress: String?

  override init() {
    super.init()
    setup()
  }

  func setup() {
    UNUserNotificationCenter.current().delegate = self
    registerForPushNotifications()
    getNotificationSettings()
  }

  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      print("Permission granted: \(granted)")
      guard granted else { return }

      let playAudioAction = UNNotificationAction(identifier: playAudioActionIdentifier,
                                                 title: "Play",
                                                 options: [])

      let playAudioCategory = UNNotificationCategory(identifier: playAudioCategoryIdentifier,
                                                     actions: [playAudioAction],
                                                     intentIdentifiers: [],
                                                     options:[])

      let directionsCategory = UNNotificationCategory(identifier: directionsCategoryIdentifier,
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options:[])

      UNUserNotificationCenter.current().setNotificationCategories([playAudioCategory, directionsCategory])

      self.getNotificationSettings()
    }
  }

  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async(execute: {
        UIApplication.shared.registerForRemoteNotifications()
      })
    }
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler cb: @escaping () -> Void) {
    if (response.actionIdentifier == playAudioActionIdentifier) {
      audioManager.playAudio()

      DispatchQueue.main.asyncAfter(deadline: .now() + audioManager.player!.duration) {
        self.sendNextLocationNotification()
      }

    }
    cb()
  }

  func sendNextLocationNotification() {
    if nextAddress == nil {
      return
    }

    let content = UNMutableNotificationContent()
    content.title = "Go To"
    content.body = nextAddress!
    content.categoryIdentifier = directionsCategoryIdentifier

    let timeInSeconds: TimeInterval = 1
    let identifier = "directions"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                    repeats: false)

    let request = UNNotificationRequest(identifier: identifier,
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
      if error != nil {
        print("Error adding notification with identifier: \(identifier)")
      }
    })
  }

  func sendPlayAudioNotification(_ address: String, next nextAddress: String?) {
    print("102", address, nextAddress)
    self.nextAddress = nextAddress
    let content = UNMutableNotificationContent()
    content.title = "Destination Reached"
    content.body = address
    content.categoryIdentifier = playAudioCategoryIdentifier

    let timeInSeconds: TimeInterval = 1
    let identifier = "playAudio"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                    repeats: false)

    let request = UNNotificationRequest(identifier: identifier,
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
      if error != nil {
        print("Error adding notification with identifier: \(identifier)")
      }
    })
  }
}
