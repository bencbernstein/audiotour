import Foundation
import AVFoundation
import AVKit

class AudioManager: NSObject, AVAudioPlayerDelegate {

  static let shared = AudioManager()
  var player: AVAudioPlayer?

  override init() {
    super.init()
  }

  func setup(audio: String) {
    do {
      try AVAudioSession.sharedInstance().setCategory(
        AVAudioSessionCategoryPlayback,
        mode: AVAudioSessionModeDefault,
        options: [.mixWithOthers])
      try AVAudioSession.sharedInstance().setActive(true)
      guard let url = Bundle.main.url(forResource: audio, withExtension: "mp3") else { return }
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
    } catch let error {
      print(error)
    }
  }

  func playAudio() {
    guard let player = player else { return }
    player.play()
  }
}
