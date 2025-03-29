//
//  TrashcanManager.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import ARKit
import SceneKit

class TrashcanManager {
    weak var sceneView: ARSCNView?
    private var groupNode: SCNNode?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    // MARK: - Trashcan Placement
    
    func placeTrashcans(at position: SCNVector3) {
        guard let sceneView = sceneView else { return }

        let containerNode = SCNNode()
        containerNode.position = position
        self.groupNode = containerNode

        let materials: [TrashcanMaterial] = [
            TrashcanMaterial(diffuse: "PET1", roughness: "PET1Roughness", metallic: "PET1Metallic"),
            TrashcanMaterial(diffuse: "HDPE2", roughness: "HDPE2Roughness", metallic: "HDPE2Metallic"),
            TrashcanMaterial(diffuse: "PP5", roughness: "PP5Roughness", metallic: "PP5Metallic")
        ]

        let spacing: Float = 0.37

        for (index, mat) in materials.enumerated() {
            guard let scene = try? SCNScene(url: Bundle.main.url(forResource: "trashCan", withExtension: "usdz")!, options: nil),
                  let originalNode = scene.rootNode.childNodes.first else {
                continue
            }

            let instance = originalNode.clone()
            instance.eulerAngles.x = -.pi / 2 // Rotate upright

            // Apply PBR material
            applyPBRMaterialRecursively(to: instance, material: mat)

            // Animation setup
            instance.opacity = 0
            instance.scale = SCNVector3(0.1, 0.1, 0.1)
            instance.position = SCNVector3(Float(index) * spacing, -0.5, 0)
            instance.name = "trashcan_\(index)"
            containerNode.addChildNode(instance)
          
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
            SCNTransaction.completionBlock = {
                let bounceUp = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 0.1)
                let bounceDown = SCNAction.moveBy(x: 0, y: -0.05, z: 0, duration: 0.1)
                let bounceSequence = SCNAction.sequence([bounceUp, bounceDown])
                instance.runAction(bounceSequence)
            }

            instance.position = SCNVector3(Float(index) * spacing, 0, 0)
            instance.opacity = 1
            instance.scale = SCNVector3(1, 1, 1)

            SCNTransaction.commit()
        }

        addShadowCastingLight(to: containerNode)
        sceneView.scene.rootNode.addChildNode(containerNode)
    }
    
    // MARK: - Visual Feedback
    
    func showClassificationFeedback(on node: SCNNode, success: Bool) {
        let originalMaterials = node.geometry?.materials ?? []
        let highlightColor = success ? UIColor.green : UIColor.red

        let mat = SCNMaterial()
        mat.diffuse.contents = highlightColor.withAlphaComponent(0.8)
        mat.emission.contents = highlightColor
        mat.transparency = 0.6

        node.geometry?.materials = [mat]

        // Haptic feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(success ? .success : .error)

        // Revert material after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            node.geometry?.materials = originalMaterials
        }
    }
    
    // MARK: - Material Application
    
    func applyPBRMaterialRecursively(to node: SCNNode, material: TrashcanMaterial) {
        if let geometry = node.geometry {
            let mat = SCNMaterial()
            mat.diffuse.contents = UIImage(named: material.diffuse)
            mat.roughness.contents = UIImage(named: material.roughness)
            mat.metalness.contents = UIImage(named: material.metallic)
            mat.lightingModel = .physicallyBased
            geometry.materials = [mat]
        }

        for child in node.childNodes {
            applyPBRMaterialRecursively(to: child, material: material)
        }
    }
    
    // MARK: - Lighting
    
    func addShadowCastingLight(to node: SCNNode) {
        let light = SCNLight()
        light.type = .directional
        light.intensity = 1000
        light.castsShadow = true
        light.shadowMode = .deferred
        light.shadowColor = UIColor.black.withAlphaComponent(0.5)
        light.shadowSampleCount = 8
        light.shadowRadius = 6
        light.categoryBitMask = 2

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.eulerAngles = SCNVector3(-Float.pi / 3, 0, 0)
        lightNode.position = SCNVector3(0, 1.5, 1.5)

        node.addChildNode(lightNode)
    }
    
    // MARK: - Game Completion
    
    func showMonito(at position: SCNVector3) {
        guard let sceneView = sceneView,
              let url = Bundle.main.url(forResource: "dancingRigged", withExtension: "usdz"),
              let monitoScene = try? SCNScene(url: url, options: nil) else {
            print("❌ Could not load Monito model")
            return
        }

        let monitoNode = SCNNode()
        for child in monitoScene.rootNode.childNodes {
            monitoNode.addChildNode(child)
        }
        monitoNode.eulerAngles.x = -.pi / 2 // Rotate upright
        monitoNode.position = position
        monitoNode.scale = SCNVector3(0.3, 0.3, 0.3)
        monitoNode.name = "monito"
        sceneView.scene.rootNode.addChildNode(monitoNode)

        // Play animation if available
        if let animationKeys = monitoNode.animationKeys.first {
            print("▶️ Playing animation: \(animationKeys)")
            if let animation = monitoNode.animation(forKey: animationKeys) {
                monitoNode.addAnimation(animation, forKey: animationKeys)
            }
        } else {
            print("ℹ️ No animation keys found")
        }
    }
    
    // MARK: - Cleanup
    
    func removeTrashcans() {
        groupNode?.removeFromParentNode()
        groupNode = nil
    }
    
    // MARK: - Access Properties
    
    var currentGroupNode: SCNNode? {
        return groupNode
    }
}
