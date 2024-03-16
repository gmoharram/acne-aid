//
//  SelfieView2.swift
//  AcneAid
//
//  Created by Gana on 12/28/23.
//

import SwiftUI
import UIKit

// SwiftUI view that presents the image picker
struct TakeSelfieView: View {
    @State private var isShowingImagePicker = false
    @State private var image: Image? = nil

    var body: some View {
        VStack {
            // The image that was taken, if available
            image?
                .resizable()
                .scaledToFit()
            
            Button("Take A Selfie") {
                // Present the image picker when the button is tapped
                isShowingImagePicker = true
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            // Use the ImagePicker view below
            SelfiePicker(image: $image, sourceType: .camera)
        }
    }
}

// UIViewControllerRepresentable wrapper for UIImagePickerController
struct SelfiePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: SelfiePicker
        
        init(_ parent: SelfiePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// Preview of the SwiftUI view
struct TakeSelfieView_Previews: PreviewProvider {
    static var previews: some View {
        TakeSelfieView()
    }
}
