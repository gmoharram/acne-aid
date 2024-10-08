//
//  ContentView.swift
//  AcneAid
//
//  Created by Gana on 12/15/23.
//

import SwiftUI

struct SigninView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var successfulLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                
                Text("Welcome back 👋")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 100)
                
                
                TextField("Enter email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.horizontal)
                
                SecureField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.horizontal)
                
                Button(action: {
                    // Perform an action to reset password
                }) {
                    Text("Forgot password?")
                        .foregroundColor(Color("Color1_500"))
                }
                .padding(.bottom)
                
                // Sign-In Button
                Button(action: {
                    // Perform an action to sign in
                }) {
                    NavigationLink(destination: MainView()) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Color1_500"))
                            .cornerRadius(40)
                    }
                }
                .padding()
                
                /*
                // Alternative sign-in options
                Text("OR LOG IN WITH")
                    .foregroundColor(.gray)
                    .padding()
                
                HStack {
                    Button(action: {
                        // Perform Google Sign In
                    }) {
                        Image("GoogleRed")
                            .resizable()
                            .frame(width: 33, height: 33)
                    }
                    
                    Button(action: {
                        // Perform Apple Sign In
                    }) {
                        Image(systemName: "applelogo")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
                */
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Color1_500"))
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .padding(.bottom)
            
            }
            
        }
    }
}

#Preview {
    SigninView()
}
