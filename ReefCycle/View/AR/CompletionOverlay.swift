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
    let onContinue: () -> Void
    
    private var isPerfectScore: Bool {
        return correctAnswers == totalQuestions
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Score text
            Text("\(correctAnswers)/\(totalQuestions)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
            
            // Motivational message
            Text(isPerfectScore
                ? "¡Increíble! Ya estás listo para apoyar a tu planeta."
                : "¡No te preocupes! En Reefcycle aprenderás a reciclar y ganarás puntos.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Continue button
            Button(action: onContinue) {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 32)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .padding(.top, 12)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
        )
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.gray.edgesIgnoringSafeArea(.all)
        CompletionOverlay(correctAnswers: 3, totalQuestions: 3) {
            print("Continue pressed")
        }
    }
}
