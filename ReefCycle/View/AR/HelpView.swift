//
//  HelpView.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    helpSection(
                        title: "Buscando superficies",
                        icon: "arkit",
                        description: "Mueve el dispositivo lentamente para detectar superficies planas donde colocar los contenedores."
                    )
                    
                    helpSection(
                        title: "Colocación de contenedores",
                        icon: "hand.tap.fill",
                        description: "Toca en una superficie plana detectada para colocar los contenedores de reciclaje."
                    )
                    
                    helpSection(
                        title: "Ajuste de posición",
                        icon: "arrow.up.and.down.and.arrow.left.and.right",
                        description: "Arrastra con un dedo para mover los contenedores a la posición deseada."
                    )
                    
                    helpSection(
                        title: "Rotación",
                        icon: "arrow.clockwise",
                        description: "Gira con dos dedos para rotar los contenedores."
                    )
                    
                    helpSection(
                        title: "Escala",
                        icon: "arrow.up.left.and.arrow.down.right",
                        description: "Pellizca con dos dedos para ajustar el tamaño de los contenedores."
                    )
                    
                    helpSection(
                        title: "Confirmación",
                        icon: "checkmark.circle.fill",
                        description: "Presiona el botón 'Colocar' para confirmar la posición final de los contenedores."
                    )
                }
                .padding()
            }
            .navigationTitle("Ayuda")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
        
    private func helpSection(title: String, icon: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HelpView()
}
