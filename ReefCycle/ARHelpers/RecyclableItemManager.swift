//
//  RecyclableItemManager.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import ARKit
import SceneKit

class RecyclableItemManager {
    weak var sceneView: ARSCNView?
    private var currentItemNode: SCNNode?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    // MARK: - Item Management
    
    func spawnRecyclableItem(modelName: String) {
        guard let sceneView = sceneView,
              let scene = try? SCNScene(url: Bundle.main.url(forResource: modelName, withExtension: "usdz")!, options: nil),
              let modelNode = scene.rootNode.childNodes.first else {
            print("❌ Failed to load model: \(modelName)")
            return
        }

        print("✅ Successfully loaded model: \(modelName)")

        // Remove existing item
        removeRecyclableItem()

        // Clone node
        let itemNode = modelNode.clone()

        // Customize per model
        var scale: Float = 0.4
        var verticalOffset: Float = 0.0

        switch modelName {
        case "waterBottle":
            scale = 0.6
            verticalOffset = -0.1
        case "detergent":
            scale = 0.6
            verticalOffset = -0.2
        case "waterCaps":
            scale = 0.4
            verticalOffset = -0.05
        default:
            scale = 0.3
            verticalOffset = -0.1
        }

        // Position in front of camera
        let distanceFromCamera: Float = 0.35

        if let camera = sceneView.pointOfView {
            let transform = camera.transform
            let forward = SCNVector3(
                -transform.m31 * distanceFromCamera,
                -transform.m32 * distanceFromCamera,
                -transform.m33 * distanceFromCamera
            )

            let position = SCNVector3(
                transform.m41 + forward.x,
                transform.m42 + forward.y + verticalOffset,
                transform.m43 + forward.z
            )

            itemNode.position = position
        }

        itemNode.scale = SCNVector3(scale, scale, scale)
        itemNode.name = "recyclableItem"

        sceneView.scene.rootNode.addChildNode(itemNode)
        print("🧃 Added node to scene at: \(itemNode.position)")

        currentItemNode = itemNode

        // Smooth fade-in
        itemNode.opacity = 0
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        itemNode.opacity = 1
        SCNTransaction.commit()
    }
    
    func removeRecyclableItem() {
        if let node = currentItemNode {
            node.removeFromParentNode()
            currentItemNode = nil
        }
    }
    
    // MARK: - Item Interaction
    
    func makeItemManipulable() {
        guard let itemNode = currentItemNode else {
            print("⚠️ Can't make item manipulable - no current item node")
            return
        }
        
        print("✅ Making item manipulable")
        
        // Add highlight effect to show it's interactive
        let action = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.7, duration: 0.2),
            SCNAction.fadeOpacity(to: 1.0, duration: 0.2)
        ])
        itemNode.runAction(action)
        
        // Add a subtle floating animation to indicate interactivity
        let floatSequence = SCNAction.sequence([
            SCNAction.moveBy(x: 0, y: 0.01, z: 0, duration: 1.0),
            SCNAction.moveBy(x: 0, y: -0.01, z: 0, duration: 1.0)
        ])
        itemNode.runAction(SCNAction.repeatForever(floatSequence), forKey: "floating")
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func toggleItemRotation() {
        guard let itemNode = currentItemNode else {
            print("⚠️ Cannot toggle rotation - no current item node")
            return
        }
        
        print("Toggling item rotation")
        
        if itemNode.action(forKey: "rotating") != nil {
            // Stop rotation
            itemNode.removeAction(forKey: "rotating")
        } else {
            // Start rotation
            let rotateAction = SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 5.0)
            )
            itemNode.runAction(rotateAction, forKey: "rotating")
            
            // Provide haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    // MARK: - Animations
    
    func animateItemToBin(targetNode: SCNNode, completion: @escaping () -> Void) {
        guard let itemNode = currentItemNode else {
            completion()
            return
        }
        
        // Get target position in world space
        let targetWorldPosition = targetNode.convertPosition(SCNVector3Zero, to: sceneView?.scene.rootNode)
        
        // Animate movement
        let move = SCNAction.move(to: targetWorldPosition, duration: 0.8)
        move.timingMode = .easeInEaseOut
        
        // Shrink & fade
        let scaleDown = SCNAction.scale(to: 0.01, duration: 0.3)
        let fadeOut = SCNAction.fadeOut(duration: 0.3)
        let vanish = SCNAction.group([scaleDown, fadeOut])
        
        // Clear any emission
        itemNode.enumerateChildNodes { (child, _) in
            child.geometry?.firstMaterial?.emission.contents = UIColor.black
            child.geometry?.firstMaterial?.emission.intensity = 0
        }
        
        // Cleanup action
        let cleanup = SCNAction.run { [weak self] _ in
            self?.removeRecyclableItem()
            completion()
        }
        
        // Run sequence
        let sequence = SCNAction.sequence([move, vanish, cleanup])
        itemNode.runAction(sequence)
    }
    
    // MARK: - Access Properties
    
    var currentRecyclableNode: SCNNode? {
        return currentItemNode
    }
}
