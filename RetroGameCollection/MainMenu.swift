//
//  MainMenu.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene{
    private var backgroundMusic: SKAudioNode!
    private var pong = SKLabelNode()
    private var blockBreaker = SKLabelNode()
    private var spaceInvaders = SKLabelNode()
    private var snake = SKLabelNode()
    private var ticTacToe = SKLabelNode()
    private var soundStatus = UserDefaults.standard
    
    
    override func didMove(to view: SKView) {
        initialization()
        
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "10 Arpanauts", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
                
                
            }
        }
        
    }
    
    
    private func initialization (){
        
        pong.childNode(withName: "Pong")
        blockBreaker.childNode(withName: "BlockBreaker")
        spaceInvaders.childNode(withName: "SpaceInvaders")
        snake.childNode(withName: "Snake")
        ticTacToe.childNode(withName: "TicTacToe")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if let touchName = atPoint(location).name{
                
                
                
                
                switch touchName {
                    
                case "Pong":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = PongMultiSingleSel(fileNamed: "PongMultiSingleSel") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFit
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            
                        }
                        
                        
                    }
                case "BlockBreaker" :
                    if let view = self.view {
                        if let scene = BlockBreaker(fileNamed: "BlockBreakerScene") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                case "SpaceInvaders" :
                    if let view = self.view {
                        if let scene = SpaceInvadersClass(fileNamed: "SpaceInvadersScene") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                case "Snake" :
                    if let view = self.view {
                        if let scene = GameScene(fileNamed: "GameScene") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                case "Settings" :
                    if let view = self.view {
                        if let scene = Settings(fileNamed: "Settings") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                    
                case "Credits" :
                    if let view = self.view {
                        if let scene = Credits(fileNamed: "Credits") {
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

