//
//  EndGame.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit


class EndGameLost: SKScene{
    private var mainMenu = SKLabelNode()
    private var playAgain = SKLabelNode()
    private var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    
    
    
    override func didMove(to view: SKView) {
        mainMenu = childNode(withName: "MainMenu") as! SKLabelNode
        playAgain = childNode(withName: "PlayAgainLabel") as! SKLabelNode
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "08 Ascending", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if let touchName = atPoint(location).name{
                
                switch touchName {
                case "MainMenu":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            
                        }
                    }
                    
                case "PlayAgainLabel":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = Pong(fileNamed: "PongScene") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
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

