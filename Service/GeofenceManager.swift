//
//  GeofenceManager.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/15/26.
//

import CoreLocation
import Foundation

enum DwellPhase{
    case initialCheck
    case finalCheck
}



final class GeofenceManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var pendingRegion: CLCircularRegion?
    private var dwellTask: Task<Void, Never>? //<specific type>
    private var dwellPhase: DwellPhase = .initialCheck
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    //Monitoring and setup CLRegion, check address array, pass store address 1 at a time to st as CLRegion
    
    func startMonitoring(stores: [Address]){// monitor all store
        for store in stores{
            let center = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude) //need store lat+long to map out the center
            let region = CLCircularRegion(center: center, radius: 150, identifier: store.id.uuidString) //set how big of the circle radius as a fence
            locationManager.startMonitoring(for: region)//register for geofence
            print ("currently monitoring \(store.name)")
        }
    }
    
    //condition: didEnterRegion-> driving/moving speed less than 10mph, >30second , userNotification
    //check geofence entry
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region.identifier == pendingRegion?.identifier else {return}
        
        print("enter geofence for store \(region) region")
        dwellTask?.cancel()
        dwellTask = nil
        pendingRegion = nil
        dwellPhase = .initialCheck
//        manager.requestLocation() //get location update now
    }
    
    
    //get the lastest loation upadte from CLLocation, used to check speed
    //CLLocaiton hs speed info, coordinate, timestamp
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {return}
        
        //grocery store parking lot speed limit is 10 to 15 miles per hour (mph). CLLocation speed is speed per sec
        //stationary is speed btw 0<>10 mps
        //mps to mph 1=2.23694
        let speedMps = location.speed
        
        
        guard speedMps >= 0 else{
            return
        }
        
        let speedMph = speedMps * 2.23694
        
        switch dwellPhase {
        case .initialCheck:
            if speedMph <= 10 {
                print("speedMph btw 0-10, user slow down")
                Task { await self.startDwellTimer() }
            } else {
                print("user is moving at \(speedMph) mph")
            }
        case .finalCheck:
            guard let region = pendingRegion else { return }
            let storeLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            let distance = location.distance(from: storeLocation)
            if distance <= region.radius && speedMph <= 10 {
                print("user arrived to store")
                Task { await NotificationManager.shared.scheduleNotification() }
            } else {
                print("user did not pass the final check")
            }
        }
    }
    
    @MainActor
    private func startDwellTimer() {
        dwellTask?.cancel()
        dwellTask = Task {
            do {
                try await Task.sleep(for: .seconds(30))
                guard !Task.isCancelled else { return }
                print("finished dwelling 30 second")
                dwellPhase = .finalCheck
                locationManager.requestLocation()
            } catch {
                print("Dwell timer canceled")
            }
        }
    }
}

