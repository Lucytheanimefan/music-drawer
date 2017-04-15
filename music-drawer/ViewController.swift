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
    var audioRecording = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.title="Music Drawer"
        initAudioEngine()
        //audioRecorder.prepareToRecord()
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func initAudioEngine(){

        audioRecording = AVAudioPlayer(contentsOf: receivedAudio.filePathURL as URL)
        audioRecording.enableRate = true
        
        audioEngine = AVAudioEngine()
    }

    @IBAction func record(_ sender: Any) {
        audioRecording.stop()
        audioRecording.currentTime = 0
        audioRecording.play()
    }
    
    @IBAction func stop(_ sender: Any) {
        //audioRecorder.stop()
        audioRecording.stop()
    }
    
   func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        audioFile = AVAudioFile(forWriting: receivedAudio.filePathURL as URL, settings: [""])
        //1
        var path = Bundle.main.path(forResource: file as String, ofType: type as String)
        var url = NSURL.fileURL(withPath: path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOf: url)

        //4
        return audioPlayer!
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioRecording.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        //audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        
    }

}

extension ViewController: AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Done recording: file path")
        //print(audioRecorder.url.absoluteString)
    }
    
}
