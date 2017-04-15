//
//  AppDelegate.swift
//  music-drawer
//
//  Created by Lucy Zhang on 4/11/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,AVAudioRecorderDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Done recording: file path")
        print(recorder.url.absoluteURL)
        print(recorder.debugDescription)
    }

}

