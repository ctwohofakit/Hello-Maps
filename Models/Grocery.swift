//
//  Untitled.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/24/26.
//

import Foundation

enum FoodCategory: String, Codable, Equatable{
    case protein = "Protein"
    case produce = "Produce"
    case meat = "Meat"
    case dairy = "Dairy"
    case dryfood = "Dryfood"
    case bakery = "Bakery"
    var id: String{self.rawValue}
    
}

struct Grocery{
    var id:UUID
    var foodName: String
    var foodcat: FoodCategory
    
}
