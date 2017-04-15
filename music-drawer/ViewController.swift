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
    let recorderFilePath = NSURL.fileURL(withPath: "/Users/lucyzhang/Github/music-drawer/recordings")
    var audioRecorder:AVAudioRecorder? = nil
    
    var audioInputAvailable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.title="Music Drawer"
        var recordSettings = ["stuff":"stuff"]
        try! audioRecorder = AVAudioRecorder(url: recorderFilePath, settings: recordSettings)
        audioRecorder?.delegate = NSApplication.shared().delegate as? AVAudioRecorderDelegate
        
        //prepare to record
        audioRecorder?.prepareToRecord()

        
    }
    @IBAction func stop(_ sender: Any) {
        audioRecorder?.stop()
    }
    
    @IBAction func record(_ sender: Any) {
        audioRecorder?.record()
        print(audioRecorder.debugDescription)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

