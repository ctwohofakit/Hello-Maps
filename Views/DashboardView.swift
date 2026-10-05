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
    
    /*
     successful rate:
     from shoppingtrip
     .confirm count
     .forgotten count
     
     total = confirmed + forgotten
     successful rate = confirmed/ total
     
     
     */
    //alltime shoppingTrip, confirmation count
    private var confirmedCount: Int {
        shoppingTrips.filter{ trip in
            trip.bagResult == .confirmed
        }.count
    }
    //forgottern count
    private var forgottenCount: Int{
        shoppingTrips.filter{trip in
            trip.bagResult == .forgotten
        }.count
    }
    private var totalTrips: Int {
        confirmedCount + forgottenCount
    }
    
    private var successfulRate: Double{
        guard totalTrips > 0 else{
            return 0
        }
        return Double(confirmedCount)/Double(totalTrips)
    }
    private var bagResult: BagResult?
    
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
                    
                    .padding()
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
                    
                    .padding()
                    .background(.leaf)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    //mark: -- right matrix
                    
                    HStack{
                        Image(systemName: "leaf.circle.fill")
                            .font(.caption2).bold()
                            .foregroundStyle(.pink.opacity(0.5))
                        VStack (alignment: .leading){
                            Text("\(currentTripStreak)") //how many bag saved
                            Text("Trip streak")
                                .font(.title3)
                            Text("at most")
                                .font(.caption)
                        }
                    }
                    
                    
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
                VStack(alignment: .center){
                    Section{
                        
                        HStack{
                            Image(systemName: "bag.fill")
                                .foregroundStyle(.purple.opacity(0.5))
                            Text("Bag Success Rate:")
                        }
                        .font(.title2)
                        HStack{
                            ZStack{
                                Circle()
                                    .stroke(
                                        Color.gray.opacity(0.2),
                                        lineWidth: 10
                                    )
                                
                                Circle()
                                    .trim(
                                        from: 0,
                                        to: successfulRate
                                    )
                                    .stroke(
                                        Color.butterfly,
                                        style: StrokeStyle(
                                            lineWidth: 10,
                                            lineCap: .round
                                        )
                                    )
                                    .rotationEffect(.degrees(-90))
                                Text("\(Int(successfulRate*100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.butterfly)
                                
                            }
                            Spacer(minLength: 1)
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(Color.purple.opacity(0.5))
                                    Text("\(confirmedCount) Confirmed")
                                }
                                
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(Color.mint.opacity(0.5))
                                    Text("\(forgottenCount) Forgot")
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
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
    
    private var currentTripStreak: Int{
        let answeredTrips = shoppingTrips.filter{trip in
            trip.bagResult != nil
        }.sorted{ firstTrip, secondTrip in
            firstTrip.date > secondTrip.date
            
        }
        var streak = 0
        for trip in answeredTrips{
            if trip.bagResult == .confirmed{
                streak += 1
            }else{
                break
            }
            
        }
        return streak
    }
    
}
