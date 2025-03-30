import SwiftUI
import Charts

public struct PieChartView: View {
    public var data: [UniversityStat]
    @State private var selectedStat: UniversityStat?
    @State private var animateChart = false
    @State private var highlightedSector: UUID?
    
    public init(data: [UniversityStat]) {
        self.data = data
    }
    
    // Total sum
    var total: Int {
        data.map { $0.value }.reduce(0, +)
    }
    
    // University with the highest value
    var topUniversity: UniversityStat? {
        data.max(by: { $0.value < $1.value })
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Top 5 Instituciones Comunidad")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(total) puntos globales")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            // Main content
            GeometryReader { geometry in
                if geometry.size.width > 600 {
                    HStack(alignment: .top, spacing: 20) {
                        chartContainer
                            .frame(width: geometry.size.width * 0.6)
                        
                        statsCardsContainer
                            .frame(width: geometry.size.width * 0.4)
                    }
                } else {
                    VStack(spacing: 24) {
                        chartContainer
                            .frame(height: 300)
                        
                        statsCardsContainer
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGroupedBackground))
        )
    }
    
    // Chart container
    private var chartContainer: some View {
        VStack {
            pieChart
                .frame(height: 300)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        animateChart = true
                    }
                }
        }
    }
    
    // Simplified pie chart view
    private var pieChart: some View {
        ZStack {
            // The actual chart
            Chart {
                ForEach(data) { item in
                    SectorMark(
                        angle: .value("Value", animateChart ? item.value : 0),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
                    )
                    .foregroundStyle(getColorForInstitution(name: item.name))
                    .opacity(highlightedSector == nil || highlightedSector == item.id ? 1.0 : 0.3)
                    .cornerRadius(4)
                }
            }
            
            // Interactive overlay
            GeometryReader { geometry in
                ForEach(data) { item in
                    // Calculate sector position (simplified approximation)
                    let angle = 2 * Double.pi * Double(calculateStartAngle(for: item))
                    let radius = min(geometry.size.width, geometry.size.height) / 2.5
                    let x = geometry.size.width / 2 + radius * cos(angle)
                    let y = geometry.size.height / 2 + radius * sin(angle)
                    
                    Circle()
                        .frame(width: 40, height: 40)
                        .opacity(0.001) // Almost invisible
                        .position(x: x, y: y)
                        .onTapGesture {
                            toggleSelection(for: item)
                        }
                }
                
                // Center overlay
                VStack(spacing: 4) {
                    if let selected = selectedStat {
                        // Show selected institution
                        Text(selected.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text("\(selected.value) points")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        if let percentage = calculatePercentage(for: selected) {
                            Text("(\(percentage)%)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        // Show top institution
                        Text("Institución Top")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        if let top = topUniversity {
                            Text(top.name)
                                .font(.headline.bold())
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("\(top.value) puntos")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onTapGesture {
                    // Clear selection when tapping center
                    selectedStat = nil
                    highlightedSector = nil
                }
            }
        }
    }
    
    // Calculate approximate starting angle for a sector
    private func calculateStartAngle(for item: UniversityStat) -> Double {
        let totalValue = Double(total)
        var runningTotal: Double = 0
        
        // Find all items before this one
        for stat in data {
            if stat.id == item.id {
                // Add half of the current item to get to the middle of the sector
                return (runningTotal + (Double(stat.value) / 2)) / totalValue
            }
            runningTotal += Double(stat.value)
        }
        
        return 0
    }
    
    // Toggle selection state
    private func toggleSelection(for stat: UniversityStat) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedStat?.id == stat.id {
                selectedStat = nil
                highlightedSector = nil
            } else {
                selectedStat = stat
                highlightedSector = stat.id
            }
        }
    }
    
    // Stats cards container
    private var statsCardsContainer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Desglose")
                .font(.headline)
                .padding(.bottom, 4)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(data.sorted(by: { $0.value > $1.value })) { stat in
                        statCard(for: stat)
                            .onTapGesture {
                                toggleSelection(for: stat)
                            }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // Stat card with progress bar
    private func statCard(for stat: UniversityStat) -> some View {
        let percentage = calculatePercentage(for: stat) ?? 0
        let isSelected = selectedStat?.id == stat.id
        
        return VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text(stat.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(stat.value) puntos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    // Progress
                    Rectangle()
                        .fill(getColorForInstitution(name: stat.name))
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100)
                        .cornerRadius(4)
                    
                    // Percentage text
                    Text("\(percentage)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
            .frame(height: 20)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ?
                     Color(UIColor.secondarySystemGroupedBackground).opacity(0.8) :
                     Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: isSelected ? .gray.opacity(0.2) : .clear, radius: 3, x: 0, y: 1)
        )
        .animation(.easeInOut, value: isSelected)
    }
    
    // Calculate percentage for a stat
    private func calculatePercentage(for stat: UniversityStat) -> Int? {
        guard total > 0 else { return nil }
        return Int((Double(stat.value) / Double(total)) * 100)
    }
    
    // Get a consistent color for each institution
    private func getColorForInstitution(name: String) -> Color {
        let colors: [Color] = [
            .green, .blue, .purple, .orange, .red,
            .teal, .indigo, .pink, .cyan, .yellow
        ]
        
        // Use the institution name to get a consistent index
        if let index = data.firstIndex(where: { $0.name == name }) {
            return colors[index % colors.count]
        }
        
        // Fallback
        return .blue
    }
}
