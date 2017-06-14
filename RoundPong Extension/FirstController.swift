import UIKit
import WatchKit

class FirstController: WKInterfaceController {
    
    
    
    @IBAction func gameStart() {
        
        pushController(withName: "GameScene", context: nil)
        
        
    }
    
}
//
//  FirstController.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import Foundation
