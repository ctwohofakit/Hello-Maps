//
//  FieldTestView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/22/26.
//
import SwiftUI
struct FieldTestView: View {

    @ObservedObject var geofenceManager = GeofenceManager.shared

    var body: some View {

        List {

            Section("Geofence") {

                LabeledContent(
                    "Entered Store",
                    value: geofenceManager.didEnterStore ? "TRUE" : "FALSE"
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
                    "Fired",
                    value: geofenceManager.notificationFired
                        ? "YES"
                        : "NO"
                )
            }


            Section("Last Event") {

                Text(geofenceManager.lastEvent)
            }
        }
        .navigationTitle("Field Test")
    }
}
