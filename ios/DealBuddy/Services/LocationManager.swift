import Foundation
import CoreLocation

// MARK: - Location Manager
final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: Error?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() async -> CLLocation? {
        requestPermission()
        
        return await withCheckedContinuation { continuation in
            var observer: NSObjectProtocol?
            observer = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("LocationUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                if let location = self.currentLocation {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(returning: nil)
                }
                if let obs = observer {
                    NotificationCenter.default.removeObserver(obs)
                }
            }
            
            startUpdating()
            
            // Timeout after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if let obs = observer {
                    NotificationCenter.default.removeObserver(obs)
                }
                continuation.resume(returning: nil)
            }
        }
    }
    
    func calculateDistance(to location: CLLocation) -> Double? {
        guard let current = currentLocation else { return nil }
        return current.distance(from: location) / 1000 // Convert to km
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        NotificationCenter.default.post(name: NSNotification.Name("LocationUpdated"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
