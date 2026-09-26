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
    static let shared = GeofenceManager()
    private let locationManager = CLLocationManager()
    private var pendingRegion: CLCircularRegion?
    private var dwellTask: Task<Void, Never>? //<specific type>
    private var dwellPhase: DwellPhase = .initialCheck

    // one shared GeofenceManager

       

       @Published var didEnterStore = false        // debug value for UI

       @Published var currentSpeedMph: Double = 0  // debug value for UI

       @Published var distanceToStore: Double = 0  // debug value for UI

       @Published var lastEvent = "Waiting..."     // latest debug event
    @Published var notificationFired: Bool = false

       // did we reach notification step?

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
    /*
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else {
            return                                             // only handle circular store regions
        }

        didEnterStore = true                                   // FieldTestView shows TRUE

        lastEvent = "Entered store geofence"                   // FieldTestView shows event

        pendingRegion = circularRegion                         // remember WHICH store was entered

        dwellPhase = .initialCheck                             // begin with speed check

        dwellTask?.cancel()                                    // cancel any previous dwell timer

        dwellTask = nil                                        // remove previous timer reference

        print("Entered region: \(region.identifier)")

        manager.requestLocation()                              // get current location + speed
    }
     */
    
    
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
             startDwellTimer() 
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
    
 
    private func startDwellTimer() {
        dwellTask?.cancel()
        dwellTask = Task {
            do {
                try await Task.sleep(for: .seconds(10))
                guard !Task.isCancelled else { return }
                print("finished dwelling 30 second")
                dwellPhase = .finalCheck
                locationManager.requestLocation()
            } catch {
                print("Dwell timer canceled")
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,                         // location manager sending event
        didEnterRegion region: CLRegion                       // region the phone entered
    ) {

        guard let circularRegion = region as? CLCircularRegion else {
            return                                             // make sure it's circular
        }

        didEnterStore = true                                   // debug screen → TRUE

        lastEvent = "Entered store geofence"                   // debug screen status

        pendingRegion = circularRegion                         // remember entered store region

        dwellPhase = .initialCheck                             // start speed check

        dwellTask?.cancel()                                    // cancel old timer

        dwellTask = nil                                        // clear old timer

        print("Entered region: \(region.identifier)")

        manager.requestLocation()                              // get current speed/location
    }
}
