//
//  Hello_MapsApp.swift
//  Hello-Maps
//
//  Created by Mohammad Azam on 7/31/23.
//
import SwiftData
import SwiftUI

@main
struct BagItUp_App: App {
    @StateObject private var notificaitonManager = NotificationManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboaridng = false
    init(){_ = GeofenceManager.shared}
    
    
    var body: some Scene {
      
        WindowGroup {
            if !hasCompletedOnboaridng{
                OnBoardingView()
            }else if notificaitonManager.showBagConfirmation,
                     let tripID = notificaitonManager.currentTripID{
                BagConfirmationView(id: tripID)
            }else {
                RootView()
            
            }
            //based on onboarding process to see if need to open the app on onboaridn view
            
           
            }
      
        .modelContainer(for: [
            GroceryItem.self,
            Address.self,
            GeofenceLogEntry.self])
        
    }
}
