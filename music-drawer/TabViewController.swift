//
//  TabViewController.swift
//  music-drawer
//
//  Created by Lucy Zhang on 1/14/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import Cocoa

class TabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func switchToVisual(){
        self.selectedTabViewItemIndex = 1
    }
    
}
