//
//  NextLvlClass.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit


class NextLvlClass: SKScene{
    
    
    private var nextLvlLabel = SKLabelNode()
    private var backToMenu = SKLabelNode()
    private var gameId = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        
        
        
        nextLvlLabel = self.childNode(withName: "NextLvlLabel") as! SKLabelNode
        backToMenu = self.childNode(withName: "BackToMenu") as! SKLabelNode
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            
            
            if let touchName = atPoint(location).name{
                
                
                
                
                switch touchName {
                    
                case "NextLvlLabel":
                    let id = gameId.integer(forKey: "ID")
                    if id == 1{
                        if let view = self.view {
                            
                            
                            if let scene = BlockBreaker(fileNamed: "BlockBreakerScene") {
                                
                                scene.scaleMode = .aspectFill
                                
                                // Present the scene
                                view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            }
                            
                            
                        }
                    }else if id == 2{
                        
                        if let view = self.view {
                            
                            
                            if let scene = SpaceInvadersClass(fileNamed: "SpaceInvadersScene") {
                                
                                scene.scaleMode = .aspectFill
                                
                                // Present the scene
                                view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                            }
                            
                            
                        }
                        
                        
                        
                    }
                case "BackToMenu" :
                    if let view = self.view {
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            scene.scaleMode = .aspectFill
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

