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

struct InfoPlasticsView: View {
    @State private var searchText = ""
    @State private var selectedPlastic: PlasticType? = nil
    @State private var showingDetail = false
    @State private var showInfoAlert = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Plastics data remains the same
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
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        
    ]

    
    var body: some View {
        VStack(spacing: 0) {
           
            // Main content
            ScrollView {
                if filteredPlastics.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No se encontraron resultados para \"\(searchText)\"")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            searchText = ""
                        }) {
                            Text("Borrar búsqueda")
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue)
                                )
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredPlastics) { plastic in
                            PlasticCard(plastic: plastic)
                                .onTapGesture {
                                    selectedPlastic = plastic
                                    showingDetail = true
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Plástico tipo \(plastic.code), \(plastic.name). Reciclabilidad: \(plastic.recyclabilityLevel.rawValue)")
                                .accessibilityHint("Toca para ver detalles")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)

                }
            }
            .background(Color(.systemGroupedBackground))
            
        }
        .sheet(isPresented: $showingDetail) {
            if let selectedPlastic = selectedPlastic {
                PlasticDetailSheet(plastic: selectedPlastic, isPresented: $showingDetail)
            }
        }
        .alert(isPresented: $showInfoAlert) {
            Alert(
                title: Text("Códigos de Reciclaje"),
                message: Text("Los números dentro de los símbolos de reciclaje indican el tipo de plástico. Esta guía te ayuda a identificar los diferentes tipos y cómo reciclarlos correctamente."),
                dismissButton: .default(Text("Entendido"))
            )
        }
        .navigationBarTitle("Guia de Reciclaje", displayMode: .large)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    showInfoAlert = true
                }) {
                    Image(systemName: "info.circle")
                }
                .accessibilityLabel("Información sobre los códigos de reciclaje")
            }
        }
    }
}

struct PlasticCard: View {
    let plastic: PlasticType
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color.white)
                .overlay(
                    VStack(spacing: 8) {
                        // Code Circle
                        ZStack {
                            Circle()
                                .fill(plastic.recyclabilityLevel.color)
                                .frame(width: 60, height: 60)
                                .shadow(color: plastic.recyclabilityLevel.color.opacity(0.4), radius: 4, x: 0, y: 2)

                            Text(plastic.code)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 12)

                        // Name and recyclability
                        Text(plastic.name.split(separator: " ").first ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(1)

                        Text(plastic.recyclabilityLevel.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(plastic.recyclabilityLevel.color.opacity(0.2))
                            )
                            .foregroundColor(plastic.recyclabilityLevel.color)

                        // Examples
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ejemplos:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(plastic.examples.prefix(2).joined(separator: ", "))
                                .font(.caption2)
                                .foregroundColor(.primary.opacity(0.8))
                                .lineLimit(2)
                                .frame(height: 32, alignment: .topLeading)
                        }
                        .padding(.horizontal, 12)

                        Spacer()

                        Divider()
                            .padding(.horizontal, 12)

                        // View details button
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.caption)

                            Text("Detalles")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(plastic.recyclabilityLevel.color.opacity(0.1))
                        .foregroundColor(plastic.recyclabilityLevel.color)
                        .cornerRadius(8)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
        }
        .frame(height: 260) // fixed consistent height
    }
}


struct PlasticDetailSheet: View {
    let plastic: PlasticType
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with plastic code and badge
                    HStack(alignment: .top) {
                        ZStack {
                            Circle()
                                .fill(plastic.recyclabilityLevel.color)
                                .frame(width: 80, height: 80)
                                .shadow(color: plastic.recyclabilityLevel.color.opacity(0.4), radius: 6, x: 0, y: 3)
                            
                            VStack(spacing: 0) {
                                Text(plastic.code)
                                    .font(.system(size: 36))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(plastic.recyclabilityLevel.rawValue)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(plastic.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Label {
                                    Text("Reciclabilidad: ")
                                        .foregroundColor(.secondary)
                                        .fontWeight(.medium) +
                                    Text(plastic.recyclability)
                                        .foregroundColor(plastic.recyclabilityLevel.color)
                                        .fontWeight(.semibold)
                                } icon: {
                                    Image(systemName: "arrow.3.trianglepath")
                                        .foregroundColor(plastic.recyclabilityLevel.color)
                                }
                                .font(.callout)
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Characteristics
                    DetailSectionView(
                        title: "Características Físicas",
                        systemImage: "list.bullet",
                        color: plastic.recyclabilityLevel.color
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(plastic.characteristics, id: \.self) { characteristic in
                                Label(characteristic, systemImage: "checkmark.circle.fill")
                                    .foregroundColor(.primary)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                    
                    // Examples
                    DetailSectionView(
                        title: "Ejemplos Comunes",
                        systemImage: "shippingbox",
                        color: plastic.recyclabilityLevel.color
                    ) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 130, maximum: .infinity))], spacing: 8) {
                            ForEach(plastic.examples, id: \.self) { example in
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(plastic.recyclabilityLevel.color.opacity(0.3))
                                        .frame(width: 6, height: 6)
                                    
                                    Text(example)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    // Recycling process
                    DetailSectionView(
                        title: "Proceso de Reciclaje",
                        systemImage: "arrow.triangle.2.circlepath",
                        color: plastic.recyclabilityLevel.color
                    ) {
                        Text(plastic.process)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .padding(.vertical, 4)
                    }
                    
                    // Disposal
                    DetailSectionView(
                        title: "Cómo Desechar Correctamente",
                        systemImage: "trash",
                        color: plastic.recyclabilityLevel.color,
                        isHighlighted: true
                    ) {
                        HStack(spacing: 16) {
                            Image(systemName: getDisposalIcon(for: plastic))
                                .font(.title)
                                .foregroundColor(plastic.recyclabilityLevel.color)
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(plastic.recyclabilityLevel.color.opacity(0.2))
                                )
                            
                            Text(plastic.disposal)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Plástico Tipo \(plastic.code)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            })
        }
    }
    
    private func getDisposalIcon(for plastic: PlasticType) -> String {
        if plastic.code == "1" || plastic.code == "2" || plastic.code == "4" || plastic.code == "5" {
            return "arrow.down.doc.fill" // Contenedor amarillo
        } else {
            return "building.2.fill" // Punto limpio
        }
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    let systemImage: String
    let color: Color
    let content: Content
    let isHighlighted: Bool
    
    init(
        title: String,
        systemImage: String,
        color: Color,
        isHighlighted: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.isHighlighted = isHighlighted
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                    .foregroundColor(isHighlighted ? color : .primary)
            }
            
            content
                .padding(.leading, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isHighlighted ? color.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        )
    }
}
