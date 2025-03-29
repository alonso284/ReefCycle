import SwiftUI
import MapKit
import CloudKit

struct InstitutionMapView: View {
    @State private var institutions: [Institution] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.0, longitude: -100.0), // Default to Mexico
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @State private var selectedInstitution: Institution?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: institutions) { institution in
                MapAnnotation(coordinate: institution.location?.coordinate ?? CLLocationCoordinate2D()) {
                    InstitutionAnnotationView(institution: institution, isSelected: institution == selectedInstitution)
                        .onTapGesture {
                            selectedInstitution = institution
                        }
                }
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                
                if let institution = selectedInstitution {
                    InstitutionDetailCard(institution: institution)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .onAppear {
            fetchInstitutions()
        }
    }
    
    private func fetchInstitutions() {
        let query = CKQuery(recordType: Institution.recordType, predicate: NSPredicate(value: true))
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching institutions: \(error.localizedDescription)")
                    return
                }
                
                guard let records = records else { return }
                
                self.institutions = records.compactMap { Institution(record: $0) }
                
                // Adjust map region to show all institutions
                if let firstLocation = institutions.first?.location?.coordinate {
                    var minLat = firstLocation.latitude
                    var maxLat = firstLocation.latitude
                    var minLon = firstLocation.longitude
                    var maxLon = firstLocation.longitude
                    
                    for institution in institutions {
                        if let coordinate = institution.location?.coordinate {
                            minLat = min(minLat, coordinate.latitude)
                            maxLat = max(maxLat, coordinate.latitude)
                            minLon = min(minLon, coordinate.longitude)
                            maxLon = max(maxLon, coordinate.longitude)
                        }
                    }
                    
                    let center = CLLocationCoordinate2D(
                        latitude: (minLat + maxLat) / 2,
                        longitude: (minLon + maxLon) / 2
                    )
                    
                    let span = MKCoordinateSpan(
                        latitudeDelta: (maxLat - minLat) * 1.5,
                        longitudeDelta: (maxLon - minLon) * 1.5
                    )
                    
                    region = MKCoordinateRegion(center: center, span: span)
                }
            }
        }
    }
}

// Custom annotation view for institutions on the map
struct InstitutionAnnotationView: View {
    let institution: Institution
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = loadImageFromAsset(institution.logo) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.white, lineWidth: 2)
                    )
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(radius: 3)
                    )
            } else {
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(5)
                    .background(Circle().fill(Color.white))
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 3)
            }
            
            if isSelected {
                Text(institution.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .shadow(radius: 1)
                    )
                    .offset(y: 2)
            }
        }
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

// Detail card shown when an institution is selected
struct InstitutionDetailCard: View {
    let institution: Institution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let uiImage = loadImageFromAsset(institution.logo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(5)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading) {
                    Text(institution.name)
                        .font(.headline)
                    
                    Text("Code: \(institution.code)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // Open in maps app
                    if let coordinate = institution.location?.coordinate {
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                        mapItem.name = institution.name
                        mapItem.openInMaps(launchOptions: nil)
                    }
                }) {
                    Image(systemName: "map.fill")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            if let location = institution.location {
                Text("Location: \(formatCoordinate(location.coordinate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }
    
    private func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
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

// Preview for SwiftUI canvas
struct InstitutionMapView_Previews: PreviewProvider {
    static var previews: some View {
        InstitutionMapView()
    }
}

// Extension to Institution to work with SwiftUI's Map
extension Institution {
    var coordinate: CLLocationCoordinate2D {
        location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}