//
//  GroceryRowView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/26/26.
//
import SwiftUI
struct GroceryRowView: View {
    @Bindable var item:GroceryItem
    
    var body: some View{
        
                HStack{
                    
                    Button{
                        item.isCompleted.toggle()
                    }label:{
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                    .buttonStyle(.plain)
                    
                    TextField("grocery item", text: $item.foodName)
                        .strikethrough(item.isCompleted)
                    
                }
                
            
        
    }
}
