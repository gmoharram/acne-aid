//
//  SelfieView.swift
//  AcneAid
//
//  Created by Gana on 12/28/23.
//

import SwiftUI
import AVFoundation

struct SelfieView: View {
    @Binding var showSelfieView: Bool
    
    @ObservedObject var viewModel = CameraViewModel()
    
    @State private var isFocused = false
    @State private var isScaled = false
    @State private var focusLocation: CGPoint = .zero
    @State private var currentZoomFactor: CGFloat = 1.5
    
    func openSettings() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    var body: some View {
            VStack(alignment: .center){
                // Top bar with title
                HStack {
                    Button(action: {
                        self.showSelfieView = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    
                    Text("But first... Let me Take A Selfie")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(.clear)
                .padding()
                
                GeometryReader { geometry in
                    ZStack {
                        Color.black.edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 0) {
                            ZStack {
                                CameraPreview(session: viewModel.session) { tapPoint in
                                    viewModel.zoom(with: self.currentZoomFactor)
                                    isFocused = true
                                    focusLocation = tapPoint
                                    viewModel.setFocus(point: tapPoint)
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                                .gesture(MagnificationGesture()
                                    .onChanged { value in
                                        self.currentZoomFactor += value - 1.0 // Calculate the zoom factor change
                                        self.currentZoomFactor = min(max(self.currentZoomFactor, 0.5), 10)
                                        self.viewModel.zoom(with: currentZoomFactor)
                                    })
        //                        .animation(.easeInOut, value: 0.5)
                                
                                if isFocused {
                                    FocusView(position: $focusLocation)
                                        .scaleEffect(isScaled ? 0.8 : 1)
                                        .onAppear {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                                self.isScaled = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                    self.isFocused = false
                                                    self.isScaled = false
                                                }
                                            }
                                        }
                                }
                            }
                            
                            HStack {
                                PhotoThumbnail(image: $viewModel.capturedImage)
                                Spacer()
                                CaptureButton { viewModel.captureImage() }
                                Spacer()
                                CameraSwitchButton { viewModel.switchCamera() }
                            }
                            .padding(20)
                        }
                    }
                    .alert(isPresented: $viewModel.showAlertError) {
                        Alert(title: Text(viewModel.alertError.title), message: Text(viewModel.alertError.message), dismissButton: .default(Text(viewModel.alertError.primaryButtonTitle), action: {
                            viewModel.alertError.primaryAction?()
                        }))
                    }
                    .alert(isPresented: $viewModel.showSettingAlert) {
                        Alert(title: Text("Warning"), message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."), dismissButton: .default(Text("Go to settings"), action: {
                            self.openSettings()
                        }))
                    }
                    .onAppear {
                        viewModel.setupBindings()
                        viewModel.requestCameraPermission()
                    }
                }
        }
            .background(.black)
    }
}

struct PhotoThumbnail: View {
    @Binding var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
            } else {
                Rectangle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.black)
            }
        }
    }
}

struct CaptureButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .shadow(color: .white, radius:3)
                .foregroundColor(Color("Color1_500"))
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 4)
                        .frame(width: 55, height: 55, alignment: .center)
                )
        }
    }
}

struct CameraSwitchButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
        }
    }
}

struct FocusView: View {
    
    @Binding var position: CGPoint
    
    var body: some View {
        Circle()
            .frame(width: 70, height: 70)
            .foregroundColor(.clear)
            .border(Color.yellow, width: 1.5)
            .position(x: position.x, y: position.y)
    }
}

struct SelfieView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showSelfieView: Bool = true
        SelfieView(showSelfieView: $showSelfieView)
    }
}
