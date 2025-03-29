//
//  ARViewContainer.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import SwiftUI
import ARKit
import Combine
import SceneKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: TrashcanPlacementViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        
        // Setup the AR Scene using the new managers
        context.coordinator.setupAR(sceneView: sceneView)
        
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if viewModel.hasClassifiedItem,
           let guess = viewModel.selectedMaterialGuess,
           let coordinator = context.coordinator as? Coordinator,
           let modelName = viewModel.currentRecyclableItem as String? {

            viewModel.hasClassifiedItem = false // avoid double trigger

            DispatchQueue.main.async {
                coordinator.handleClassification(guessedType: guess, actualModelName: modelName)
            }
        }
        
        if viewModel.shouldSpawnRecyclableItem && !viewModel.currentRecyclableItem.isEmpty {
            context.coordinator.spawnRecyclable(modelName: viewModel.currentRecyclableItem)
            viewModel.shouldSpawnRecyclableItem = false
        }
        
        if viewModel.shouldRemoveRecyclableItem {
            context.coordinator.removeRecyclable()
            viewModel.shouldRemoveRecyclableItem = false
        }
    }

    class Coordinator: NSObject, ARSceneManagerDelegate {
        var viewModel: TrashcanPlacementViewModel
        // Change these from private to internal (default) access level
        var arSceneManager: ARSceneManager?
        var trashcanManager: TrashcanManager?
        var recyclableManager: RecyclableItemManager?
        var interactionHandler: ARInteractionHandler?
        private var subscriptions = Set<AnyCancellable>()

        init(viewModel: TrashcanPlacementViewModel) {
            self.viewModel = viewModel
            super.init()
        }
        
        func setupAR(sceneView: ARSCNView) {
            // Initialize all the managers
            arSceneManager = ARSceneManager()
            arSceneManager?.delegate = self
            arSceneManager?.setupScene(sceneView: sceneView)
            
            trashcanManager = TrashcanManager(sceneView: sceneView)
            recyclableManager = RecyclableItemManager(sceneView: sceneView)
            
            // Create the interaction handler AFTER creating the managers
            interactionHandler = ARInteractionHandler(
                sceneView: sceneView,
                viewModel: viewModel,
                trashcanManager: trashcanManager,
                recyclableManager: recyclableManager
            )
            
            // Set up observation of ViewModel changes
            observeViewModelChanges()
        }
        
        // ARSceneManagerDelegate
        func didDetectFirstPlane() {
            viewModel.stopScanningAnimation()
        }
        
        func observeViewModelChanges() {
            viewModel.objectWillChange
                .sink { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.handleViewModelUpdate()
                    }
                }
                .store(in: &subscriptions)
        }
        
        func handleViewModelUpdate() {
            // Any additional update handling can go here
            if viewModel.hasTappedToPlace && arSceneManager != nil {
                arSceneManager?.removeAllPlaneVisualizations()
                arSceneManager?.disablePlaneDetectionAndRemovePlanes()
            }
        }
        
        func spawnRecyclable(modelName: String) {
            print("Spawning recyclable: \(modelName)")
            recyclableManager?.spawnRecyclableItem(modelName: modelName)
            
            // Set a slight delay and then make the item manipulable
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.recyclableManager?.makeItemManipulable()
            }
        }
        
        func removeRecyclable() {
            recyclableManager?.removeRecyclableItem()
        }
        
        func handleClassification(guessedType: String, actualModelName: String) {
            interactionHandler?.animateRecyclableToBin(guessedType: guessedType, actualModelName: actualModelName)
        }
    }
}
