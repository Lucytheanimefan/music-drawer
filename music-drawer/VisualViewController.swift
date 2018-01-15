//
//  VisualViewController.swift
//  music-drawer
//
//  Created by Lucy Zhang on 1/14/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import Cocoa

import SceneKit

class VisualViewController: NSViewController {
    
    var musicLoader: MusicLoader!
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.scene = SCNScene()
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.scene?.physicsWorld.contactDelegate = self
        self.sceneView.allowsCameraControl = true
        self.sceneView.backgroundColor = .black
        addAmbientLight()
        addOmniLight()
    }
    
    override func viewDidAppear() {
        addParticleSystem()
        self.musicLoader = MusicLoader()
        musicLoader.delegate = self
        if (MusicManager.shared.audioFile != nil){
            musicLoader.begin(file: MusicManager.shared.audioFile)
        }
    }
    
    func addAmbientLight(){
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = NSColor(white: 0.67, alpha: 1.0)
        addNode(node: ambientLightNode)
    }
    
    func addOmniLight(){
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = NSColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        addNode(node: omniLightNode)
    }
    
    func addParticleSystem(){
        if let particleSystem = SCNParticleSystem(named: "Explosion", inDirectory: nil){
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem)
            //systemNode.position = SCNVector3Make(0, 0, 0)
            addNode(node: systemNode)
        }
    }
    
    func addBox(){
        let boxGeometry = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        addNode(node: boxNode)
    }
    
    func addNode(node:SCNNode){
        sceneView.scene?.rootNode.addChildNode(node)
    }
    
}

extension VisualViewController: SCNSceneRendererDelegate{
    
}

extension VisualViewController: SCNPhysicsContactDelegate{
    
}


extension VisualViewController: MusicLoaderDelegate{
    func onPlay() {
        print("PLAY MUSIC")
        addBox()
       
    }
    
    func dealWithFFTMagnitudes(magnitudes: [Float]) {
        
    }
    
}
