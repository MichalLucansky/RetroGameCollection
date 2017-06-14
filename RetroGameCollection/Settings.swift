//
//  Settings.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit


class Settings: SKScene{
    private var backgroundMusic: SKAudioNode?
    private var on = SKLabelNode()
    private var off = SKLabelNode()
    private var resset = SKLabelNode()
    private var backLabel = SKLabelNode()
    private var onOffLabelStatus = (UserDefaults.standard, UserDefaults.standard)
    private var soundStatus = UserDefaults.standard
    private var scoreReset = UserDefaults.standard
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        if onOffLabelStatus.0.value(forKey: "onLabelStatus") == nil{
            onOffLabelStatus.0.set(false, forKey: "onLabelStatus")
            
        }
        if  onOffLabelStatus.1.value(forKey: "offLabelStatus") == nil{
            onOffLabelStatus.1.set(true, forKey: "offLabelStatus")
        }
        
        if soundStatus.value(forKey: "SOUNDSTATUS") == nil{
            soundStatus.set(true, forKey: "SOUNDSTATUS")
            
        }
        
        on = childNode(withName: "ON") as! SKLabelNode
        off = childNode(withName: "OFF") as! SKLabelNode
        resset = childNode(withName: "RESETSCORE") as! SKLabelNode
        backLabel = childNode(withName: "Back") as! SKLabelNode
        
        
        
        childNode(withName: "ON")?.isHidden = onOffLabelStatus.0.bool(forKey: "onLabelStatus")
        childNode(withName: "OFF")?.isHidden = onOffLabelStatus.1.bool(forKey: "offLabelStatus")
        
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "Prologue", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                
                addChild(backgroundMusic!)
                
                
            }
        }
        
        
    }
    
    
    private func soundsOn(){
        
        
        soundStatus.set(true, forKey: "SOUNDSTATUS")
        
        onOffLabelStatus.0.set(false, forKey: "onLabelStatus")
        onOffLabelStatus.1.set(true, forKey: "offLabelStatus")
        
        on.isHidden = onOffLabelStatus.0.bool(forKey: "onLabelStatus")
        off.isHidden = onOffLabelStatus.1.bool(forKey: "offLabelStatus")
        
        
        
        
        
    }
    
    private func soundsOff(){
        
        
        soundStatus.set(false, forKey: "SOUNDSTATUS")
        
        onOffLabelStatus.0.set(true, forKey: "onLabelStatus")
        onOffLabelStatus.1.set(false, forKey: "offLabelStatus")
        
        on.isHidden = onOffLabelStatus.0.bool(forKey: "onLabelStatus")
        off.isHidden = onOffLabelStatus.1.bool(forKey: "offLabelStatus")
        
        
        
        
        
    }
    
    
    private func resetScore(){
        
        scoreReset.set(0, forKey: "SpaceInvaders")
        scoreReset.set(0, forKey: "Snake")
        scoreReset.set(0, forKey: "highScore")
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if let possitionName = atPoint(location).name{
                
                switch possitionName {
                case "ON" :
                    
                    self.soundsOff()
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = Settings(fileNamed: "Settings") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
                            view.presentScene(scene)
                            
                        }
                        
                        
                    }
                    
                case "OFF" :
                    
                    self.soundsOn()
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = Settings(fileNamed: "Settings") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
                            view.presentScene(scene)
                            
                        }
                        
                        
                    }
                    
                    
                case "Back" :
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.0)))
                            
                        }
                        
                        
                    }
                case "RESETSCORE":
                    self.resetScore()
                    
                default:
                    break
                }
                
                
                
                
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        on.isHidden = onOffLabelStatus.0.bool(forKey: "onLabelStatus")
        off.isHidden = onOffLabelStatus.1.bool(forKey: "offLabelStatus")
        
    }
    
    
    
}
