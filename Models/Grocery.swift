//
//  GroceryItem.swift
//
//  Created by Kit Sitou on 9/24/26.
//

import Foundation
import SwiftData

@Model
final class GroceryItem{

    var foodName: String
    var foodcat: FoodCategory
    var isCompleted: Bool
    
    init( foodName: String, foodcat: FoodCategory, isCompleted:Bool = false) {

        self.foodName = foodName
        self.foodcat = foodcat
        self.isCompleted = isCompleted
    }
}


enum FoodCategory: String, Codable, CaseIterable{
    case protein = "Protein"
    case produce = "Produce"
    case meat = "Meat"
    case dairy = "Dairy"
    case dryfood = "Dryfood"
    case bakery = "Bakery"
    var id: String{self.rawValue}
    
}

