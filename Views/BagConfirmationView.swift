//
//  BagConfirmationView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/17/26.
//

import SwiftUI

struct BagConfirmationView: View {
    
    @State private var shoppingTrip: [ShoppingTrip] = []
    var body: some View {
        
        NavigationStack{
            VStack{
                Text("Did you remember to bring your resuable bag?")
                
                HStack{
                    Button{}label:{Text("I remember")}
                    Spacer()
                    Button{}label:{Text("I forgot")}
                }
            }
        }
        
    }
 //save with userDefaults
    
    
    
}
