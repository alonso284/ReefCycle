import SwiftUI
import MapKit
import CloudKit

struct InstitutionCardView: View {
    let institution: Institution
    @State private var region: MKCoordinateRegion
    
    init(institution: Institution) {
        self.institution = institution
        
        // Initialize map region centered on the institution's location
        let coordinate = institution.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Map on the left
            Map(coordinateRegion: $region, annotationItems: [institution]) { inst in
                MapAnnotation(coordinate: inst.location?.coordinate ?? CLLocationCoordinate2D()) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white))
                }
            }
            .frame(maxHeight: .infinity)
            .cornerRadius(12, corners: [.topLeft, .bottomLeft])
            
            // Institution info on the right
            VStack(alignment: .leading, spacing: 12) {
                if let uiImage = loadImageFromAsset(institution.logo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                }
                
                Text(institution.name)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                Text("Code: \(institution.code)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12, corners: [.topRight, .bottomRight])
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(.all)
        
    }
    
    private func loadImageFromAsset(_ asset: CKAsset) -> UIImage? {
        guard let fileURL = asset.fileURL else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image from asset: \(error)")
            return nil
        }
    }
}

// Extension for rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

struct InstitutionCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock CKRecord
        let record = CKRecord(recordType: Institution.recordType)
        record[.institution_code] = "ITESM"
        record[.institution_name] = "Instituto Tecnológico de Monterrey"
        
        // For logo, we'll use a placeholder in preview
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("logo.png")
        if let mockImage = UIImage(systemName: "building.columns.fill"),
           let imageData = mockImage.pngData() {
            try? imageData.write(to: tempURL)
        }
        record[.institution_logo] = CKAsset(fileURL: tempURL)
        
        // Mock location for Monterrey, Mexico
        record[.institution_location] = CLLocation(latitude: 25.6714, longitude: -100.309)
        
        // Create a mock Institution using the proper initializer
        guard let mockInstitution = Institution(record: record) else {
            return Text("Failed to create mock institution")
                .previewLayout(.sizeThatFits)
        }
        
        return InstitutionCardView(institution: mockInstitution)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
