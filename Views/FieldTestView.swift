//
//  FieldTestView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/22/26.
//
import SwiftUI
import SwiftData
import UserNotifications
struct FieldTestView: View {

    @State private var notificationPermission = "Checking"
    @ObservedObject var geofenceManager = GeofenceManager.shared
    private func checkNotificaitonPermission() async{
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus{
        case .authorized:
            notificationPermission = "Allowed"
        case .denied:
            notificationPermission = "Denied"
        case .notDetermined:
            notificationPermission = "not determined"
        case .provisional:
            notificationPermission = "provisional"
        case .ephemeral:
            notificationPermission = "ephmeral"
            
        }
    }
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GeofenceLogEntry.date, order: .reverse)
    private var logs: [GeofenceLogEntry]

    var body: some View {

        List {

            Section("Geofence") {
                LabeledContent(
                    "monitoring",
                    value: geofenceManager.monitoredRegionCount > 0 ? "Yes" : "No"
                    
                )
                
                LabeledContent(
                    "monitored Stores count",
                    value: "\(geofenceManager.monitoredRegionCount)"
                    
                )
                LabeledContent(
                    "Entered Store",
                    value: geofenceManager.didEnterStore ? "TRUE" : "FALSE"
                )
                LabeledContent(
                    "Entered Region",                         // label shown on Field Test screen
                    value: geofenceManager.didEnterStore      // existing Bool from GeofenceManager
                        ? "TRUE"                              // show TRUE after entry
                        : "FALSE"                             // otherwise FALSE
                )
                LabeledContent(
                    "Distance",
                    value: "\(Int(geofenceManager.distanceToStore)) m"
                )
            }


            Section("Location") {

                LabeledContent(
                    "Current Speed",
                    value: String(
                        format: "%.1f mph",
                        geofenceManager.currentSpeedMph
                    )
                )
            }


            Section("Notification") {
                LabeledContent(
                    "notification permission",
                    value: notificationPermission
                )
                LabeledContent(
                    "Fired",
                    value: geofenceManager.notificationFired
                        ? "YES"
                        : "NO"
                )
            }
            ForEach(logs){log in
                VStack(alignment: .leading){
                    Text(log.event)
                    Text(log.details)
                    Text(log.date.formatted())
                }
            }

            Section("Last Event") {

                Text(geofenceManager.lastEvent)
            }
        }
        .navigationTitle("Field Test")
        .task {

            await checkNotificaitonPermission()
            geofenceManager.startLiveTracking()
        }
        .onDisappear{
            geofenceManager.stopLiveTracking()
        }
    }

        
    
}
