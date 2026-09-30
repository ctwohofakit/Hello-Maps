//
//  GroceryListView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/24/26.
//

import SwiftUI
import SwiftData

struct GroceryListView: View{
    var grocery:GroceryItem?
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \GroceryItem.foodName, order: .forward)private var items:[GroceryItem]
    //query for each category for display with lazy vstck?
    
    //empty variable setup
    @State var name: String = ""
    @State var category: FoodCategory = .produce
    
               

    var body: some View{
        VStack{
            
            HStack{
                TextField("Enter grocery item...", text: $name)
                    .textFieldStyle(.roundedBorder)
                Picker("category", selection: $category){
                    ForEach(FoodCategory.allCases, id: \.self){category in
                        Text(category.rawValue).tag(category)
                    }
                }
                Button(action: addGrocery){
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }.padding()
            
            List{
            ForEach(items){item in
                //add a bindable row view

                GroceryRowView(item: item)
                
                }.onDelete(perform: deleteGrocery)
            }
            
            
        }
    }
    private func addGrocery(){
        let newItem = GroceryItem(
            foodName: name, foodcat: category, isCompleted: false
        )
        modelContext.insert(newItem)
        
        name = "" // clear input
    }
    
    private func deleteGrocery(at offsets: IndexSet){
        for index in offsets{
            let item = items[index]
            modelContext.delete(item)
        }
    }
}
