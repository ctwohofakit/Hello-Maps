//
//  DashboardView.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/17/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: OnBoardingView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .padding()
                    }
                }
                Spacer()
                Text("Dashboard")
                    .font(.largeTitle)
                Spacer()
            }
        }
    }
}
