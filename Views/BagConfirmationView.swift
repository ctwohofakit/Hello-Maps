//
//  BagConfirmationView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/17/26.
//

import SwiftUI

struct BagConfirmationView: View {
    
    @State private var shoppingTrip: [ShoppingTrip] = []
    
    let id: UUID
    var body: some View {
        
        VStack{
            
            
            VStack{
                Text("Did you remember to bring your resuable bag?")
                    .foregroundStyle(.blue)
                    .font(.title)
                HStack{
                    Button{
                        updateTrip(id: id, result: .confirmed)
                        NotificationManager.shared.showBagConfirmation = false
                        
                    }label:{Text("🎉 I remember")}
                        .buttonStyle(.bordered)
                              .controlSize(.large)
                              .buttonBorderShape(.automatic)
     

                    Spacer()
                    Button{
                        updateTrip(id: id, result:.forgotten)
                        NotificationManager.shared.showBagConfirmation = false
                        
                    }label:{Text("😭 I forgot")}
                        .buttonStyle(.bordered)
                              .controlSize(.large)
                              .buttonBorderShape(.automatic)
                     

                }.padding()
                    .frame(width:335, height:500)
                    .background(.butterfly)
                    .cornerRadius(12)
                
            }
            
        }
        
        /*
         ShoppingTrip
         id: ABC123
         storeName: Costco
         date: Sep 19
         bagResult: unknown
         */
    }
    
    private func loadTrip()->[ShoppingTrip]{
        guard let data = UserDefaults.standard.data(
            forKey: "savedTrips"
        ) else {
            return []
        }
        do {
            
            let trips = try JSONDecoder().decode(
                [ShoppingTrip].self,
                from: data
            )
            
            return trips
            
        } catch {
            
            print("Failed to load shopping trips: \(error)")
            return []
        }
    }
    
    private func updateTrip(id: UUID, result: BagResult){
        var trips = loadTrip()
        guard let index = trips.firstIndex(where: { $0.id == id }) else {
            print("trip not found")
            return
        }
        trips[index].bagResult = result
        
        do{
            let data = try JSONEncoder().encode(trips)
            UserDefaults.standard.set(
                data,
                forKey: "savedTrips"
            )
            print("Trip update: \(result)")
        }catch {
            print("failed to update trip: \(error)")
        }
        
        
    }
    
}
