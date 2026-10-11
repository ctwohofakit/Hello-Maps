//
//  rootView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 10/4/26.
//
import SwiftUI
import SwiftData

struct RootView: View{
    
    @Query private var addresses: [Address]
    private var storeAddresses:[Address]{addresses.filter{$0.type == .store}}
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            GroceryListView()
                .tabItem{
                    Label("Groceries", systemImage: "fork.knife.circle")
                }
                .tag(1)
            OnBoardingView()
                .tabItem {
                    Label("Address", systemImage: "mappin.and.ellipse")
                }
                .tag(2)
            
    }.onAppear{
        GeofenceManager.shared.startMonitoring(stores: storeAddresses)
    }
    }
    
}
