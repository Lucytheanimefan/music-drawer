//
//  Constants.swift
//  music-drawer
//
//  Created by Lucy Zhang on 1/14/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import Foundation
import Cocoa

enum AppStoryboard : String {
    case Main = "Main"
    
    var instance : NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: self.rawValue), bundle: Bundle.main)
    }
}


struct Constants{
    static let FRAME_COUNT = 64
}
