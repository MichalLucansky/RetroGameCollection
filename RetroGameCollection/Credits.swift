//
//  Credits.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit


class Credits : SKScene{
    
    private var back = SKLabelNode()
    private var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        // BG music
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "Prologue", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        back = childNode(withName: "Back") as! SKLabelNode
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if let possitionName = atPoint(location).name{
                
                switch possitionName {
                    
                case "Back":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.0)))
                            
                        }
                        
                        
                    }
                default:
                    break
                    
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

