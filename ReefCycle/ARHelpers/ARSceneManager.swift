//
//  ARSceneManager.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import ARKit
import SceneKit
import Combine

protocol ARSceneManagerDelegate: AnyObject {
    func didDetectFirstPlane()
}

class ARSceneManager: NSObject, ARSCNViewDelegate {
    weak var sceneView: ARSCNView?
    private var planeNodes = [UUID: SCNNode]()
    private var planeDetectionStartTime: Date?
    
    // Delegate to handle plane detection events
    weak var delegate: ARSceneManagerDelegate?
    
    func setupScene(sceneView: ARSCNView) {
        self.sceneView = sceneView
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = true
        
        // Use more subtle feature points visualization
        sceneView.debugOptions = [.showFeaturePoints]
        
        setupLighting(in: sceneView)
        startPlaneDetection()
    }
    
    // MARK: - Plane Detection
    
    func startPlaneDetection() {
        guard let sceneView = sceneView else { return }
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        // Enhanced environment texturing for better realism
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        sceneView.session.run(config)
        planeDetectionStartTime = Date()
    }
    
    func disablePlaneDetectionAndRemovePlanes() {
        guard let sceneView = sceneView,
              let currentConfig = sceneView.session.configuration as? ARWorldTrackingConfiguration else {
            print("❌ Unable to disable plane detection")
            return
        }

        // Stop plane detection
        currentConfig.planeDetection = []
        sceneView.session.run(currentConfig)

        // Remove visual plane nodes
        for anchor in sceneView.session.currentFrame?.anchors ?? [] {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                if let node = sceneView.node(for: planeAnchor) {
                    node.removeFromParentNode()
                }
            }
        }

        // Clear tracked planes
        planeNodes.removeAll()

        print("✅ Plane detection disabled and all planes removed")
    }
    
    func removeAllPlaneVisualizations() {
        for (_, node) in planeNodes {
            node.removeFromParentNode()
        }
        planeNodes.removeAll()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // First plane detected
        DispatchQueue.main.async {
            if self.planeNodes.isEmpty {
                self.delegate?.didDetectFirstPlane()
            }
        }
        
        let planeNode = createPlaneNode(for: planeAnchor)
        node.addChildNode(planeNode)
        planeNodes[planeAnchor.identifier] = planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = planeNodes[planeAnchor.identifier] else { return }
        
        updatePlaneNode(planeNode, for: planeAnchor)
    }
    
    // MARK: - Plane Node Creation and Update
    
    private func createPlaneNode(for anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "plane_detection")
        material.isDoubleSided = true
        material.transparency = 0.6
        plane.materials = [material]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.7
        
        // Add a subtle animation
        let pulseAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.4, duration: 1.0),
            SCNAction.fadeOpacity(to: 0.7, duration: 1.0)
        ])
        planeNode.runAction(SCNAction.repeatForever(pulseAction))
        
        return planeNode
    }
    
    private func updatePlaneNode(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        guard let plane = node.geometry as? SCNPlane else { return }
        
        // Update plane size
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        
        // Update position
        node.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
    
    // MARK: - Lighting Setup
    
    private func setupLighting(in sceneView: ARSCNView) {
        // Ambient Light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 500
        ambientLight.color = UIColor.white

        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        sceneView.scene.rootNode.addChildNode(ambientNode)

        // Directional Light
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000
        directionalLight.color = UIColor.white
        directionalLight.castsShadow = true
        directionalLight.shadowMode = .deferred
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.5)

        let directionalNode = SCNNode()
        directionalNode.light = directionalLight
        directionalNode.eulerAngles = SCNVector3(-Float.pi / 3, 0, 0)
        directionalNode.position = SCNVector3(0, 2, 2)

        sceneView.scene.rootNode.addChildNode(directionalNode)
    }
    
    // MARK: - Utility Methods
    
    func createRadialGradient(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let colors = [
                UIColor.gray.withAlphaComponent(0.6).cgColor,
                UIColor.gray.withAlphaComponent(0.0).cgColor
            ]
            
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0.0, 1.0]
            )!
            
            ctx.cgContext.drawRadialGradient(
                gradient,
                startCenter: center,
                startRadius: 0,
                endCenter: center,
                endRadius: size.width/2,
                options: []
            )
        }
        return image
    }
}
