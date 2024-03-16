//
//  TabView.swift
//  AcneAid
//
//  Created by Gana on 12/27/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            
            RoutinesView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Routines")
                }
            InsightsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Insights")
                }
        }
        .accentColor(Color("Color1_500"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
