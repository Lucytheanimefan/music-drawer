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
    
    var audioInputAvailable = true
    
    @IBOutlet var debugView: NSTextView!
    
    @IBOutlet weak var fileNameLabel: NSTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func uploadMusic(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.title = "Choose a file"
        panel.showsResizeIndicator    = true;
        panel.showsHiddenFiles        = false;
        panel.canChooseDirectories    = true;
        panel.canCreateDirectories    = true;
        panel.allowsMultipleSelection = false;
        panel.allowedFileTypes        = ["wav", "mp3"];
        
        panel.beginSheetModal(for: self.view.window!) { (response) in
            if (response == NSModalResponseOK){
                if let filePath = panel.url {
                    MusicManager.shared.audioFile = filePath
                    self.fileNameLabel.stringValue = filePath.absoluteString
                }
            }
        }
        
//        if (panel.runModal() == NSModalResponseOK){
//            if let filePath = panel.url {
//                MusicManager.shared.audioFile = filePath
//                self.fileNameLabel.stringValue = filePath.absoluteString
//            }
//        }
    }
    
 
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

extension ViewController: MusicLoaderDelegate{
    func onPlay() {
        
    }
    
    func dealWithFFTMagnitudes(magnitudes: [Float]) {
        DispatchQueue.main.async {
            self.debugView.string = magnitudes.description
        }
    }
    
    
}






