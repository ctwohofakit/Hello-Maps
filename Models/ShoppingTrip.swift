//
//  ShoppingTrip.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/17/26.
//

import Swift
import Foundation

enum BagResult: String, Codable{
    case confirmed
    case forgotten
    case unknown //user didn't answer
}

struct ShoppingTrip: Identifiable, Codable{
    var id: UUID = UUID()
    var storeID: UUID
    var storeName: String
    var date:Date
    var bagResult: BagResult = .unknown
    
}
