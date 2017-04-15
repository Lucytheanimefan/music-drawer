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

class ViewController: NSViewController, AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    let recorderFilePath = NSURL.fileURL(withPath: "/Users/lucyzhang/Github/music-drawer/recordings/test.wav")
    let fileName = "test.wav"
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var audioInputAvailable = true
    
    @IBOutlet weak var playButton: NSButton!
    
    @IBOutlet weak var recordButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.title="Music Drawer"
        setupRecorder()
        /*
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue,
            AVEncoderBitRateKey : 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ] as [String : Any]
        try! audioRecorder = AVAudioRecorder(url: recorderFilePath, settings: recordSettings)
        audioRecorder?.delegate = NSApplication.shared().delegate as? AVAudioRecorderDelegate
        
        //prepare to record
        audioRecorder?.prepareToRecord()
 */

        
    }
    
    func getFileURL() -> NSURL {
        
        let filePath = NSURL.fileURL(withPath: "/Users/lucyzhang/Github/music-drawer/recordings/test.wav")
        
        return filePath as NSURL
    }
    
    
    func setupRecorder() {
        
        //set the settings for recorder
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ] as [String : Any]
        
        var error: NSError?

        
        try? audioRecorder = AVAudioRecorder(url: getFileURL() as URL, settings: recordSettings)
        
        if let err = error {
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            audioRecorder.delegate =  self//NSApplication.shared().delegate as? AVAudioRecorderDelegate
           audioRecorder.prepareToRecord()
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        
        try? audioPlayer = AVAudioPlayer(contentsOf: getFileURL() as URL)
        //audioPlayer = AVAudioPlayer(contentsOfURL: typeFileURL, error: &error)
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self//NSApplication.shared().delegate
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        }
    }
    
   
    @IBAction func playSound(_ sender: NSButton) {
        if (sender.title == "Play"){
            recordButton.isEnabled = false
            sender.title = "Stop"
            preparePlayer()
            audioPlayer.play()
        } else {
            audioPlayer.stop()
            sender.title = "Play"
        }
    }
    
    
    @IBAction func record(_ sender: NSButton) {
        if (sender.title == "Record"){
            audioRecorder.record()
            sender.title = "Stop"
            playButton.isEnabled = false
        } else {
            audioRecorder.stop()
            sender.title = "Record"
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    playButton.isEnabled = true
    recordButton.title = "Record"
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder!, error: Error!) {
        print("Error while recording audio \(error.localizedDescription)")
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.title = "Play"
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer!, error: Error!) {
        print("Error while playing audio \(error.localizedDescription)")
    }
    
    
}

