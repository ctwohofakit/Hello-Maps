//
//  GeofenceLogStore.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 10/4/26.
//
import SwiftData
@ModelActor
actor GeofenceLogStore{
    func log(
        _ event: String,
        details: String = ""
    ) {
        let entry = GeofenceLogEntry(
            event: event,
            details: details
        )
        modelContext.insert(entry)
        do{
            try modelContext.save()
        }catch {
            print("unable to save geofence log: error")
        }
    }
    
}
