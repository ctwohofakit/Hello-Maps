//
//  GeofenceManager.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/15/26.
//

import CoreLocation
import Foundation



final class GeofenceManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = GeofenceManager()
    private let locationManager = CLLocationManager()
    private var hasNotifiedCurrentVisit = false //only fire once per visit, use this to check
    private var dwellTask: Task<Void, Never>? //<specific type>
//    private var dwellPhase: DwellPhase = .initialCheck
    private var monitoredStores: [Address] = []
    private var isDwellTimerRunning = false
    // one shared GeofenceManager
    
    
    
    @Published var didEnterStore = false        // debug value for UI
    
    @Published var currentSpeedMph: Double = 0  // debug value for UI
    
    @Published var distanceToStore: Double = 0  // debug value for UI
    
    @Published var lastEvent = "Waiting..."     // latest debug event
    @Published var notificationFired: Bool = false
    @Published var monitoredRegionCount: Int = 0

    
    // did we reach notification step?
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    //Monitoring and setup CLRegion, check address array, pass store address 1 at a time to st as CLRegion
    
    func startMonitoring(stores: [Address]){// monitor all store
        for store in stores{
            let center = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude) //need store lat+long to map out the center
            let region = CLCircularRegion(center: center, radius: 200, identifier: store.id.uuidString) //set how big of the circle radius as a fence
            locationManager.startMonitoring(for: region)//register for geofence
            monitoredRegionCount = locationManager.monitoredRegions.count
            print ("currently monitoring \(monitoredRegionCount)stores)")
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
        
        currentSpeedMph = speedMph
        guard didEnterStore else{return}
        guard !hasNotifiedCurrentVisit else{ return} //if already notified do nothing
        
        if speedMph <= 5{
            lastEvent = "Arrival detected"
            startDwellTimer()
        }else {
            lastEvent = "enter but too fast moving"
            print("usr moving at \(speedMph) mph")
        }
    
}
    private func startDwellTimer() {
        guard !isDwellTimerRunning else { return }
         isDwellTimerRunning = true
        
        dwellTask = Task { [weak self] in
            do {
                print("dwell timer start")
                try await Task.sleep(for: .seconds(10))
                guard !Task.isCancelled else { return }
                await self?.completeDwellTimer()

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

    /*    pendingRegion = circularRegion */                        // remember entered store region

        dwellTask?.cancel()                                    // cancel old timer

        dwellTask = nil                                        // clear old timer

        print("Entered region: \(region.identifier)")
        print("monitorin started: home \(region.identifier)")
        manager.requestLocation()                              // get current speed/location
    }
    
    
    
    //add a reset notification status when user exit the store
    /*
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){
        hasNotifiedCurrentVisit = false
        notificationFired = false
        didEnterStore = false
        dwellTask?.cancel()
        dwellTask = nil
        lastEvent = "Existed store gefence"                                                              
        print("exit region\(region.identifier)")
    }
    */
    
    func locationManager(
        _ manager: CLLocationManager,                  // Core Location manager
        didExitRegion region: CLRegion                 // region we just left
    ) {

        didEnterStore = false                          // Field Test → FALSE

        hasNotifiedCurrentVisit = false                // next entry can notify again

        notificationFired = false                      // reset notification debug value

        dwellTask?.cancel()                            // cancel pending timer

        dwellTask = nil                                // remove timer

        lastEvent = "EXITED: \(region.identifier)"     // example: EXITED: home test

        print("EXITED: \(region.identifier)")          // Xcode debug output
    }
    
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion){
        monitoredRegionCount = manager.monitoredRegions.count
        
        lastEvent = "started monitoring region"
        
        print("Monitoring started: \(region.identifier)")
        
    }
    
    
    func startHomeTest(address: Address){
        let center = CLLocationCoordinate2D(
            latitude: address.latitude,
            longitude: address.longitude
        )
        
        let region = CLCircularRegion(
            center: center,
            radius: 200,
            identifier: "home test"
            
        )
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
        locationManager.requestState(for: region)
        
        lastEvent = "home test region started"
        
    }
    
    func startLiveTracking(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        lastEvent = "live tracking started" //debug
    }
    
    func stopLiveTracking(){
        locationManager.stopUpdatingLocation()
        lastEvent = "live tracking stopped" //debug
    }
    
    private func cancelDwellTimer(){
        guard isDwellTimerRunning else {return}
        dwellTask?.cancel()
        dwellTask = nil
        isDwellTimerRunning = false
        print("dwell timeer canceled")
    }
    
    
    @MainActor
    private func completeDwellTimer(){
        guard !hasNotifiedCurrentVisit else {return}
        notificationFired = true
        hasNotifiedCurrentVisit = true
        lastEvent = "notification fired"
        NotificationManager.shared.scheduleNotification()
        print("dwell timer completed")
    }
}
