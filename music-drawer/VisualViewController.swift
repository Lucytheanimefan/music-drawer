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
        // Do view setup here.
        
        
        
    }
    
    override func viewDidAppear() {
        self.musicLoader = MusicLoader()
        musicLoader.delegate = self
        if (MusicManager.shared.audioFile != nil){
        musicLoader.begin(file: MusicManager.shared.audioFile)
        }
    }
    
}

extension VisualViewController: MusicLoaderDelegate{
    func onPlay() {
        print("PLAY MUSIC")
    }
    
    func dealWithFFTMagnitudes(magnitudes: [Float]) {
        
    }
    
    
}
