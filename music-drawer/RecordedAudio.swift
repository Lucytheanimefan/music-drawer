//
//  RecordedAudio.swift
//  music-drawer
//
//  Created by Lucy Zhang on 4/14/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

/**
 Data model for recorded audio; stores file URL and file title for recorded audio file
 **fileURL** Stores URL pointing to audio file as NSURL
 
 **fileTitle** Stores title of audio file as String
 */
class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    // Full member initializer for Recorded Audio
    init(fileURL filePathURL: NSURL, fileTitle title: String){
        self.filePathURL = filePathURL
        self.title = title
    }
}
