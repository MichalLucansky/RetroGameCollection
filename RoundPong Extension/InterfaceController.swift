//
//  InterfaceController.swift
//  RoundPong Extension
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import WatchKit
import Foundation
import UIKit

class InterfaceController: WKInterfaceController,WKCrownDelegate {
    static var moveDirection = String()
    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    @IBAction func ggg(_ sender: WKTapGestureRecognizer) {
        
        
        pushController(withName: "FirstController", context: nil)
        GameScene.gameStatus = true
    }
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        // Configure interface objects here.
        if let scene = GameScene(fileNamed: "GameScene") {
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 20
        }
        
    }
    
    
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        
        if(GameScene.gameStatus){
            if rotationalDelta > 0 {
                InterfaceController.moveDirection = "UP"
                GameScene.angle += 0.08
            }else if rotationalDelta < 0{
                InterfaceController.moveDirection = "DOWN"
                GameScene.angle -= 0.08
            }
            
        }
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        InterfaceController.moveDirection = "STOP"
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        crownSequencer.delegate = self
        crownSequencer.focus()
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
}
