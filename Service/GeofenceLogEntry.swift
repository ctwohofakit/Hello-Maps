//
//  GeofenceLogEntry.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 10/4/26.
//
import Foundation
import SwiftData

@Model
final class GeofenceLogEntry{
    var id: UUID
    var date: Date
    var event: String
    var details: String
    
    init(event: String, details: String = "" ){
        self.id = UUID()
        self.date = Date()
        self.event = event
        self.details = details
    }
}

