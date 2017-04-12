//
//  ViewController.swift
//  music-drawer
//
//  Created by Lucy Zhang on 4/11/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Cocoa
import CoreAudio
import AVFoundation

class ViewController: NSViewController {
    
    let audioRecorder = AVAudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.title="Music Drawer"
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.setFrame(NSRect(x:0,y:0,width:10000,height:10000), display: true)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func record(_ sender: Any) {
        audioRecorder.record()
        var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.stop), userInfo: nil, repeats: true);
    }
    
    func stop(){
        audioRecorder.stop()
    }

}

