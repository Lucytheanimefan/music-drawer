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

class ViewController: NSViewController, AVAudioPlayerDelegate {
    var audioPlayer:AVAudioPlayer!
    
    var audioInputAvailable = true
    
    private var _audioFile:URL!
    var audioFile:URL {
        get {
            return self._audioFile
        }
        set{
            self._audioFile = newValue
            self.playButton.isEnabled = (newValue.absoluteString != "" && newValue != nil)
        }
    }
    
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var playButton: NSButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getFileURL() -> URL? {
        
        let filePath = Bundle.main.url(forResource: "angel_beats_short", withExtension: "wav")
        
        return filePath
    }
    
    
    func preparePlayer() {
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: self.audioFile)
            audioPlayer.delegate = self//NSApplication.shared().delegate
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        }
        catch
        {
            print(error)
        }
        
    }
    
   
    @IBAction func playSound(_ sender: NSButton) {
        if (sender.title == "Play"){
            sender.title = "Stop"
            preparePlayer()
            audioPlayer.play()
        } else {
            audioPlayer.stop()
            sender.title = "Play"
        }
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
        
        if (panel.runModal() == NSModalResponseOK){
            if let filePath = panel.url {
                self.audioFile = filePath
                self.fileNameLabel.stringValue = filePath.absoluteString
            }
        }
    }
    
 
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

