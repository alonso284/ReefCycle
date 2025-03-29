//
//  ARContentView.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import SwiftUI

struct ARContentView: View {
    @StateObject private var viewModel = TrashcanPlacementViewModel()
    @State private var showHelp = false
    @State private var navigateToSample = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ARViewContainer(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        TopBarView(showHelp: $showHelp)
                    )
                
                // Scanning overlay during detection phase
                if viewModel.showScanningOverlay && !viewModel.hasTappedToPlace {
                    ScanningOverlay(viewModel: viewModel)
                        .transition(.opacity)
                }
                
                // Classification feedback
                if viewModel.showValidationSymbol {
                    ValidationFeedbackView(isCorrect: viewModel.isClassificationCorrect)
                }

                // Onboarding messages and controls
                BottomControlsView(viewModel: viewModel)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                    
                // Material classification overlay
                if viewModel.isShowingClassificationForm && !viewModel.currentRecyclableItem.isEmpty && viewModel.isConfirmedPlacement {
                    MaterialClassificationView(viewModel: viewModel)
                }
                
                // Completion overlay when Monito is dancing
                if viewModel.showCompletionOverlay && viewModel.didFinishMiniQuiz {
                    VStack {
                        Spacer()
                        CompletionOverlay(
                            correctAnswers: viewModel.correctAnswers,
                            totalQuestions: 3
                        ) {
                            // Navigate to SampleView
                            navigateToSample = true
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut, value: viewModel.showCompletionOverlay)
                    .zIndex(10)
                }
                
                // Add NavigationLink for programmatic navigation
                NavigationLink(
                    destination: SampleView(),
                    isActive: $navigateToSample,
                    label: { EmptyView() }
                )
            }
            .sheet(isPresented: $showHelp) {
                HelpView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Top Bar View
struct TopBarView: View {
    @Binding var showHelp: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showHelp = true
                }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
}

// MARK: - Bottom Controls View
struct BottomControlsView: View {
    @ObservedObject var viewModel: TrashcanPlacementViewModel
    
    var body: some View {
        VStack {
            if !viewModel.hasTappedToPlace && !viewModel.showScanningOverlay {
                OnboardingMessageView(
                    systemIcon: "hand.tap.fill",
                    text: "Haz click para colocar contenedores de reciclaje",
                    description: "Selecciona una superficie plana"
                )
                .transition(.move(edge: .bottom))
            } else if viewModel.isEditing {
                
                VStack(spacing: 20) {
                    Text("Confirma la ubicación, posicion y escala de los contenedores")
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
                
                VStack{
                    Button(action: {
                        withAnimation {
                            viewModel.confirmPlacement()
                        }
                    }) {
                        Text("Colocar")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.bottom, 40)
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Onboarding Message View
struct OnboardingMessageView: View {
    let systemIcon: String
    let text: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemIcon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Text(text)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 8)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

// MARK: - Validation Feedback View
struct ValidationFeedbackView: View {
    let isCorrect: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(isCorrect ? .green : .red)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut, value: isCorrect)
            }
            .background(Color.white)
            .clipShape(Circle())
            .frame(width: 80, height: 80)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Material Classification View
struct MaterialClassificationView: View {
    @ObservedObject var viewModel: TrashcanPlacementViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Rota el recipiente, haz zoom y busca el símbolo de reciclaje")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("¿Qué tipo de plástico es?")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 10) {
                    ForEach(["PET 1", "HDPE 2", "PP 5"], id: \.self) { type in
                        Button(action: {
                            viewModel.selectedMaterialGuess = type
                            viewModel.hasClassifiedItem = true
                        }) {
                            Text(type)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}


