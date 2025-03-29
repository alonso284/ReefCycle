//
//  TrashcanPlacementViewModel.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import Foundation
import SwiftUI
import SceneKit
import Combine

class TrashcanPlacementViewModel: ObservableObject {
    // AR Placement States
    @Published var hasTappedToPlace = false
    @Published var isConfirmedPlacement = false
    
    // Computed property (without @Published)
    var isEditing: Bool {
        hasTappedToPlace && !isConfirmedPlacement
    }
    
    // Scanning Animation States
    @Published var showScanningOverlay = true
    @Published var scanningProgress: CGFloat = 0.0
    private var scanningTimer: Timer?
    
    // Recyclable Item States
    @Published var shouldSpawnRecyclableItem = false
    @Published var currentRecyclableItem = ""
    @Published var shouldRemoveRecyclableItem = false
    @Published var isEditingRecyclable: Bool = false
    @Published var upcomingItems: [String] = []
    
    // Classification States
    @Published var hasClassifiedItem: Bool = false
    @Published var isClassificationCorrect: Bool = false
    @Published var isShowingClassificationForm: Bool = false
    @Published var selectedMaterialGuess: String? = nil
    @Published var showValidationSymbol: Bool = false
    
    // Game Flow
    @Published var didFinishMiniQuiz = false
    
    // Score Tracking
    @Published var correctAnswers: Int = 0
    @Published var totalAnswers: Int = 0
    @Published var showCompletionOverlay: Bool = false
    
    // Computed property for UI state
    var currentStep: Int {
        if !hasTappedToPlace { return 0 }
        if !isConfirmedPlacement { return 1 }
        return 2
    }
    
    init() {
        // Initialize with a shuffled list of recyclable items
        upcomingItems = ["waterBottle", "detergent", "waterCaps"].shuffled()
        startScanningAnimation()
    }
    
    // MARK: - Material Classification
    
    // Maps a model name to the correct bin index
    func correctBinIndex(for modelName: String) -> Int? {
        switch modelName {
        case "waterBottle":
            return 0  // PET 1
        case "detergent":
            return 1  // HDPE 2
        case "waterCaps":
            return 2  // PP 5
        default:
            return nil
        }
    }
    
    // MARK: - Scanning Animation
    
    func startScanningAnimation() {
        scanningTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.scanningProgress += 0.01
            if self.scanningProgress >= 1.0 {
                self.scanningProgress = 0.0
            }
        }
    }
    
    func stopScanningAnimation() {
        scanningTimer?.invalidate()
        scanningTimer = nil
        withAnimation(.easeOut(duration: 0.5)) {
            showScanningOverlay = false
        }
    }
    
    // MARK: - Recyclable Item Management
    
    
    func spawnNextItem() {
        guard !upcomingItems.isEmpty else {
            print("✅ All items classified!")
            return
        }

        currentRecyclableItem = upcomingItems.removeFirst()
        shouldSpawnRecyclableItem = true
        hasClassifiedItem = false
        isShowingClassificationForm = true
        isEditingRecyclable = true
        
        print("Spawning next item: \(currentRecyclableItem), isEditingRecyclable set to \(isEditingRecyclable)")
    }

    func clearRecyclableItem() {
        currentRecyclableItem = ""
        shouldSpawnRecyclableItem = false
        shouldRemoveRecyclableItem = true
        isShowingClassificationForm = false
        isEditingRecyclable = false
    }
    
    // MARK: - Placement Controls
    
    func confirmPlacement() {
        withAnimation {
            isConfirmedPlacement = true
        }
        
        // Provide haptic feedback for confirmation
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Spawn the first item after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.spawnNextItem()
        }
    }
    
    func reset() {
        withAnimation {
            hasTappedToPlace = false
            isConfirmedPlacement = false
            showScanningOverlay = true
            shouldRemoveRecyclableItem = true
            upcomingItems = ["waterBottle", "detergent", "waterCaps"].shuffled()
            didFinishMiniQuiz = false
            correctAnswers = 0
            totalAnswers = 0
            showCompletionOverlay = false
        }
        startScanningAnimation()
        
        // Provide haptic feedback for reset
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Game Completion
    
    func completeMinigame() {
        // Show completion overlay after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                self.showCompletionOverlay = true
            }
        }
    }
    
    deinit {
        scanningTimer?.invalidate()
    }
}
