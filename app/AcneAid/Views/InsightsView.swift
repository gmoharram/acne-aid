//
//  InsightsView.swift
//  AcneAid
//
//  Created by Gana on 12/28/23.
//

import SwiftUI
import Charts // Assuming you're using the Charts library for the line chart

struct InsightsView: View {

    var body: some View {
        ScrollView {
            VStack {
                HeaderSection(sectionTitle: "Insights")
                    .padding(.bottom)
                DataSection()
                }
                
            }
        }
    }

struct DataSection: View {
    
    @State private var selectedTimeframe: Timeframe = .daily
    
    var body: some View {
        // Encouraging text
        //Text("Your Routine Score")
        //    .font(.title)
        //    .fontWeight(.semibold)
        //    .padding(.top)
        //HStack{
        //    Text("is")
        //    Text("78%")
        //        .foregroundColor(Color("Color2_500"))
        //}
        //.font(.title)
        //.fontWeight(.semibold)
        //Text("Keep it Going!")
        //    .font(.title)
        //   .fontWeight(.semibold)
        //   .padding(.bottom)
        
        // Statistics section
        HStack {
            StatisticView(iconName: "bubbles.and.sparkles", iconColor: "Color1_500", title: "50%", subtitle: "less acne ")
            StatisticView(iconName: "calendar", iconColor: "Color2_500", title: "13 days", subtitle: "stuck to routine")
            StatisticView(iconName: "camera.aperture", iconColor: "Color3_500", title: "7 days", subtitle: "selfie streak")
        }
        .padding(.horizontal)
        .padding(.top)
        
        // Link to more information
        HStack{
            Spacer()
            NavigationLink(destination: Text("More Info")) {
                Text("Tell me more >")
                    .font(.footnote)
                    .foregroundColor(Color("Color1_500"))
            }
            .padding(.horizontal)
            .offset(x: -10)
        }
        .padding(.bottom)
        
        
        
        // Timeframe selector
        HStack {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                Button(action: {
                    self.selectedTimeframe = timeframe
                }) {
                    Text(timeframe.rawValue)
                        .fontWeight(selectedTimeframe == timeframe ? .bold : .regular)
                        .foregroundColor(selectedTimeframe == timeframe ? .white : Color("Color1_500"))
                        .padding()
                        .background(selectedTimeframe == timeframe ? Color("Color1_500") : Color.clear)
                        .cornerRadius(20)
                }
                
            }
        }
        .padding(.top)
        
        Text("Percentage of Skin with Acne")
            .font(.title2)
        // Chart Here
        if self.selectedTimeframe == .daily {
            let data: [DailyDatapoint] =
            [
                DailyDatapoint(year: 2024, month: 2, day: 27, acnePercentage: 0.3),
                DailyDatapoint(year: 2024, month: 2, day: 28, acnePercentage: 0.29),
                DailyDatapoint(year: 2024, month: 2, day: 29, acnePercentage: 0.31),
                DailyDatapoint(year: 2024, month: 3, day: 1, acnePercentage: 0.27),
                DailyDatapoint(year: 2024, month: 3, day: 2, acnePercentage: 0.28),
                DailyDatapoint(year: 2024, month: 3, day: 3, acnePercentage: 0.28),
                DailyDatapoint(year: 2024, month: 3, day: 4, acnePercentage: 0.26),
                
                
            ]
            
            HStack {
                Spacer()
                Chart(data) {
                    LineMark(
                        x: .value("Day", $0.date),
                        y: .value("Percent Acne", $0.acnePercentage)
                    )
                    .foregroundStyle(Color("Color1_500"))
                    .lineStyle(StrokeStyle(lineWidth: 4))
                }
                .frame(height: 200)
                Spacer()
            }
            .padding()
        }
        else if self.selectedTimeframe == .weekly {
            let data: [WeeklyDatapoint] =
            [
                WeeklyDatapoint(year: 2024, month: 2, day: 27, weeklyAvgAcnePercentage: 0.4),
                WeeklyDatapoint(year: 2024, month: 3, day: 5, weeklyAvgAcnePercentage: 0.38),
                WeeklyDatapoint(year: 2024, month: 3, day: 12, weeklyAvgAcnePercentage: 0.4),
                WeeklyDatapoint(year: 2024, month: 3, day: 19,weeklyAvgAcnePercentage: 0.37),
                WeeklyDatapoint(year: 2024, month: 3, day: 26, weeklyAvgAcnePercentage: 0.32),
                WeeklyDatapoint(year: 2024, month: 4, day: 3,weeklyAvgAcnePercentage: 0.34),
                WeeklyDatapoint(year: 2024, month: 4, day: 10,weeklyAvgAcnePercentage: 0.3),
            ]
            HStack{
                Spacer()
                Chart(data) {
                    LineMark(
                        x: .value("Week", $0.date, unit: .weekOfYear),
                        y: .value("Percent Acne", $0.weeklyAvgAcnePercentage)
                    )
                    .foregroundStyle(Color("Color1_500"))
                    .lineStyle(StrokeStyle(lineWidth: 4))
                }
                .frame(height: 200)
                Spacer()
            }
            .padding()
        }
        else if self.selectedTimeframe == .monthly {
            let data: [MonthlyDatapoint] =
            [
                MonthlyDatapoint(year: 2023, month: 10, day: 31, monthlyAvgAcnePercentage: 0.4),
                MonthlyDatapoint(year: 2023, month: 11, day: 30, monthlyAvgAcnePercentage: 0.38),
                MonthlyDatapoint(year: 2023, month: 12, day: 31, monthlyAvgAcnePercentage: 0.4),
                MonthlyDatapoint(year: 2024, month: 1, day: 31, monthlyAvgAcnePercentage: 0.37),
                MonthlyDatapoint(year: 2024, month: 2, day: 29, monthlyAvgAcnePercentage: 0.32),
                MonthlyDatapoint(year: 2024, month: 3, day: 31, monthlyAvgAcnePercentage: 0.34),
            ]
            HStack{
                Spacer()
                Chart(data) {
                    LineMark(
                        x: .value("Month", $0.date, unit: .month),
                        y: .value("Percent Acne", $0.monthlyAvgAcnePercentage)
                    )
                    .foregroundStyle(Color("Color1_500"))
                    .lineStyle(StrokeStyle(lineWidth: 4))
                }
                .frame(height: 200)
                Spacer()
            }
            .padding()
        }
    }
}


// Statistic view component
struct StatisticView: View {
    let iconName: String
    let iconColor: String
    let title: String
    let subtitle: String
    

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(iconColor))
                .padding(.bottom)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.caption)
                .frame(width: 100)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 130)
        .padding(.horizontal)
        .background(.clear)
        .cornerRadius(10)
    }
}

// Timeframe selector enum
enum Timeframe: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

// Line Charts
struct DailyDatapoint: Identifiable {
    var id: UUID
    var date: Date
    var acnePercentage: Double
    
    init(year: Int, month: Int, day: Int, acnePercentage: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.id = UUID()
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.acnePercentage = acnePercentage
    }
}

struct WeeklyDatapoint: Identifiable {
    var id: UUID
    var date: Date
    var weeklyAvgAcnePercentage: Double
    
    init(year: Int, month: Int, day: Int, weeklyAvgAcnePercentage: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.id = UUID()
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.weeklyAvgAcnePercentage = weeklyAvgAcnePercentage
    }
}

struct MonthlyDatapoint: Identifiable {
    var id: UUID
    var date: Date
    var monthlyAvgAcnePercentage: Double
    
    init(year: Int, month: Int, day: Int, monthlyAvgAcnePercentage: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.id =  UUID()
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.monthlyAvgAcnePercentage = monthlyAvgAcnePercentage
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
