//
//  VisualViewController.swift
//  music-drawer
//
//  Created by Lucy Zhang on 1/14/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import Cocoa

import SceneKit
import os.log

class VisualViewController: NSViewController {
    
    var musicLoader: MusicLoader!
    @IBOutlet weak var sceneView: SCNView!
    
    var fftMagnitudes = [Float]()
    
    lazy var particleSystem:SCNParticleSystem =
        {
            let system = SCNParticleSystem(named: "Explosion", inDirectory: nil)!
            system.loops = false
            return system
    }()
    
    var nodes:[SCNNode] = [SCNNode]()
    
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
        self.musicLoader = MusicLoader()
        musicLoader.delegate = self
        if (MusicManager.shared.audioFile != nil){
            musicLoader.begin(file: MusicManager.shared.audioFile)
        }
    }
    
    override func viewDidDisappear() {
        self.musicLoader.cancel()
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
    
    func addParticleSystem(particleSystem: SCNParticleSystem, name:String = ""){
        let systemNode = particleNode(particleSystem: particleSystem, name: name)
        addNode(node: systemNode)
    }
    
    func particleNode(particleSystem: SCNParticleSystem, name:String) -> SCNNode{
        let systemNode = SCNNode()
        systemNode.name = name
        systemNode.addParticleSystem(particleSystem)
        return systemNode
    }
    
    func addBox(position: SCNVector3, name:String){
        let boxGeometry = SCNBox(width: 0.10, height: 0.10, length: 0.10, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.name = name
        boxNode.position = position
        self.nodes.append(boxNode)
        addNode(node: boxNode)
    }
    
    func addNode(node:SCNNode){
        sceneView.scene?.rootNode.addChildNode(node)
    }
    
    
    
}

extension VisualViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let node = getNode(name: "particle"){
            os_log("%@: Particle birth rate: %@", self.description, node.particleSystems![0].birthRate)
        }
    }
}

extension VisualViewController: SCNPhysicsContactDelegate{
    
}


extension VisualViewController: MusicLoaderDelegate{
    func onPlay() {
        print("PLAY MUSIC")
        let incrementAngle = CGFloat((8*Float.pi) / Float(Constants.FRAME_COUNT))
        for i in 0..<(Constants.FRAME_COUNT/2) {
            let x = cos(CGFloat(i/2) * incrementAngle)
            let y = sin(CGFloat(i/2) * incrementAngle)
            addBox(position: SCNVector3Make(x, y, 0), name: "box\(i)")
        }
        //addParticleSystem(particleSystem: self.particleSystem, name: "particle0")
        //addParticleSystem(particleSystem: self.particleSystem)
        //addBox()
        
    }
    
    func dealWithFFTMagnitudes(magnitudes: [Float]) {
        //updateParticleSystem(fftMagnitudes: magnitudes)
        updateBox(fftMagnitudes: magnitudes)
        self.fftMagnitudes = magnitudes
    }
    
    func getNode(name:String) -> SCNNode?{
        return self.sceneView.scene?.rootNode.childNode(withName: name, recursively: true)
    }
    
    func updateBox(fftMagnitudes:[Float]){
        //        let node = getNode(name: "box")
        //        guard node != nil else{
        //            return
        //        }
        for (index, magnitude) in fftMagnitudes.enumerated(){
            let node = self.nodes[index]/*getNode(name: "box\(index)")*/ //{
            if (self.fftMagnitudes.count > index){
                let m = magnitude*100// /self.fftMagnitudes[index]
                let size = CGFloat(sqrt(magnitude))// /self.fftMagnitudes[index]
                if (!m.isNaN && !m.isInfinite){
                    let box = (node.geometry as! SCNBox)
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1
                    box.chamferRadius = CGFloat(m)
                    box.setSize(magnitude: size)
                    SCNTransaction.commit()
    
                }
            }
            
        }
        // }
    }
    
    func updateParticleSystem(fftMagnitudes:[Float]){
        let nodes = (self.sceneView.scene?.rootNode.childNodes)!
        
        for (index, magnitude) in fftMagnitudes.enumerated(){
            guard (nodes.count) > index else {
                let newSystem = self.particleSystem.copy() as! SCNParticleSystem
                addParticleSystem(particleSystem: newSystem, name: "particle\(index)")
                return
            }
            let node = nodes[index]
            if let systems = node.particleSystems{
                guard systems.count > 0 else {
                    return
                }
                let system = systems[0]
                if (self.fftMagnitudes.count > index)
                {
                    if (magnitude > 1.5*self.fftMagnitudes[index])
                    {
                        let m = CGFloat(10000*magnitude)
                        let newSystem = system.copy() as! SCNParticleSystem
                        newSystem.birthRate = m
                        let newNode = particleNode(particleSystem: newSystem, name: "particle\(index)")
                        self.sceneView.scene?.rootNode.replaceChildNode(node, with: newNode)
                    }
                }
                
            }
        }
    }
}

extension SCNBox{
    
    func setSize(magnitude:CGFloat){
        self.width = magnitude
        self.height = magnitude
        self.length = magnitude
    }
    
}
