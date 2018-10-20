//
//  WinningScene.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class WinningSceneClass: SKScene{
    private var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    private var playAgainLabel = SKLabelNode()
    private var backToMenuLabel = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        
        // BG music
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "Prologue", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        playAgainLabel = self.childNode(withName: "PlayAgainLabel") as! SKLabelNode
        backToMenuLabel = self.childNode(withName: "BackToMenu") as! SKLabelNode
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if let touchName = atPoint(location).name{
                
                
                
                
                switch touchName {
                    
                case "PlayAgainLabel":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = Pong(fileNamed: "PongScene") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFit
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))                    }
                        
                        
                    }
                case "BackToMenu" :
                    if let view = self.view {
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                default:
                    break
                }
                
                
                
                
                
                
            }
            
        }
        
        
    }
    
    
    
    
}
