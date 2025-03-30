//
//  CompletionOverlay.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import SwiftUI

struct CompletionOverlay: View {
    let correctAnswers: Int
    let totalQuestions: Int
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("¡Completado!")
                .font(.largeTitle)
                .bold()

            Text("Respondiste correctamente \(correctAnswers) de \(totalQuestions) preguntas.")
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .padding()
    }
}
