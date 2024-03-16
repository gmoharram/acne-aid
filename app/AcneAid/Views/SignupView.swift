//
//  SignupView.swift
//  AcneAid
//
//  Created by Gana on 12/15/23.
//

import SwiftUI

extension NSMutableData {
        func appendString(_ string: String) {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
            append(data!)
        }
    }

struct SignupView: View {
    @State private var showingSignUpForm = false
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Spacer()
                
                Image("IconImage")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                Text("Acne Aid")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Find the Skincare Routine that Works Best for You!")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Spacer()
                
                // Sign Up with Email Button
                Button(action: {
                    self.showingSignUpForm.toggle()
                }) {
                    Text("Sign Up with E-mail")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("Color1_500"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .padding()
                .sheet(isPresented: $showingSignUpForm){
                    SignupFormView()
                }
                
                /*
                // Continue with Apple Button
                Button(action: {
                    // Handle continue with Apple action
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Continue with Apple")
                    }
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(.horizontal)
                }
                .padding()
                
                Button(action: {
                    // Handle continue with Google action
                }) {
                    HStack {
                        Image("GoogleWhite")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Continue with Google")
                    }
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color("Color4_500"))
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(.horizontal)
                }
                .padding()
                 
                */
                
                
                VStack {
                    Text("By signing up you agree to our Terms and Conditions")
                    Text("See how we use your data in our Privacy Policy")
                }
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text("Have an account already?")
                    
                    NavigationLink(destination: SigninView()) {
                        Text("Sign in")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Color1_500"))
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SignupFormView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var userImage: Image = Image("DefaultAvatar")
    @State private var isShowingImagePicker: Bool = false
    @State private var inputImage: UIImage?
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    let sexes = ["Male", "Female", "Other"]
    @State private var selectedSex = "Female" // Default value
    @State private var birthdate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Button(action: {
                    self.isShowingImagePicker = true
                }) {
                    ZStack(alignment: .bottomTrailing) {
                        userImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .shadow(radius: 3)
                        
                        Image(systemName: "pencil.circle.fill")
                            .background(Circle().fill(Color.white))
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .padding(.horizontal)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .padding(.horizontal)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .padding(.horizontal)
                
                DatePicker("Birthday", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                    .padding()
                    .padding(.horizontal)
                    .accentColor(Color("Color1_500"))
                    
                
                Picker("Sex", selection: $selectedSex) {
                    ForEach(sexes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .padding(.horizontal)
                

                
                Button("Sign Up") {
                    self.signUp()
                }
                .padding()
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .background(Color("Color1_500"))
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding()
            }
            
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        userImage = Image(uiImage: inputImage)
    }
    
    // FastAPI
    // Struct that matches the expected signup post request body
    struct SignUpRequest: Codable {
        var username: String
        var email: String
        var password: String
        var birthdate: Date
        var sex: String
    }
    
    func signUp() {
        
        let signUpDetails = SignUpRequest(username: username, email: email, password: password, birthdate: birthdate, sex: selectedSex)
        
        guard let imageData = inputImage?.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        guard let url = URL(string: "https://yourserver.com/signup") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create a boundary string using a unique per-app string
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        
        // Add the signUpDetails part
        if let jsonData = try? JSONEncoder().encode(signUpDetails) {
            httpBody.append(convertFormField(named: "signUpDetails", value: jsonData, using: boundary))
        }
        
        // Add the image data part
        httpBody.append(convertFileData(fieldName: "profileImage",
                                        fileName: "\(username).jpeg",
                                        mimeType: "image/jpeg",
                                        fileData: imageData,
                                        using: boundary))
        
        // Add the closing boundary
        httpBody.appendString("--\(boundary)--")
        
        request.httpBody = httpBody as Data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response here
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(responseString)")
                    //save profile image?
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
    
    func convertFormField(named name: String, value: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("Content-Type: application/json\r\n\r\n")
        data.append(value)
        data.appendString("\r\n")
        
        return data as Data
    }

    func convertFileData(fieldName: String,
                         fileName: String,
                         mimeType: String,
                         fileData: Data,
                         using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }

}


#Preview {
    SignupView()
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
