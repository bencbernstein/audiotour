import UIKit
import AVFoundation


class ViewController: UIViewController {

  let locationManager = LocationManager.shared

  var player: AVAudioPlayer?

  override func viewDidLoad() {
    super.viewDidLoad()
    // play sound on load
    playsound()
    let title = UILabel()
    title.text = "Go to " + locationManager.next["address"].stringValue
    title.textColor = .black
    title.sizeToFit()
    title.textAlignment = .center
    title.frame = view.frame
    title.center = view.center
    title.isUserInteractionEnabled = true
    view.addSubview(title)

    let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
    title.addGestureRecognizer(gesture)
  }

  func playsound() {
    guard let url = Bundle.main.url(forResource: "nobleintro", withExtension: "mp3") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)

      player = try AVAudioPlayer(contentsOf: url)

      print("play")

      player?.play()

    } catch let error {
      print(error.localizedDescription)
    }
  }

  @objc func checkAction(sender : UITapGestureRecognizer) {

    print("tap")
    //exit(1)
  }
}
