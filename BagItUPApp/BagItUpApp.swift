//
//  Hello_MapsApp.swift
//  Hello-Maps
//
//  Created by Mohammad Azam on 7/31/23.
//

import SwiftUI

@main
struct BagItUp_App: App {
    @StateObject private var notificaitonManager = NotificationManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboaridng = false
    
    var body: some Scene {
      
        WindowGroup {
            if !hasCompletedOnboaridng{
                OnBoardingView()
            }else if notificaitonManager.showBagConfirmation{
                BagConfirmationView()
            }else {
                DashboardView()
            }
            
         
        }
    }
}
