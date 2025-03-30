import SwiftUI
import CodeScanner


func imageForCantidad(_ cantidad: String) -> String {
    switch cantidad {
    case "pocas":
        return "PocasBotellas" // or your asset name
    case "normal":
        return "NormalBotellas"
    case "muchas":
        return "MuchasBotellas"
    default:
        return "questionmark"
    }
}


struct QRCodeScannerExampleView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var message: String = ""
    
    @State var viewModel: ReefMasterViewModel
    @State private var selectedCantidad = "normal" // default value
       
       let cantidades = ["pocas", "normal", "muchas"]
       
       // Optional: You can map points like this
       let puntosPorCantidad: [String: Int] = [
           "pocas": 300,
           "normal": 600,
           "muchas": 1000
       ]
    
    var body: some View {
            VStack(spacing: 30) {
                // Mascot or header
                Image("ReefCycleLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding(.top)

                // Scanned card
                if let code = scannedCode, !code.isEmpty {
                    VStack {
                        Text("🔍 Scanned ID:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(code)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.purple)
                            .padding(.top, 2)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .transition(.scale)
                    .animation(.spring(), value: scannedCode)
                }
                // Status message
                if !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(message.contains("✅") ? .green : .red)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }
                VStack(alignment: .leading) {
                                Text("🧺 Cantidad de Botellas")
                                    .font(.headline)
                    HStack {
                            ForEach(cantidades, id: \.self) { cantidad in
                                VStack(spacing: 4) {
                                    Image( imageForCantidad(cantidad))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding(8)
                                        .background(selectedCantidad == cantidad ? Color.blue.opacity(0.2) : Color.clear)
                                        .clipShape(Circle())

                                    Text(cantidad.capitalized)
                                        .font(.caption)
                                        .foregroundColor(selectedCantidad == cantidad ? .blue : .primary)
                                }
                                .onTapGesture {
                                    selectedCantidad = cantidad
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal) // Or .inline for sidebar-style

                            }
                            .padding(.horizontal)
                // Scan Button
                Spacer()
                Button(action: {
                    isPresentingScanner = true
                }) {
                    Text("📷 Escanear ID")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.darkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                

               
            }
            .padding()
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.code39, .code39Mod43, .code128, .codabar, .qr]) { response in
                    if case let .success(result) = response {
                        scannedCode = result.string
                        isPresentingScanner = false
                        
                        // You could call the async handler here
                         Task { await handleScannedCode() }
                    }
            }
        }
    }

    func handleScannedCode() async {
        guard let id = scannedCode else { return }

        do {
            guard let institution = try await viewModel.getInstitution() else {
                message = "Failed to fetch institution"
                return
            }

            guard let reefKeeper = try await viewModel.fetchReefKeeper(institution: institution, id: id) else {
                message = "No ReefKeeper found with that ID"
                return
            }

            try await viewModel.registerPoints(reefKeeper: reefKeeper,  points: puntosPorCantidad[selectedCantidad] ?? 0 ) // add 10 points or whatever value you want
            message = "✅ Puntos añadidos a: \(id)"
        } catch {
            message = "❌ Error: \(error.localizedDescription)"
        }
    }
}

/*
#Preview {
    QRCodeScannerExampleView()
}
*/
