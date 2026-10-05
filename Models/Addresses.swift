//
//  Addresses.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/8/26.
//

import Foundation
import SwiftData

enum AddType: String, Codable, Equatable{
    case home
    case store
}

@Model
final class Address{
    public var id: UUID = UUID()
    var type: AddType
    var name: String
    var address:String
    var latitude: Double
    var longitude: Double
    
    init( type: AddType, name: String, address: String, latitude: Double, longitude: Double) {

        self.type = type
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
 
}
