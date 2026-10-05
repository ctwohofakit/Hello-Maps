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
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "apple.meditate.circle.fill")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("GROCERIES")
                    .font(.title)
                
            }.foregroundStyle(LinearGradient(
                colors: [
                    .blue,
                    .purple
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .padding()
            HStack{
                TextField("Enter grocery item...", text: $name)
                    .border(Color.butterfly, width: 2)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                       addGrocery()
                    }
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
                ForEach(FoodCategory.allCases, id:\.self){ foodCategory in
               //filter first
                    let categoryItems = items.filter{
                        $0.foodcat == foodCategory
                    }
                    
                    if !categoryItems.isEmpty{
                        
                        Section{
                            
                            ForEach(categoryItems){item in
                                //add a bindable row view
                                
                                GroceryRowView(item: item)
                                
                            }.onDelete(perform: deleteGrocery)
                            
                            
                        } header:{
                            HStack{
                                Image(systemName: foodCategory.icon)
                                //                                    .resizable()
                                //                                    .foregroundStyle(.leaf)
                                Text(foodCategory.rawValue.uppercased())
                                    .font(.headline)
                                
                            }
                            
                        }
                        
                    }
                    
                }
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
