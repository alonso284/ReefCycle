//
//  ARInteractionHandler.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import Foundation
import ARKit
import SceneKit

class ARInteractionHandler {
    weak var sceneView: ARSCNView?
    private var trashcanManager: TrashcanManager?
    private var recyclableManager: RecyclableItemManager?
    private var viewModel: TrashcanPlacementViewModel?
    private var hasAddedTrashcans = false
    
    // Updated initializer to accept managers directly
    init(sceneView: ARSCNView, viewModel: TrashcanPlacementViewModel,
         trashcanManager: TrashcanManager?, recyclableManager: RecyclableItemManager?) {
        self.sceneView = sceneView
        self.viewModel = viewModel
        self.trashcanManager = trashcanManager
        self.recyclableManager = recyclableManager
        
        setupGestureRecognizers()
    }
    
    // Original initializer (keep for backward compatibility if needed)
    init(sceneView: ARSCNView, viewModel: TrashcanPlacementViewModel) {
        self.sceneView = sceneView
        self.viewModel = viewModel
        
        // Create managers internally (not recommended anymore)
        self.trashcanManager = TrashcanManager(sceneView: sceneView)
        self.recyclableManager = RecyclableItemManager(sceneView: sceneView)
        
        setupGestureRecognizers()
    }

    
    private func setupGestureRecognizers() {
        guard let sceneView = sceneView else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        
        sceneView.addGestureRecognizer(rotationGesture)
        sceneView.addGestureRecognizer(tapGesture)
        sceneView.addGestureRecognizer(pinchGesture)
        sceneView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Handlers
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let sceneView = sceneView,
              let viewModel = viewModel else { return }
        
        let location = gesture.location(in: sceneView)

        // Handle recyclable item tap - CRITICAL for rotation
        if viewModel.isConfirmedPlacement,
           let recyclableManager = recyclableManager,
           let item = recyclableManager.currentRecyclableNode {
            let hitResults = sceneView.hitTest(location, options: [.boundingBoxOnly: true])

            if let hit = hitResults.first,
               (hit.node === item || hit.node.isDescendant(of: item)) {
                print("✅ Recyclable item tapped - toggling rotation")
                recyclableManager.toggleItemRotation()
                return
            }
        }

        /// Handle trashcan tap for classification
        if !viewModel.currentRecyclableItem.isEmpty,
           let trashcanManager = trashcanManager,
           let groupNode = trashcanManager.currentGroupNode,
           viewModel.hasClassifiedItem == false {

            let hitResults = sceneView.hitTest(location, options: [.boundingBoxOnly: true])

            for (index, binNode) in groupNode.childNodes.enumerated() where binNode.name == "trashcan_\(index)" {
                if let hit = hitResults.first,
                   hit.node === binNode || hit.node.isDescendant(of: binNode) {

                    print("🗳️ Tapped bin \(index)")

                    if let correctIndex = viewModel.correctBinIndex(for: viewModel.currentRecyclableItem) {
                        let isCorrect = index == correctIndex
                        viewModel.hasClassifiedItem = true
                        viewModel.isClassificationCorrect = isCorrect
                        viewModel.selectedMaterialGuess = ["PET 1", "HDPE 2", "PP 5"][index]
                        
                        // ADD THIS: Track score
                        print("📊 Recording classification - correct: \(isCorrect)")
                        if isCorrect {
                            viewModel.correctAnswers += 1
                        }
                        viewModel.totalAnswers += 1
                        
                        // Visual feedback
                        trashcanManager.showClassificationFeedback(on: binNode, success: isCorrect)
                    }
                    return
                }
            }        }

        // Handle initial placement of trashcans
        if !viewModel.hasTappedToPlace {
            let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])

            guard let result = results.first else {
                showTapFeedback(at: location, success: false)
                return
            }

            showTapFeedback(at: location, success: true)

            let position = SCNVector3(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )

            DispatchQueue.main.async {
                viewModel.hasTappedToPlace = true
                self.trashcanManager?.placeTrashcans(at: position)
                self.hasAddedTrashcans = true
            }
        }
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let viewModel = viewModel else { return }

        let scale = Float(gesture.scale)

        if viewModel.isEditingRecyclable,
           let node = recyclableManager?.currentRecyclableNode {
            if gesture.state == .changed || gesture.state == .ended {
                let newScale = SCNVector3(
                    min(max(node.scale.x * scale, 0.2), 2.0),
                    min(max(node.scale.y * scale, 0.2), 2.0),
                    min(max(node.scale.z * scale, 0.2), 2.0)
                )
                node.scale = newScale
                gesture.scale = 1.0

                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        } else if viewModel.isEditing,
                  let node = trashcanManager?.currentGroupNode {
            if gesture.state == .changed || gesture.state == .ended {
                let newScale = SCNVector3(
                    min(max(node.scale.x * scale, 0.2), 2.0),
                    min(max(node.scale.y * scale, 0.2), 2.0),
                    min(max(node.scale.z * scale, 0.2), 2.0)
                )
                node.scale = newScale
                gesture.scale = 1.0

                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let viewModel = viewModel else { return }

        let rotation = Float(gesture.rotation)

        if viewModel.isEditingRecyclable,
           let node = recyclableManager?.currentRecyclableNode {
            if gesture.state == .changed || gesture.state == .ended {
                node.eulerAngles.y += rotation
                gesture.rotation = 0

                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        } else if viewModel.isEditing,
                  let node = trashcanManager?.currentGroupNode {
            if gesture.state == .changed || gesture.state == .ended {
                node.eulerAngles.y += rotation
                gesture.rotation = 0

                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let sceneView = sceneView, let viewModel = viewModel else { return }

        // ENHANCEMENT: Add more debug logging to diagnose the issues
        if gesture.state == .began {
            print("Pan gesture began - isEditingRecyclable: \(viewModel.isEditingRecyclable)")
            if let node = recyclableManager?.currentRecyclableNode {
                print("Current recyclable node exists")
            }
        }

        // Recyclable mode - Use pan to rotate the item with higher sensitivity
        if viewModel.isEditingRecyclable, let node = recyclableManager?.currentRecyclableNode {
            let translation = gesture.translation(in: gesture.view)
            // Increase sensitivity for better rotation control
            let sensitivity: Float = 0.01 // Doubled from original

            if gesture.state == .changed {
                let deltaX = Float(translation.x) * sensitivity
                let deltaY = Float(translation.y) * sensitivity

                node.eulerAngles.y += deltaX // spin
                node.eulerAngles.x += deltaY // tilt
                gesture.setTranslation(.zero, in: gesture.view)
            }

            if gesture.state == .began || gesture.state == .ended {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }

            return // ✅ done for recyclable
        }

        // Trashcan editing ➤ Use pan to move the group
        if viewModel.isEditing, let node = trashcanManager?.currentGroupNode {
            let location = gesture.location(in: sceneView)
            let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])

            if let result = results.first {
                let position = SCNVector3(
                    result.worldTransform.columns.3.x,
                    result.worldTransform.columns.3.y,
                    result.worldTransform.columns.3.z
                )

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                node.position = position
                SCNTransaction.commit()

                if gesture.state == .began || gesture.state == .ended {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
        }
    }
    
    // MARK: - UI Feedback
    
    func showTapFeedback(at point: CGPoint, success: Bool) {
        guard let sceneView = sceneView else { return }
        
        let feedbackView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        feedbackView.center = point
        feedbackView.backgroundColor = success ? UIColor.green.withAlphaComponent(0.6) : UIColor.red.withAlphaComponent(0.6)
        feedbackView.layer.cornerRadius = 15
        sceneView.addSubview(feedbackView)
        
        UIView.animate(withDuration: 0.5, animations: {
            feedbackView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            feedbackView.alpha = 0
        }) { _ in
            feedbackView.removeFromSuperview()
        }
    }
    
    // MARK: - Classification and Animation
    
    func animateRecyclableToBin(guessedType: String, actualModelName: String) {
        guard let viewModel = viewModel,
              let trashcanManager = trashcanManager,
              let groupNode = trashcanManager.currentGroupNode else {
            return
        }
        
        // Map material to bin index
        let binIndexMap = [
            "PET 1": 0,
            "HDPE 2": 1,
            "PP 5": 2
        ]
        
        let actualBin = viewModel.correctBinIndex(for: actualModelName)
        let guessedBin = binIndexMap[guessedType]

        let isCorrect = guessedBin == actualBin
        viewModel.isClassificationCorrect = isCorrect
        viewModel.showValidationSymbol = true
        
        // IMPORTANT: Track score here - this ensures all classifications are counted
        // regardless of whether they come from bin taps or UI buttons
        print("📊 Recording classification - correct: \(isCorrect)")
        if isCorrect {
            viewModel.correctAnswers += 1
        }
        viewModel.totalAnswers += 1
        
        // Find the bin node
        guard let binIndex = guessedBin,
              let binNode = groupNode.childNodes.first(where: { $0.name == "trashcan_\(binIndex)" }) else {
            return
        }
        
        // Animate the item to the bin
        recyclableManager?.animateItemToBin(targetNode: binNode) {
            // Cleanup after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                viewModel.showValidationSymbol = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if viewModel.upcomingItems.isEmpty {
                    // Store the position before removing trashcans
                    let position = groupNode.position
                    
                    // First explicitly remove the recyclable item
                    viewModel.clearRecyclableItem()
                    self.recyclableManager?.removeRecyclableItem()
                    
                    // Then show the Monito
                    trashcanManager.removeTrashcans()
                    trashcanManager.showMonito(at: position)
                    viewModel.didFinishMiniQuiz = true
                    
                    // Call the completeMinigame method to show the completion overlay
                    print("🎮 Mini-quiz complete with score: \(viewModel.correctAnswers)/\(viewModel.totalAnswers)")
                    viewModel.completeMinigame()
                } else {
                    viewModel.spawnNextItem()
                }
            }
        }
    }
}

// Extension for SCNNode to check if a node is a descendant of another
extension SCNNode {
    func isDescendant(of ancestor: SCNNode) -> Bool {
        var node: SCNNode? = self
        while let current = node {
            if current === ancestor {
                return true
            }
            node = current.parent
        }
        return false
    }
}
