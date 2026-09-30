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
    let id: UUID = UUID()
    
    var body: some Scene {
      
        WindowGroup {
            if !hasCompletedOnboaridng{
                OnBoardingView()
            }else if notificaitonManager.showBagConfirmation{
                BagConfirmationView(id: id)
            }else {
                TabView {
                    DashboardContentView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    GroceryListView()
                        .tabItem{
                            Label("Grocery", systemImage: "fork.knife.circle")
                        }
                    OnBoardingView()
                        .tabItem {
                            Label("Address", systemImage: "mappin.and.ellipse")
                        }
                    FieldTestView()
                        .tabItem {
                            Label("FieldTestView", systemImage: "gear")
                        }
            }
            //based on onboarding process to see if need to open the app on onboaridn view
            
           
            }
        }
        .modelContainer(for: GroceryItem.self)
    }
}
