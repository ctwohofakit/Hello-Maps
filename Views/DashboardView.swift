//
//  DashboardView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/17/26.
//
import Charts
import SwiftUI

struct DashboardContentView: View {
    @State private var shoppingTrips: [ShoppingTrip] = []
    @State private var breathe = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack {
                    Image("appLogo")
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading){
                        Text("Bag It Up")
                            .font(.title)
                        Text("Small Habits, a greener tomorrow.")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                    
                    Spacer()
                    NavigationLink(destination: FieldTestView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Hi,")
                            .font(.title2)
                        Text("you have finished all the onboraidng task")
                            .font(.caption).bold().foregroundStyle(.purple )
                        Text("Great Job keeping the habit going!")
                            .font(.caption).bold().foregroundStyle(.mint )
                    }
                    Spacer()
                    Text("Reusable bags make a difference!")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(width: 100, height:100)
                        .background(.purple.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius:10))
                }
                
                HStack{
                    HStack{
                        Image(systemName: "cart.circle.fill")
                            .font(.caption2).bold()
                            .foregroundStyle(.pink.opacity(0.5))
                        VStack (alignment: .leading){
                            Text("\(tripsThisWeek)")
                            Text("Shopping Trips")
                                .font(.title3)
                            Text("this week")
                                .font(.caption)
                        }
                    }
                    .border(Color.blue, width: 2)
                    .padding()
                    .background(.butterfly)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    //mark: -- right matrix
                    HStack{
                        Image(systemName: "leaf.circle.fill")
                            .font(.caption2).bold()
                            .foregroundStyle(.mint.opacity(0.7))
                        VStack (alignment: .leading){
                            Text("\(tripsThisWeek)") //how many bag saved
                            Text("Bags Saved")
                                .font(.title3)
                            Text("this week")
                                .font(.caption)
                        }
                    }
                    .border(Color.blue, width: 2)
                    .padding()
                    .background(.leaf)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                HStack{
                    HStack{
                        Image(systemName: "cart.circle.fill")
                            .font(.caption2).bold()
                            .foregroundStyle(.pink.opacity(0.5))
                        VStack (alignment: .leading){
                            Text("\(tripsThisWeek)")
                            Text("Estimated Saved")
                                .font(.title3)
                            Text("this week")
                                .font(.caption)
                        }
                    }
                    .border(Color.blue, width: 2)
                    .padding()
                    .background(.leaf)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    //mark: -- right matrix
                    HStack{
                        Image(systemName: "leaf.circle.fill")
                            .font(.caption2).bold()
                            .foregroundStyle(.pink.opacity(0.5))
                        VStack (alignment: .leading){
                            Text("\(tripsThisWeek)") //how many bag saved
                            Text("Trip Streak")
                                .font(.title3)
                            Text("this week")
                                .font(.caption)
                        }
                    }
                    .border(Color.blue, width: 2)
                    .padding()
                    .background(.peach)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Text("Shopping Trips This Week")
                    .disabled(tripsThisWeek == 0)
                
                if tripsThisWeek == 0 {
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(breathe ? .purple : .pink )
                            .symbolEffect(.bounce, value: breathe)
                        Text("There is no data currently, pleas finish your fist trip to see chart below.")
                            .foregroundStyle(.red.opacity(0.7))
                            .font(.caption).bold()
                    }
                    .onAppear{
                        breathe.toggle()
                    }
                    .animation(.easeInOut(duration: 0.8), value: breathe)
                }
                
                Chart(bagsSavedByDay) { day in
                    BarMark(
                        x: .value("Weekday", day.day),
                        y: .value("Bag Saved", day.count)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.blue, .purple],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
                .frame(height: 100)
                .font(.largeTitle)
                Spacer()
            }
            .padding()
            .background(.dashBackground)
            .onAppear{
                loadTrips()
            }
        }
    }
    
    private func loadTrips(){
        guard let data = UserDefaults.standard.data(forKey: "savedTrips") else {
            shoppingTrips = []
            return
        }
        do {
            shoppingTrips = try JSONDecoder().decode([ShoppingTrip].self, from: data)
        } catch {
            print("failed to load trips: \(error)")
            shoppingTrips = []
        }
    }
    
    private var tripsThisWeek: Int {
        shoppingTrips.filter { trip in
            Calendar.current.isDate(
                trip.date,
                equalTo: Date(),
                toGranularity: .weekOfYear
            )
        }.count
    }
    
    private var bagsSavedThisWeek: Int {
        shoppingTrips.filter { trip in
            Calendar.current.isDate(trip.date, equalTo: Date(), toGranularity: .weekOfYear) &&
            trip.bagResult == .confirmed
        }.count
    }
    
    private var bagsSavedByDay: [DailyBagCount] {
        let weekdays = ["Mon", "Tues", "Wed", "Thur","Fri", "Sat","Sun"]
        var result: [DailyBagCount] = []
        
        for day in weekdays {
            var count = 0
            for trip in shoppingTrips {
                let isCurrentWeek = Calendar.current.isDate(trip.date, equalTo: Date(), toGranularity: .weekOfYear)
                let tripDay = trip.date.formatted(
                    .dateTime.weekday(.abbreviated)
                )
                if isCurrentWeek && trip.bagResult == .confirmed && tripDay == day {
                    count += 1
                }
            }
            result.append(DailyBagCount(day: day, count: count))
        }
        return result
    }
}

struct DashboardView: View {
    var body: some View {
        TabView {
            DashboardContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            OnBoardingView()
                .tabItem {
                    Label("Address", systemImage: "mappin.and.ellipse")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
