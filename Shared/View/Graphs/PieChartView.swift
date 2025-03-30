import SwiftUI
import Charts

public struct PieChartView: View {
    public var data: [UniversityStat]
    @State private var selectedStat: UniversityStat?
    @State private var animateChart = false
    
    public init(data: [UniversityStat]) {
        self.data = data
    }
    
    // Total sum - preserved from original
    var total: Int {
        data.map { $0.value }.reduce(0, +)
    }
    
    // University with the highest value - preserved from original
    var topUniversity: UniversityStat? {
        data.max(by: { $0.value < $1.value })
    }
    
    public var body: some View {
        // Preserved overall structure from original
        VStack(alignment: .leading, spacing: 12) {
            // Header with total recycled - preserved from original
            Text("Total Reciclado").fontWeight(.semibold).font(.title)
            Text("\(total) kg")
                .font(.title)
                .foregroundColor(.gray)
            
            // Chart section split into a separate view to reduce complexity
            chartView
            
            // Stats cards
            statsCards
        }
        .frame(maxWidth: 700, maxHeight: 700)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGroupedBackground))
        )
    }
    
    // Chart view extracted as separate component
    private var chartView: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Value", animateChart ? item.value : 0),
                innerRadius: .ratio(0.6),
                angularInset: 30
            )
            .cornerRadius(60)
            .foregroundStyle(by: .value("University", item.name))
        }
        // Color scheme from original
        .chartForegroundStyleScale(range: [
            Color.green.gradient,
            Color.blue.gradient,
            Color.purple.gradient,
            Color.orange.gradient,
            Color.red.gradient,
            Color.teal.gradient,
            Color.indigo.gradient,
            Color.pink.gradient,
            Color.cyan.gradient,
            Color.yellow.gradient
        ])
        // Chart background with central text
        .overlay(chartCenterOverlay)
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 300)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animateChart = true
            }
        }
    }
    
    // Center overlay extracted to reduce complexity
    private var chartCenterOverlay: some View {
        GeometryReader { geometry in
            VStack {
                Text("Institución con \nmás reciclaje")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                if let top = topUniversity {
                    Text(top.name)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    // Stats cards for each university
    private var statsCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(data) { stat in
                    createStatCard(for: stat)
                }
            }
        }
    }
    
    // Helper function to create a stat card
    private func createStatCard(for stat: UniversityStat) -> some View {
        VStack(alignment: .leading) {
            Text(stat.name)
                .font(.headline)
            
            HStack {
                Text("\(stat.value) kg")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if let percentage = calculatePercentage(for: stat) {
                    Text("(\(percentage)%)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
    }
    
    // Calculate percentage for a stat
    private func calculatePercentage(for stat: UniversityStat) -> Int? {
        guard total > 0 else { return nil }
        return Int((Double(stat.value) / Double(total)) * 100)
    }
}

// Preview with sample data
#Preview {
    PieChartView(data: [
        UniversityStat(name: "TEC", value: 20),
        UniversityStat(name: "UNAM", value: 30),
        UniversityStat(name: "UVM", value: 40),
        UniversityStat(name: "ITAM", value: 25),
        UniversityStat(name: "IBERO", value: 15)
    ])
    .padding()
}
