import SwiftUI
import MapKit
import CloudKit

struct InstitutionView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    let institution: Institution
    @State private var region: MKCoordinateRegion
    var sum_points : Int? {
        reefVM.reefKeepers?.reduce(0, {
            result, reefKeeper in
            if reefKeeper.institution.recordID == institution.id {
                return result + reefKeeper.points
            }
            return result
        })
    }
    var reefKeepers : [ReefKeeper]? {
        reefVM.reefKeepers?.filter { $0.institution.recordID == institution.id }.sorted(by: { $0.points > $1.points })
    }
    
    
    init(institution: Institution) {
        self.institution = institution
        
        // Initialize map region centered on the institution's location
        let coordinate = institution.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    struct Event: Identifiable {
        let name: String
        let date: Date
        var id: Date { date }
    }
    
    let events: [Event] = [
        Event(name: "Earth Day Cleanup", date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 22))!),
        Event(name: "Campus Recycling Drive", date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 12))!),
        Event(name: "Beach Restoration Day", date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 8))!),
        Event(name: "Neighborhood Swap Meet", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 30))!),
        Event(name: "Plastic-Free Challenge Week", date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 15))!),
        Event(name: "Recycle-A-Thon", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 5))!),
        Event(name: "World Environment Day Collection", date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5))!),
        Event(name: "Recyclers Appreciation Day", date: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 18))!),
        Event(name: "Zero Waste Challenge", date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 3))!),
        Event(name: "Winter Cleanup Kickoff", date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 1))!)
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Map on the left
         
            List {
                
                Section("Location"){
                    Map(coordinateRegion: $region, interactionModes: [], annotationItems: [institution] ) { inst in
                        MapAnnotation(coordinate: inst.location?.coordinate ?? CLLocationCoordinate2D()) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .background(Circle().fill(Color.white))
                        }
                    }
                    .frame(height: 400)
                    .ignoresSafeArea()
                    //                .frame(maxWidth: UIScreen.main.bounds.width * 0.6,maxHeight: .infinity)
                    .cornerRadius(15)
                }
                
                Section("Recolation Events") {
                    ForEach(events) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text(event.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                // Mock action for adding to calendar
                                print("Adding \(event.name) to calendar...")
                            }) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.title2)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 4)
                    }
                }
                


            }
            
            // Institution info on the right
            List {
                Section("Institution") {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 12) {
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
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            
                            if let sum_points {
                                Text("Total points: \(sum_points)")
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                            }
                        }
                        Spacer()
                    }
                }
                    
//                    Spacer()
                    
                    if let reefKeepers {
                        Section("Reef Keepers"){
                            ForEach(Array(reefKeepers.enumerated()), id: \.element.id) { index, reefKeeper in
                                HStack {
                                    Text("#\(index+1)")
                                        .font(.largeTitle)
                                    ReefKeeperPreview(
                                        reefKeeper: reefKeeper,
                                        user: nil,
                                        showReefy: true
                                    )
                                }
                            }
                        }
                    } else {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await loadReefKeepers()
                                }
                            }
                    }
                }
//                .padding()
//                .frame(width: UIScreen.main.bounds.width * 0.4)
//                .background(Color(UIColor.systemBackground))
//                .cornerRadius(12, corners: [.topRight, .bottomRight])
            }
//        }
//        .frame(maxHeight: .infinity)
//        .ignoresSafeArea(.all)
        
    }
    
    func loadReefKeepers() async {
        do {
            try await reefVM.fetchReefKeepers()
        } catch {
            print(error)
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
        record[.institution_location] = CLLocation(latitude: 25.650888, longitude: -100.2900)
        
        // Create a mock Institution using the proper initializer
        if let mockInstitution = Institution(record: record) {
                    return AnyView(
                        InstitutionView(institution: mockInstitution)
                            .previewLayout(.sizeThatFits)
                            .padding()
                    )
                } else {
                    return AnyView(
                        Text("Failed to create mock institution")
                            .previewLayout(.sizeThatFits)
                    )
                }
    }
}
