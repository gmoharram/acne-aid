//
//  HomeView.swift
//  AcneAid
//
//  Created by Gana on 12/22/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HeaderSection(sectionTitle: "Home")
                SelfieSection()
                // RoutineScoreSection()
                InfoSection()
                FeedbackSection()
            }
        }
    }
}

#Preview {
    HomeView()
}

struct HeaderSection: View {
    let sectionTitle: String
    @State private var profileImage: Image = Image("DefaultAvatar") // Replace with profile image from server
    // Computed property to format and return the current date
    var formattedDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd MMM" // Example: Tue 11 Jul
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("IconImage")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .offset(x: 20)
                
                Spacer()
                
                NavigationLink(destination: ProfileView()){
                    ZStack(alignment: .bottomTrailing){
                        profileImage
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        
                        Circle()
                            .frame(width:15, height: 15)
                            .foregroundColor(Color("Color2_500"))
                    }
                    .offset(x: -20)
                }
            }
            
            Text(formattedDate)
                .offset(x:20)
                .padding(.top)
                .fontWeight(.bold)
                .foregroundColor(Color("Color0_600"))
            
            HStack{
                Text(sectionTitle)
                    .offset(x:20)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: ImagesView()){
                    HStack{
                        Image("PictureIcon")
                            .resizable()
                            .frame(width:20, height: 20)
                        Text("All Images")
                            .fontWeight(.semibold)
                        
                        
                    }
                    .frame(width: 130, height: 30)
                    .background(.white)
                    .foregroundColor(Color("Color1_500"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color("Color1_500"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)
                }
            }
        }
    }
}


struct SelfieSection: View {
    @State private var isAuthorized = false
    @State private var showSelfieView = false
    
    func setUpCaptureSession() async {
        if isAuthorized {
            // Set up the capture session.
            // Present the SelfieView if the user is authorized.
            showSelfieView = true
        } else {
            // Handle the unauthorized case, possibly alert the user.
        }
    }
    
    func checkAuthorization() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            isAuthorized = true
        } else if status == .notDetermined {
            isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
        }
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 5)
                    .foregroundColor(Color("Color1_500"))
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                VStack {
                    Image("CaptureIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.purple)
                    
                    Button(action: {
                        Task{
                            await setUpCaptureSession()
                        }
                    }) {
                        Text("TAKE SELFIE")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: 200)
                                .padding()
                                .background(Color("Color1_500"))
                                .cornerRadius(20)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            .onAppear {
                Task {
                    await checkAuthorization()
                }
            }

        }
        .padding(.horizontal)
        .sheet(isPresented: $showSelfieView) {
            SelfieView(showSelfieView: $showSelfieView)
        }
    }
}

struct RoutineScoreSection: View {
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text("Routine Score")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                    
                }
                
                HStack {
                    Text("Based on your skin tracking, your routine score is 78. Keep the routine going!")
                        .foregroundColor(Color("Color0_600"))
                    Spacer()
                    Rectangle()
                        .frame(width: 40)
                        .opacity(0.0)
                    
                }
                
                Button(action: {}) {
                    Text("Tell me more >")
                        .foregroundColor(Color("Color1_500"))
                        .font(.footnote)
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color("Color1_100"))
            .cornerRadius(20)
            .padding(.horizontal)
            .overlay(
                Text("78")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color("Color2_500"))
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 10, bottomTrailing: 10)))
                    .alignmentGuide(HorizontalAlignment.trailing) { d in d[.trailing] + 40 }
                    .alignmentGuide(VerticalAlignment.top) { d in d[.top] },
                alignment: .topTrailing
            )
        }
    }
}

struct InfoSection: View {
    var body: some View {
        VStack{
            Button(action: {}) {
                Text("SET ROUTINE")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Color2_800"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Color2_500"))
                    .cornerRadius(20)
            }
            .padding(.bottom)
            .padding(.horizontal)

            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        Rectangle()
                            .frame(width:70)
                            .opacity(0)
                        Image("CreamIcon")
                            .resizable()
                    }
                    .padding()
                    HStack{
                        Text("Current Routine")
                            .font(.headline)
                        
                    }
                    .padding(.horizontal)
                    HStack{
                        Text("Simple")
                            .font(.title)
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("started 15 days ago")
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(Color("Color1_500"))
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.leading)
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                
                VStack(alignment: .leading) {
                    HStack{
                        Rectangle()
                            .frame(width:70)
                            .opacity(0)
                        Image("CalendarIcon")
                            .resizable()
                        
                    }
                    .padding()
                    
                    HStack{
                        Text("Tracking Streak")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("12 days")
                            .font(.title)
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("updated today")
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(Color("Color1_100"))
                .foregroundColor(Color("Color0_600"))
                .cornerRadius(20)
                .padding(.trailing)
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            }
            
            HStack() {
                Image("TipsBackgroundImage") // Replace with your actual image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100) // Adjust the width as needed
                
                VStack(alignment: .leading) { // Adjust spacing as needed
                    Text("Skincare Tip #312")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Less is more when it comes to skin care. Using too many products can irritate your skin. Instead, focus on the basics, such as a gentle cleanser, sunscreen, and moisturizer.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                
            }
            .background(Color.white) // Set the background of the card
            .cornerRadius(15) // Round the corners of the card
            .shadow(radius: 2)
            .padding()
        }
    }
}

struct FeedbackSection: View {
    var body: some View {
        Button(action: {}) {
            HStack{
                Image("LightbulbIcon")
                    .resizable()
                    .frame(width:30, height:30)
                    .padding(.leading)
                Text("GIVE US FEEBACK")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color("Color3_500"))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
