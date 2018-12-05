import UIKit

class ViewController: UIViewController {

  let locationManager = LocationManager.shared

  override func viewDidLoad() {
    super.viewDidLoad()

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

  @objc func checkAction(sender : UITapGestureRecognizer) {
    print("tap")
    exit(1)
  }
}
