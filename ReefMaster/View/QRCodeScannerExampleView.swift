import SwiftUI
import CodeScanner

struct QRCodeScannerExampleView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var message: String = ""
    
    @State var viewModel: ReefMasterViewModel

    var body: some View {
        VStack(spacing: 10) {
            if let code = scannedCode {
                Text("Scanned ID: \(code)")
            }

            Button("Scan QR Code") {
                isPresentingScanner = true
            }

            Text(message)
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.code39, .code39Mod43, .code128, .codabar, .qr]) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    isPresentingScanner = false
                    
                    Task {
                        await handleScannedCode()
                    }
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

            try await viewModel.registerPoints(reefKeeper: reefKeeper, points: 10) // add 10 points or whatever value you want
            message = "✅ Points added to \(reefKeeper.user)"
        } catch {
            message = "❌ Error: \(error.localizedDescription)"
        }
    }
}

