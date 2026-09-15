//
//  Addresses.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/8/26.
//

import Foundation

enum AddType: String, Codable, Equatable{
    case home
    case store
}
public struct Address: Identifiable,Codable, Equatable {
    public var id: UUID = UUID()
    var type: AddType
    var name: String
    var address:String
    var latitude: Double
    var longitude: Double
 
}
