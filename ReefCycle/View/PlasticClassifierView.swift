import SwiftUI
import Vision
import CoreML
import AVFoundation

struct PlasticClassifierView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationResult: String?
    @State private var classificationConfidence: Int?
    @State private var isShowingCamera = false
    @State private var isShowingAR = false
    @State private var isShowingInfo = false

    @State private var hasLaunched = false
    @State private var animateContent = false
    
    private let labelDescriptions: [String: String] = [
        "1_polyethylene_PET": "Polietileno Tereftalato (PET)",
        "2_high_density_polyethylene_PE-HD": "Polietileno de Alta Densidad (HDPE)",
        "3_polyvinylchloride_PVC": "Cloruro de Polivinilo (PVC)",
        "4_low_density_polyethylene_PE-LD": "Polietileno de Baja Densidad (LDPE)",
        "5_polypropylene_PP": "Polipropileno (PP)",
        "6_polystyrene_PS": "Poliestireno (PS)",
        "7_other_resins": "Otros Plásticos",
        "8_no_plastic": "Sin Plástico Detectado"
    ]
    
    
    // Card dimensions
    private let cardWidth: CGFloat = 320
    private let cardHeight: CGFloat = 420
    
    var body: some View {
        ZStack {
            // Background - kept as requested
            
            ZStack{
                Image("ReefBackgroundWide")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            .overlay(Color("ReefyBlue").opacity(0.5))
            
            
            // Main content
            VStack {
                Spacer()
                if let image = selectedImage {
                    // Results View
                    resultsView(image: image)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                } else {
                    // Options View
                    HStack(spacing: 24) {
                        // AR Demo Card
                        optionCard(
                            icon: "arkit",
                            title: "Clasificando Plasticos",
                            description: "Prueba un demo de separación de basura reciclable en tiempo real manualmente",
                            buttonLabel: "Probar Demo"
                        ) {
                            isShowingAR = true
                        }
                        
                        // Camera Card
                        optionCard(
                            icon: "camera.viewfinder",
                            title: "Clasificador Inteligente",
                            description: "Apunta tu camara al lado inferior de un botellas de plástico para clasificarla con Machine Learning",
                            buttonLabel: "Tomar Foto"
                        ) {
                            isShowingCamera = true
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .padding()
            
            // Camera overlay
            if isShowingCamera {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                
                CameraView(image: $selectedImage) {
                    withAnimation(.spring()) {
                        classifyImage()
                        isShowingCamera = false
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
            }
            
            // AR overlay
            if isShowingAR {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                
                ARContentView()
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation {
                                isShowingAR = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingInfo) {
                InfoPlasticsView()
            }

    }
    
    // MARK: - Component Views
    
    private func optionCard(
        icon: String,
        title: String,
        description: String,
        buttonLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 16) {
            // Title with decorative element
            VStack {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color("ReefyBlue"))
            }
            .padding(.top, 8)
            
            // Icon with decorative background
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.blue.opacity(0.1), .cyan.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 130, height: 130)
                
                Circle()
                    .stroke(LinearGradient(
                        colors: [.blue.opacity(0.5), .cyan.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 2)
                    .frame(width: 130, height: 130)
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .foregroundStyle(Color("ReefyBlue"))
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
            .padding(.vertical)
            
            Spacer()
            
            // Description
            Text(description)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
            
            Spacer()
            
            // Button
            Button(action: action) {
                Text(buttonLabel)
            }
            .buttonStyle(FilledButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(UIColor.systemBackground).opacity(0.85))
                
                // Subtle pattern overlay
                VStack {
                    ForEach(0..<20) { i in
                        HStack {
                            ForEach(0..<20) { j in
                                Circle()
                                    .fill(Color.blue.opacity(0.03))
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                .mask(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                )
                
                // Top highlight
                RoundedRectangle(cornerRadius: 24)
                    .fill(LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    ))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.6),
                            Color("ReefyBlue").opacity(0.3),
                            .blue.opacity(0.2),
                            .cyan.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
        .shadow(color: Color("ReefyBlue").opacity(0.2), radius: 30, x: 0, y: 10)
        .scaleEffect(animateContent ? 1 : 0.8)
        .opacity(animateContent ? 1 : 0)
    }
    
    private func resultsView(image: UIImage) -> some View {
        HStack(spacing: 24) {
            // Image preview
            VStack(spacing: 12) {
                // Title with decorative element
                VStack(spacing: 8) {
                    Text("Imagen Capturada")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [.blue.opacity(0.7), .teal, .cyan.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: 60, height: 3)
                        .cornerRadius(1.5)
                }
                .padding(.top, 16)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .cyan.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .padding()
            }
            .frame(maxWidth: 600)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(UIColor.systemBackground).opacity(0.85))
                    
                    // Subtle pattern overlay
                    VStack {
                        ForEach(0..<20) { i in
                            HStack {
                                ForEach(0..<20) { j in
                                    Circle()
                                        .fill(Color.blue.opacity(0.03))
                                        .frame(width: 4, height: 4)
                                }
                            }
                        }
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                    )
                    
                    // Top highlight
                    RoundedRectangle(cornerRadius: 24)
                        .fill(LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .center
                        ))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.6),
                                Color("ReefyBlue").opacity(0.3),
                                .blue.opacity(0.2),
                                .cyan.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
            .shadow(color: Color("ReefyBlue").opacity(0.2), radius: 30, x: 0, y: 10)
            
            // Classification result
            VStack(spacing: 20) {
                Text("Resultado")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color("ReefyBlue"))
                    .padding(.top)
                
                if let result = classificationResult {
                    VStack(spacing: 12) {
                        Text("Clasificación")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 24))
                            
                            VStack{
                                Text(result)
                                    .font(.system(size: 24, weight: .bold))
                                if let confidence = classificationConfidence{
                                    Text("Confianza: \(confidence)%")
                                }
                            }
                            .foregroundColor(.green)
                            
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                        )
                    }
                    .padding()
                } else {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Analizando imagen...")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                }
                
                Spacer()
                
                VStack{
                    Button {
                        withAnimation(.spring()) {
                            resetAndLaunchCamera()
                        }
                    } label: {
                        Label("Clasificar Otro Objeto", systemImage: "arrow.triangle.2.circlepath")
                            .font(.headline)
                    }
                    .buttonStyle(FilledButtonStyle())
                    .padding(.horizontal)
                    
                    Button {
                        withAnimation(.spring()) {
                            selectedImage = nil
                            classificationResult = nil
                        }
                    } label: {
                        Label("Volver al Inicio", systemImage: "house")
                            .font(.headline)
                    }
                    .buttonStyle(OutlinedButtonStyle())
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground).opacity(0.9))
            )
            
        }
    }
    
    // MARK: - Helpers
    
    private func resetAndLaunchCamera() {
        selectedImage = nil
        classificationResult = nil
        isShowingCamera = true
    }
    
    private func classifyImage() {
        guard let image = selectedImage,
              let ciImage = CIImage(image: image) else {
            classificationResult = "Error: No se pudo preparar la imagen para clasificación"
            classificationConfidence = 0
            return
        }
        
        // Reset to show loading UI
        classificationResult = nil
        
    
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let model = try BottleAmountClassifier_1()
                let visionModel = try VNCoreMLModel(for: model.model)
                
                let request = VNCoreMLRequest(model: visionModel) { request, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            classificationResult = "Error de clasificación: \(error.localizedDescription)"
                            classificationConfidence = 0
                        }
                        return
                    }
                    
                    guard let results = request.results as? [VNClassificationObservation],
                          let topResult = results.first else {
                        DispatchQueue.main.async {
                            classificationResult = "No se encontraron resultados"
                            classificationConfidence = 0
                        }
                        return
                    }
                    
                    let identifier = topResult.identifier
                    let confidence = Int(topResult.confidence * 100)
                    let readableDescription = labelDescriptions[identifier] ?? "Tipo de plástico desconocido"
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            classificationResult = readableDescription
                            classificationConfidence = confidence
                        }
                    }
                }
                
                let handler = VNImageRequestHandler(ciImage: ciImage)
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    classificationResult = "Error al cargar el modelo: \(error.localizedDescription)"
                    classificationConfidence = 0
                }
            }
        }
    }
}


// MARK: - Custom Button Styles

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .shadow(color: .accentColor.opacity(0.4), radius: 4, x: 0, y: 2)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .foregroundColor(.accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentColor, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
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
