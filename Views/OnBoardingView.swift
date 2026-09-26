//
//  OnBoardingView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/8/26.
//app storage for redisplay 

import SwiftUI



struct OnBoardingView: View {
   //MARK: non-mock
    @State private var addresses: [Address] = []
    @State private var goToDashboard: Bool = false

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
            ProgressView(
                value: Double(progress),
                total: 6
            )
            .padding(5)
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
                        AddressSearchView(editingAddressID: nil, type: .home)
                    } label: {

                        Image(
                            systemName:
                                homeAddress == nil
                                ? "plus"
                                : "pencil"
                        )
                        .onAppear{
                            loadAddresses()
                        }
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
                                    loadAddresses()
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
                Button("Reset Onboarding"){
                    UserDefaults.standard.removeObject(forKey: "savedAddresses")
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarindg")
                    
                }
                Button("Finish Setup All Addresses"){
                    hasCompletedOnboarding = true
                    
                }.disabled(homeAddress == nil)

                Divider()
            }
            .padding()
        }
        .onAppear {
            
            loadAddresses()
            NotificationManager.shared.requestPermission()   
        }
        .onChange(of: progress){oldValue, newValue in
            if newValue == 6{
                hasCompletedOnboarding = true
                goToDashboard = true
            }
        }
        .navigationDestination(isPresented: $goToDashboard) {
            DashboardContentView()
                .navigationBarBackButtonHidden(true)
        }
    }

    private func loadAddresses(){
        guard let data = UserDefaults.standard.data(
            forKey: "savedAddresses"
        ) else {
            addresses = []   
            return
        }
        do{
            addresses = try JSONDecoder().decode(
                [Address].self,
                from: data
            )
        } catch {
            print("Fail to load address: \(error)")
        }
    }
    
    private func checkOnboardingFinished(){
        if homeAddress != nil && storeAddresses.count>=5{
            hasCompletedOnboarding = true
        }
    }
    

}
