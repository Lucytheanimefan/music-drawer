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
    
    //typealias myFunc = (_ fftMagnitudes:[Float]) -> Void
    
    var musicLoader: MusicLoader!
    @IBOutlet weak var sceneView: SCNView!
    
    var fftMagnitudes = [Float]()
    
    @IBOutlet weak var settingsTableView: NSTableView!
    
    let vizOptions:[String] = ["Sphere", "Particle"]
    
    lazy var visualizationOptions:[String:([Float])->Void] =
        {
            return ["Sphere":self.boxUpdate, "Particle": self.particleUpdate]
    }()
    
    lazy var setupOptions:[String:(()->Void)] = {
        return ["Sphere": self.boxSetup]
    }()
    
    lazy var particleSystem:SCNParticleSystem =
        {
            let system = SCNParticleSystem(named: "Explosion", inDirectory: nil)!
            system.loops = false
            return system
    }()
    
    var nodes:[SCNNode] = [SCNNode]()
    
    private var _currentRunningViz: (([Float])->Void)? = nil
    var currentRunningVisualization: (([Float])->Void)? {
        get {
            return self._currentRunningViz
        }
        
        set{
            self._currentRunningViz = newValue
            self.sceneView.scene?.rootNode.enumerateChildNodes({ (node, stop) in
                node.removeFromParentNode()
            })
            
        }
    }
    
    var initialSceneSetup:(()->Void)?
    
    lazy var boxUpdate: ([Float])->Void = {
        (arg: [Float]) -> Void in
        self.updateBox(fftMagnitudes: arg)
    }
    
    lazy var particleUpdate: ([Float])->Void = {
        (arg: [Float]) -> Void in
        self.updateParticleSystem(fftMagnitudes: arg)
    }
    
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
        self.initialSceneSetup = self.setupOptions["Sphere"]!
        self.currentRunningVisualization = self.visualizationOptions["Sphere"]
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
        self.initialSceneSetup!()
    }
    
    func dealWithFFTMagnitudes(magnitudes: [Float]) {
        guard self.currentRunningVisualization != nil else {
            return
        }
        self.currentRunningVisualization!(magnitudes)
        //updateParticleSystem(fftMagnitudes: magnitudes)
        //updateBox(fftMagnitudes: magnitudes)
        self.fftMagnitudes = magnitudes
    }
    
    func getNode(name:String) -> SCNNode?{
        return self.sceneView.scene?.rootNode.childNode(withName: name, recursively: true)
    }
    
    func boxSetup(){
        print("BOX SETUP CALLED")
        let incrementAngle = CGFloat((8*Float.pi) / Float(Constants.FRAME_COUNT))
        for i in 0..<(Constants.FRAME_COUNT/2) {
            let x = cos(CGFloat(i/2) * incrementAngle)
            let y = sin(CGFloat(i/2) * incrementAngle)
            addBox(position: SCNVector3Make(x, y, 0), name: "box\(i)")
        }
    }
    
    func updateBox(fftMagnitudes:[Float]) -> Void{
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
    }
    
    func updateParticleSystem(fftMagnitudes:[Float]) -> Void{
        let nodes = (self.sceneView.scene?.rootNode.childNodes)!
        
        for (index, magnitude) in fftMagnitudes.enumerated(){
            guard (nodes.count) > index && nodes[index].particleSystems != nil else {
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

extension VisualViewController: NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.vizOptions.count
    }
    
}

extension VisualViewController: NSTableViewDelegate{
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let view = tableView.makeView(withIdentifier: .init("settingsCellID"), owner: nil) as? NSTableCellView
        {
            view.textField?.stringValue = self.vizOptions[row]
            return view
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = self.settingsTableView.selectedRow
        let option = self.vizOptions[row]
        if let setup = self.setupOptions[option]
        {
            setup()
        }
        self.currentRunningVisualization = self.visualizationOptions[option]!
    }
    
}

extension SCNBox{
    
    func setSize(magnitude:CGFloat){
        self.width = magnitude
        self.height = magnitude
        self.length = magnitude
    }
    
}
