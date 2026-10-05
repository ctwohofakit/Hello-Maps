//
//  OnBoardingView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/8/26.
//app storage for redisplay 

import SwiftUI
import SwiftData

struct OnBoardingView: View {
   //MARK: non-mock
    @Query private var addresses:[Address]
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    private var homeAddress: Address? {
        addresses.first {
            $0.type == .home
        }
    }

    private var storeAddresses: [Address] {
        addresses.filter {
            $0.type == .store
        }
    }

    private var progress: Int {
        let homeCount = homeAddress == nil ? 0 : 1
        let storeCount = min(storeAddresses.count, 5)

        return homeCount + storeCount
    }

    var body: some View {
      

        NavigationStack {
            Text("\(progress)  of 6 onboaringg task completed!")
            ProgressView(
                value: Double(progress),
                total: 6
            )
            .scaleEffect(x: 1, y: 3, anchor: .center)
                        .padding()
            .frame(width: 200)
            .foregroundStyle(Color.accentColor.opacity(0.5))
            .padding(5)
            if progress == 6{
                Text("Please return to home tab to see your dashbaord")
                    .foregroundStyle(.mint)
                    .font(.caption).bold()
            }
            VStack(spacing: 20) {

                VStack {
                    Button("Allow Notifications") {
                        NotificationManager.shared.requestPermission()
                    }

                    Button("Test Notification") {
                        NotificationManager.shared.scheduleNotification()
                    }
                }

                // HOME
                HStack {

                    if let homeAddress {

                        VStack(alignment: .leading) {

                            Text("Home Address")
                                .font(.headline)
                                .foregroundStyle(.blue)

                            Text(homeAddress.address)
                                .foregroundStyle(.secondary)
                        }

                    } else {

                        Text("Please Add Home Address")
                    }

                    Spacer()

                    NavigationLink {
                        AddressSearchView(editingAddressID: homeAddress?.id, type: .home)
                    } label: {

                        Image(
                            systemName:
                                homeAddress == nil
                                ? "plus"
                                : "pencil"
                        )
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            LinearGradient(
                                colors: [
                                    .blue,
                                    .purple
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                    }
                }

                Divider()

                // STORES
                ForEach(0..<5, id: \.self) { index in

                    HStack {
                        
                        if index < storeAddresses.count {
                            
                            let store = storeAddresses[index]
                            
                            VStack(alignment: .leading) {
                                
                                Text("Frequent Shop At Store")
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                                
                                Text(store.name)
                                    .font(.headline)
                                
                                Text(store.address)
                                    .foregroundStyle(.secondary)
                            }
                            
                        } else {
                            if homeAddress == nil {
                                Text("Please Add your home address first")
                                    .foregroundStyle(.secondary)
                            }else{
                                Text("Pending Store Setup")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Spacer()
                        
                       
                        NavigationLink {
                            AddressSearchView(editingAddressID: index < storeAddresses.count ? storeAddresses[index].id : nil, type: .store)
                                .onDisappear {
           
                                }
                        } label: {
                            
                            Image(
                                systemName:
                                    index < storeAddresses.count
                                ? "pencil"
                                : "plus"
                            )
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                LinearGradient(
                                    colors: [
                                        .blue,
                                        .purple
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                        }
                        .disabled(homeAddress == nil)
                    }
                }
//                Button("Reset Onboarding"){
//                    hasCompletedOnboarding = false
//                    
//                }


                Divider()
            }
            .padding()
        }
        .onAppear {
            

            checkOnboardingFinished()
            NotificationManager.shared.requestPermission()
            GeofenceManager.shared.startMonitoring(stores: storeAddresses)
        }
        .onChange(of: storeAddresses){oldValue, newValue in
            GeofenceManager.shared.startMonitoring(stores: storeAddresses)
        }
        .onChange(of: progress) { oldValue, newValue in

            if newValue >= 6 {
                hasCompletedOnboarding = true
            }
        }
    }

 
    
    private func checkOnboardingFinished(){
        if homeAddress != nil && storeAddresses.count>=5{
            hasCompletedOnboarding = true
            
        }
    }
    

}
