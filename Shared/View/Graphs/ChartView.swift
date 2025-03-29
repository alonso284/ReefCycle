
import SwiftUI
import Charts

public struct UniversityStat: Identifiable {
    public var id = UUID()
    public var name: String
    public var value: Int
}

public struct ChartView: View {
    public var data: [UniversityStat]
    
    public init(data: [UniversityStat]) {
        self.data = data
    }
    var total: Int {
        data.map { $0.value }.reduce(0, +)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Total Reciclado").fontWeight(.semibold).font(.title)
            Text("\(total) kg")
                .font(.title)
                .foregroundColor(.gray)
            
            Chart(data) { item in
                BarMark(
                    x: .value("name", item.name),
                    y: .value("Value", item.value)
                )
                .cornerRadius(30)
                .foregroundStyle(.indigo.gradient)
            }
            
            .padding()
            
        }
        .frame(maxWidth: 700, maxHeight: 700)
    }
}

#Preview {
    ChartView(data: [
        UniversityStat(name: "TEC", value: 20),
        UniversityStat(name: "UNAM", value: 30),
        UniversityStat(name: "UVM", value: 40)
    ])
}
