
import SwiftUI
import Charts


public struct PieChartView: View {
    public var data: [UniversityStat]
    
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


    @State private var animateChart = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Total Reciclado").fontWeight(.semibold).font(.title)
            Text("\(total) kg")
                .font(.title)
                .foregroundColor(.gray)
            
            Chart(data) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0.6),
                    angularInset: 3
                )
                .cornerRadius(6)
                .foregroundStyle(by: .value("University", item.name))
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    
                    VStack {
                        Text("Institución con más reciclaje")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        if let top = topUniversity {
                            Text(top.name)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            .padding()
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0)) {
                    animateChart = true
                }
            }
        }
        .frame(maxWidth: 700, maxHeight: 700)
    }
}


#Preview {
    PieChartView(data: [
        UniversityStat(name: "TEC", value: 20),
        UniversityStat(name: "UNAM", value: 30),
        UniversityStat(name: "UVM", value: 40)
    ])
}
