//
//  RoutinesView.swift
//  AcneAid
//
//  Created by Gana on 12/27/23.
//

import SwiftUI

struct RoutinesView: View {
    
    var body: some View {
        NavigationStack {
            HeaderSection(sectionTitle: "Routines")
            RoutineListSection()
        }
    }
}

#Preview {
    RoutinesView()
}

struct Routine: Identifiable {
    let id = UUID()
    var name: String
    var daysTotal: Int
    var isActive: BooleanLiteralType
    // Add icon properties based on your design
    var iconName: String = "drop.fill"
    var iconColor: Color = .white
    var iconBackgroundColor: Color = Color("Color1_500")
}

struct RoutineListSection: View {
    
    @State private var routines: [Routine] = [
        Routine(name: "Simple", daysTotal: 29, isActive: true),
        Routine(name: "Adapalene", daysTotal: 67, isActive: false),
        Routine(name: "Combined", daysTotal: 2, isActive: false)
    ]
    
    var body: some View {
            ZStack {
                List {
                    ForEach($routines) { $routine in
                        HStack {
                            Image(systemName: routine.iconName) // Replace with your actual icons
                                .foregroundColor(routine.iconColor) // Set icon color based on routine
                                .frame(width: 44, height: 44) // Set frame for uniform sizing
                                .background(routine.iconBackgroundColor) // Set background color based on routine
                                .cornerRadius(10) // Round the corners
                            
                            VStack(alignment: .leading) {
                                Text(routine.name)
                                    .fontWeight(.medium)
                                Text("\(routine.daysTotal) days total")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink (destination: SingleRoutineView(routine: routine)){
                                    
                                    Toggle(isOn: $routine.isActive) {
                                        // Empty to hide the label
                                    }
                                    
                                }
                        }
                    }
                    .listRowBackground(Color.white) // Set the list row background to clear
                    // Add routine button
                    Button(action: {
                        // Handle the add routine action
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color1_500"))
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center the button
                    .listRowBackground(Color.white)
                }
            }
            VStack{
                Text("")
            }
            .background(.white)
    }
}

struct SingleRoutineView: View {
    let routine: Routine
    var body: some View {
        NavigationView {
            VStack{
                // Header with icon and title
                Text("routine.name")
                        .font(.title2)
                        .fontWeight(.bold)
            }
            
        }
    }
}
