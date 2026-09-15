//
//  ContentView.swift
//  Hello-Maps
//
//  Created by Mohammad Azam on 7/31/23.
//

import SwiftUI
import MapKit // import map view
import CoreLocation
//import Combine

struct AddressSearchView: View {
    
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var results: [SearchResult] = []
    @State private var selectedLocation: MKMapItem?
    @State private var searchError: String = ""
    let editingAddressID: UUID?
    
    let type: AddType
    //    private var cancellables = Set <AnyCancellable>()
    
    @State private var position: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .automatic
    )
    
    var body: some View {
        VStack {
            Text(
                type == .home
                ? "Set Up Your Home Address"
                : "Add a Frequent Store"
            )
            HStack {
                TextField(type == .home ? "Enter your home addrss" : "Serach for a frequent store", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await searchAddress()
                        }
                    }
                
                Button {
                    Task {
                        await searchAddress()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 30, height: 30)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            
            Map(position: $position) {
                UserAnnotation()
                if let selectedLocation {
                    Marker(selectedLocation.name ?? "Selected Location",
                           coordinate: selectedLocation.placemark.coordinate)
                }
            }
            .padding()
            .task {
                locationManager.requestPermission()
            }
            
            if type == .store && !results.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(results) { result in
                            let store = result.mapItem
                            Button {
                                selectStore(store)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(store.name ?? "Unknown Store")
                                        .font(.headline)
                                    Text(LocationHelper.formatAddress(store.placemark))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .frame(width: 250, height: 100)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.blue, lineWidth: 2)
                        )
                    }
                }
            }
            
            HStack {
                Button {
                    saveSelectedAddress()
                    //saveStoreAddress()
                } label: {
                    Text(
                        type == .home ? "Confirm Adress" : "Confirm Store"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func searchAddress() async {
        
        let cleanedSearchText = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !cleanedSearchText.isEmpty else {
            searchError = "Please enter an address before searching."
            return
        }
        
        searchError = ""
        
        print("🔎 Searching for: \(cleanedSearchText)")
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = cleanedSearchText
        
        if type == .store,
           let home = loadAddress(ofType: .home).first {
            request.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D( //set serach request's region to home lat and long
                    latitude: home.latitude,
                    longitude: home.longitude
                ),
                span: MKCoordinateSpan( //zoom in or out
                    latitudeDelta: 0.1,
                    longitudeDelta: 0.1
                )
            )
        }
        do {
            let response = try await MKLocalSearch(request: request).start()
            
            results = response.mapItems.map { mapItem in
                SearchResult(mapItem: mapItem)
            }
            print("found \(results.count) results")
            
            if type == .home,
               let firstResult = results.first {
                selectedLocation = firstResult.mapItem
                let coordinate = firstResult.mapItem.placemark.coordinate
                
                position = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                              longitudeDelta: 0.01)
                    )
                )
            }
            
        } catch {
            searchError = "Search failed, please try again."
        }
        
    }
    
    private func selectStore(_ store: MKMapItem) {
        selectedLocation = store
        let coordinate = store.placemark.coordinate
        
        position = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        )
        print("Selected store: \(store.name ?? "Unknown")")
    }
    
    private func saveAddress(_ newAddress: Address) {
        var savedAddresses: [Address] = []
        
        if let data = UserDefaults.standard.data(forKey: "savedAddresses") {
            do {
                savedAddresses = try JSONDecoder().decode(
                    [Address].self,
                    from: data
                )
            } catch {
                print("fail to load address: \(error)")
            }
        }
        if newAddress.type == .home {
            savedAddresses.removeAll {
                $0.type == .home
            }
        }
        savedAddresses.append(newAddress)
        for address in savedAddresses {
            print("saved address \(address.type)")
            print("Address:\(address.address)")
        }
        do {
            let data = try JSONEncoder().encode(savedAddresses)
            UserDefaults.standard.set(
                data,
                forKey: "savedAddresses"
            )
            print("Address saved")
            dismiss()
        } catch {
            print("failed to save address: \(error)")
        }
    }
    
    private func saveSelectedAddress() {
        guard let selectedLocation else {
            searchError = "please selec a loation first"
            return
        }
        let placemark = selectedLocation.placemark
        let newAddress = Address(
            type: type,
            name: type == .home ? "Home" : selectedLocation.name ?? "Store",
            address: LocationHelper.formatAddress(placemark),
            latitude: placemark.coordinate.latitude,
            longitude: placemark.coordinate.longitude
        )
        saveAddress(newAddress)
    }
    
    private func loadAddress(ofType type: AddType) -> [Address] {
        guard let data = UserDefaults.standard.data(forKey: "savedAddresses") else {
            return []
        }
        do {
            let addresses = try JSONDecoder().decode([Address].self, from: data)
            return addresses.filter { $0.type == type }
        } catch {
            print("fail to load address error for type \(type): \(error))")
            return []
        }
    }
    
    func moveMapToHome() {
        guard type == .store else {
            return
        }
        guard let home = loadAddress(ofType: .home).first else {
            print("no home address found")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(
            latitude: home.latitude,
            longitude: home.longitude
        )
        
        position = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
        )
        print("map moved to home")
        print("found \(results.count) results")
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

//#Preview {
//    AddressSearchView(type: .home)
//}
