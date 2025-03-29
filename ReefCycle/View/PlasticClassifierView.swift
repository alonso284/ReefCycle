//
//  PlasticClassifier.swift
//  ReefCycle
//
//  Created by Felipe Alonzo on 28/03/25.
//


import SwiftUI
import Vision
import CoreML
import AVFoundation

struct PlasticClassifierView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationResult: String = "No classification yet"
    @State private var isShowingCamera = false
    
    var body: some View {
        ZStack {
            Color.clear
                       .overlay (
                           Image("ReefBackgroundWide")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
//                               .border(.blue, width: 2)
                       )
                       .clipped()
                       .ignoresSafeArea()
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .foregroundColor(.gray)
                }
                
                Text(classificationResult)
                    .padding()
                
                Button("Take Photo") {
                    isShowingCamera = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraView(image: $selectedImage, onImageCaptured: classifyImage)
        }
    }
    
    func classifyImage() {
        guard let image = selectedImage,
              let ciImage = CIImage(image: image) else {
            classificationResult = "Failed to prepare image for classification"
            return
        }
        
        // Replace YourModelName with the actual name of your model class
        do {
            // Load your ML model
            let model = try BottleAmountClassifier_1()
            
            // Create a Vision request using your Core ML model
            let request = VNCoreMLRequest(model: try VNCoreMLModel(for: model.model)) { request, error in
                if let error = error {
                    self.classificationResult = "Error: \(error.localizedDescription)"
                    return
                }
                
                // Process classification results
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    self.classificationResult = "No classification results"
                    return
                }
                
                // Update UI with the classification result
                DispatchQueue.main.async {
                    self.classificationResult = "\(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                }
            }
            
            // Perform the request
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
            
        } catch {
            classificationResult = "Error loading model: \(error.localizedDescription)"
        }
    }
}

// Camera View component using UIViewControllerRepresentable
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImageCaptured: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.onImageCaptured()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


