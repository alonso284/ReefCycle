import SwiftUI

struct PlasticType: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let characteristics: [String]
    let examples: [String]
    let recyclability: String
    let recyclabilityLevel: RecyclabilityLevel
    let process: String
    let disposal: String
    
    enum RecyclabilityLevel: String, Hashable {
        case high = "Alta"
        case mediumHigh = "Media-Alta"
        case medium = "Media"
        case low = "Baja"
        case veryLow = "Muy baja"
        
        var color: Color {
            switch self {
            case .high: return .green
            case .mediumHigh: return .mint
            case .medium: return .yellow
            case .low: return .orange
            case .veryLow: return .red
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PlasticType, rhs: PlasticType) -> Bool {
        lhs.id == rhs.id
    }
}

struct PlasticRecyclingBentoView: View {
    @State private var searchText = ""
    @State private var selectedPlastic: PlasticType? = nil
    @State private var showingDetail = false
    
    let plasticTypes: [PlasticType] = [
        PlasticType(
            code: "1",
            name: "PET (Tereftalato de Polietileno)",
            characteristics: [
                "Transparente, brillante y fino",
                "Ligero y flexible pero firme",
                "Se arruga cuando se comprime y recupera su forma",
                "Se puede rayar con la uña con cierta facilidad"
            ],
            examples: [
                "Botellas de agua y refrescos",
                "Envases de aceite comestible",
                "Frascos de mantequilla de maní",
                "Películas para hornos microondas",
                "Bandejas de comida preparada"
            ],
            recyclability: "Alta - Es uno de los plásticos más reciclados globalmente",
            recyclabilityLevel: .high,
            process: "Se lava, tritura, y derrite para crear hojuelas o pellets que se usan para fabricar nuevos productos como fibras textiles, alfombras, rellenos para bolsas de dormir y abrigos.",
            disposal: "Contenedor amarillo. Debe estar limpio, seco y preferiblemente compactado para ocupar menos espacio."
        ),
        PlasticType(
            code: "2",
            name: "HDPE (Polietileno de Alta Densidad)",
            characteristics: [
                "Opaco y rígido",
                "Superficie cerosa al tacto",
                "Resistente y no se deforma fácilmente",
                "No se rompe al doblarlo, sino que se dobla"
            ],
            examples: [
                "Envases de detergente y champú",
                "Botellas de leche",
                "Bolsas de supermercado",
                "Juguetes para niños",
                "Tubos y mangueras"
            ],
            recyclability: "Alta - Muy demandado por la industria del reciclaje",
            recyclabilityLevel: .high,
            process: "Se tritura, lava, funde y granula para crear \"madera plástica\", muebles de jardín, contenedores, tubos, y nuevas botellas no alimentarias.",
            disposal: "Contenedor amarillo. Asegurarse de que esté vacío y enjuagado."
        ),
        PlasticType(
            code: "3",
            name: "PVC (Policloruro de Vinilo)",
            characteristics: [
                "Rígido o flexible (dependiendo de los aditivos)",
                "A menudo brillante en su forma rígida",
                "Resistente a grasas y aceites",
                "Olor distintivo a \"plástico nuevo\" en algunos casos"
            ],
            examples: [
                "Tuberías y accesorios para fontanería",
                "Marcos de ventanas",
                "Cables eléctricos (recubrimiento)",
                "Películas para envasar alimentos",
                "Tarjetas de crédito"
            ],
            recyclability: "Baja - Contiene cloro que dificulta su reciclaje y puede generar toxinas",
            recyclabilityLevel: .low,
            process: "Separación especializada y procesamiento controlado. Se recicla principalmente para aplicaciones no alimentarias como tuberías, conductos y muebles.",
            disposal: "Punto limpio especializado. No se debe depositar en el contenedor amarillo convencional debido a sus aditivos tóxicos."
        ),
        PlasticType(
            code: "4",
            name: "LDPE (Polietileno de Baja Densidad)",
            characteristics: [
                "Flexible y suave",
                "Semitransparente o translúcido",
                "Ceroso al tacto",
                "Se estira antes de romperse"
            ],
            examples: [
                "Bolsas de plástico finas",
                "Envoltorios de plástico",
                "Tapas flexibles",
                "Botellas exprimibles",
                "Revestimiento de cartones de leche"
            ],
            recyclability: "Media - Menos centros lo aceptan pero es reciclable",
            recyclabilityLevel: .medium,
            process: "Se tritura, lava y funde para convertirse en bolsas de basura, paneles, baldosas y muebles.",
            disposal: "Contenedor amarillo. Agrupar varias bolsas dentro de una para facilitar su procesamiento."
        ),
        PlasticType(
            code: "5",
            name: "PP (Polipropileno)",
            characteristics: [
                "Rígido pero flexible",
                "Resistente al calor",
                "Superficie brillante",
                "Liviano",
                "No se rompe fácilmente"
            ],
            examples: [
                "Recipientes para comida caliente",
                "Tapas de botellas",
                "Pajitas/popotes",
                "Recipientes de yogur",
                "Envases de medicamentos"
            ],
            recyclability: "Media-Alta - Cada vez más aceptado en programas de reciclaje",
            recyclabilityLevel: .mediumHigh,
            process: "Trituración, lavado y fundición para crear escobas, cepillos, rastrillos, bandejas de baterías y piezas automotrices.",
            disposal: "Contenedor amarillo. Asegurarse de separar las tapas de los envases si son de diferentes materiales."
        ),
        PlasticType(
            code: "6",
            name: "PS (Poliestireno)",
            characteristics: [
                "Rígido o en forma de espuma (expandido/Styrofoam)",
                "Quebradizo cuando es rígido",
                "Ligero y con aire cuando es expandido",
                "Hace un sonido característico al romperse"
            ],
            examples: [
                "Vasos desechables",
                "Bandejas de carne",
                "Cajas de CD",
                "Aislamiento de edificios",
                "Envases de huevos"
            ],
            recyclability: "Baja - Costoso de reciclar y ocupa mucho espacio",
            recyclabilityLevel: .low,
            process: "Compactación, fundición y extrusión para crear marcos de fotos, aislamiento, reglas y bandejas.",
            disposal: "Punto limpio especializado. Muchos programas municipales no lo aceptan en contenedores regulares."
        ),
        PlasticType(
            code: "7",
            name: "Otros (Policarbonato, Acrilonitrilo, etc.)",
            characteristics: [
                "Variadas dependiendo del tipo específico",
                "A menudo rígidos y duraderos",
                "Algunos son transparentes, otros opacos"
            ],
            examples: [
                "Botellas deportivas reutilizables",
                "Recipientes para microondas",
                "Gafas de sol",
                "Pantallas de dispositivos electrónicos",
                "Algunas botellas de agua grandes (20L)"
            ],
            recyclability: "Muy baja - Generalmente no se reciclan en programas convencionales",
            recyclabilityLevel: .veryLow,
            process: "Procesos especializados según el tipo específico. Algunos se convierten en muebles de exterior y materiales de construcción resistentes.",
            disposal: "Punto limpio especializado. Verificar con las autoridades locales sobre opciones específicas."
        )
    ]
    
    var filteredPlastics: [PlasticType] {
        if searchText.isEmpty {
            return plasticTypes
        } else {
            return plasticTypes.filter { plastic in
                plastic.name.lowercased().contains(searchText.lowercased()) ||
                plastic.code.contains(searchText) ||
                plastic.examples.joined().lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 320, maximum: 400), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Guía de Plásticos para Reciclaje")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredPlastics) { plastic in
                            PlasticCard(plastic: plastic)
                                .onTapGesture {
                                    selectedPlastic = plastic
                                    showingDetail = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showingDetail) {
                if let selectedPlastic = selectedPlastic {
                    PlasticDetailSheet(plastic: selectedPlastic, isPresented: $showingDetail)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PlasticCard: View {
    let plastic: PlasticType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(plastic.recyclabilityLevel.color)
                        .frame(width: 50, height: 50)
                    
                    Text(plastic.code)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text(plastic.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(plastic.recyclability)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            
            Divider()
            
            Text("Ejemplos: \(plastic.examples.prefix(2).joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Spacer()
            
            HStack {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(plastic.recyclabilityLevel.color)
                Text("Tocar para más información")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct PlasticDetailSheet: View {
    let plastic: PlasticType
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(plastic.recyclabilityLevel.color)
                                .frame(width: 80, height: 80)
                            
                            Text(plastic.code)
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(plastic.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Label("Reciclabilidad:", systemImage: "arrow.3.trianglepath")
                                    .fontWeight(.medium)
                                Text(plastic.recyclability)
                                    .foregroundColor(plastic.recyclabilityLevel.color)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        DetailSectionView(title: "Características Físicas", systemImage: "list.bullet") {
                            ForEach(plastic.characteristics, id: \.self) { characteristic in
                                Label(characteristic, systemImage: "circle.fill")
                                    .labelStyle(.titleAndIcon)
                                    .font(.body)
                            }
                        }
                        
                        DetailSectionView(title: "Ejemplos Comunes", systemImage: "shippingbox") {
                            ForEach(plastic.examples, id: \.self) { example in
                                Label(example, systemImage: "circle.fill")
                                    .labelStyle(.titleAndIcon)
                                    .font(.body)
                            }
                        }
                        
                        DetailSectionView(title: "Proceso de Reciclaje", systemImage: "arrow.triangle.2.circlepath") {
                            Text(plastic.process)
                                .font(.body)
                        }
                        
                        DetailSectionView(title: "Cómo Desechar", systemImage: "trash") {
                            Text(plastic.disposal)
                                .font(.body)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Plástico Tipo \(plastic.code)", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                isPresented = false
            })
        }
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    let systemImage: String
    let content: Content
    
    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.title3)
                .fontWeight(.bold)
            
            content
                .padding(.leading)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    PlasticRecyclingBentoView()
}
