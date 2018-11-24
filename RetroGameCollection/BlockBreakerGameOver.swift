//
//  BlockBreakerGameOver.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class BlockBreakerGameOver: SKScene {
    
    private  var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    private var highScore = UserDefaults.standard
    private var highScoreLabel = SKLabelNode()
    private var playAgainLabel = SKLabelNode()
    private var backToMenu = SKLabelNode()
    private var lvlStatus = BlockBreaker.nextLvlInit
    private var actualScore = Int()
    private var gameId = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "08 Ascending", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        AskForRatingManager.instance.showReview()
        let id = gameId.integer(forKey: "ID")
        
        if id == 1{
            actualScore = highScore.integer(forKey: "highScore")
            
        }else if id == 2{
            actualScore = highScore.integer(forKey: "SpaceInvaders")
        }else if id == 3{
            
            actualScore = highScore.integer(forKey: "Snake")
        }
        
        highScoreLabel = self.childNode(withName: "highScore") as! SKLabelNode
        playAgainLabel = self.childNode(withName: "PlayAgainLabel") as! SKLabelNode
        backToMenu = self.childNode(withName: "BackToMenu") as! SKLabelNode
        highScoreLabel.text = "\(actualScore)"
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let id = gameId.integer(forKey: "ID")
        
        for touch in touches{
            let location = touch.location(in: self)
            if let touchName = atPoint(location).name{
                switch touchName {
                    
                case "PlayAgainLabel":
                    
                    if id == 1 {
                        BlockBreaker.nextLvlInit = false
                        if let view = self.view {
                            
                            // Load the SKScene from 'GameScene.sks'
                            if let scene = BlockBreaker(fileNamed: "BlockBreakerScene") {
                                // Set the scale mode to scale to fit the window
                                scene.scaleMode = .aspectFit
                                
                                // Present the scene
                                view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))                        }
                        }
                    } else if id == 2{
                        SpaceInvadersClass.lvl = 1
                        if let view = self.view {
                            
                            // Load the SKScene from 'GameScene.sks'
                            if let scene = SpaceInvadersClass(fileNamed: "SpaceInvadersScene") {
                                // Set the scale mode to scale to fit the window
                                scene.scaleMode = .aspectFit
                                
                                // Present the scene
                                view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            }
                        }
                        
                    } else {
                        if let view = self.view {
                            
                            // Load the SKScene from 'GameScene.sks'
                            if let scene = GameScene(fileNamed: "GameScene") {
                                // Set the scale mode to scale to fit the window
                                scene.scaleMode = .aspectFit
                                
                                // Present the scene
                                view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            }
                        }
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

