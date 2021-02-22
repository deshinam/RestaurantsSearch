import Foundation
import CoreLocation

protocol LocationDelegate: class {
    func onLocationUnavailable()
    func onLocationSuccess(_ postCode: String)
    func onDeniedPermission()
}

class LocationManager: NSObject {
    // MARK: — Private Properties
    private weak var delegate: LocationDelegate!
    private var locationManager: CLLocationManager?

    // MARK: — Initializers
    init(delegate: LocationDelegate) {
        super.init()
        self.delegate = delegate
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    // MARK: — Public Methods
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()

            switch status {
            case .denied:
                delegate.onDeniedPermission()
                return
            case .notDetermined, .restricted:
                locationManager?.requestAlwaysAuthorization()
                return
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.requestLocation()
                return
            @unknown default:
                locationManager?.requestAlwaysAuthorization()
                return
            }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate.onLocationUnavailable()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location = locations.first {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {[weak self] (placemarks, _) -> Void in
                if let newPostCode = placemarks?.compactMap({$0.postalCode}).first {
                    self?.delegate.onLocationSuccess(newPostCode)
                } else {
                    self?.delegate.onLocationUnavailable()
                }
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
               if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                   if CLLocationManager.isRangingAvailable() {
                    locationManager?.requestLocation()
                   }
               }
           }
    }
}
