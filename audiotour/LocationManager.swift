import Foundation
import CoreLocation
import SwiftyJSON

let RADIUS = 20.0

class LocationManager: NSObject, CLLocationManagerDelegate {

  static let shared = LocationManager()
  var manager = CLLocationManager()
  let notificationManager = NotificationManager.shared

  var next: JSON {
    return locations.arrayValue[current]
  }

  var locations: JSON = []
  private var current = 0

  override init() {
    super.init()
    setup()
    locations = readLocations()
    stopMonitoringAllRegions()
    locations.arrayValue.forEach(setupGeofence)
  }

  private func readLocations() -> JSON {
    let path = Bundle.main.path(forResource: "locations", ofType: "json")
    if let path = path {
      let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
      if let jsonString = jsonString {
        return JSON(parseJSON: jsonString)
      }
    }
    return []
  }

  private func setup() {
    manager.requestWhenInUseAuthorization()
    manager.requestAlwaysAuthorization()
    manager.delegate = self
  }

  private func setupGeofence(_ location: JSON) {
    let identifier = location["id"].stringValue + " - " + location["address"].stringValue
    let coordinates = location["coordinates"].arrayValue
    let geofenceRegionCenter = CLLocationCoordinate2DMake(coordinates[0].doubleValue, coordinates[1].doubleValue)
    let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: RADIUS, identifier: identifier)
    geofenceRegion.notifyOnEntry = true
    manager.startMonitoring(for: geofenceRegion)
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    let id = Int(region.identifier.prefix(1))

    if region is CLCircularRegion, let id = id, current == id {
      let arr = locations.arrayValue
      let location = arr[id]
      let nextLocation =  arr.indices.contains(id + 1) ? arr[id + 1] : nil
      let address = location["address"].stringValue
      let nextAddress = nextLocation["address"].stringValue
      notificationManager.sendPlayAudioNotification(address, next: nextAddress)
      current += 1
    }
  }

  private func stopMonitoringAllRegions() {
    manager.monitoredRegions.forEach { manager.stopMonitoring(for: $0) }
  }
}
