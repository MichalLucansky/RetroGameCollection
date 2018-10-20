//
//  Utilities.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class Utilities: SKScene {
    
    
    
    func randomSpriteGenerator(position: CGPoint, width: CGFloat, height: CGFloat) -> SKSpriteNode{
        
        let obstacle = SKSpriteNode()
        obstacle.texture = SKTexture(imageNamed: "moss_Texture")
        obstacle.size.height = 40
        obstacle.size.width = width
        obstacle.position = position
        obstacle.name = "Obstacle"
        obstacle.color = UIColor.blue
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width , height: 40))
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        obstacle.run(SKAction.moveTo(x: 600, duration: 10))
        
        
        
        
        
        
        
        
        
        return obstacle
    }
    
    func staticSpriteGenerator(position: CGPoint, width : CGFloat) -> SKSpriteNode{
        
        let staticObstacle = SKSpriteNode()
        let texturee:SKTexture = SKTexture(imageNamed: "texture")
        staticObstacle.texture = texturee
        
        staticObstacle.size.height = 40
        staticObstacle.size.width = width
        staticObstacle.position = position
        staticObstacle.name = "staticObstacle"
        staticObstacle.color = UIColor.blue
        staticObstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width , height: 40))
        staticObstacle.physicsBody?.isDynamic = false
        staticObstacle.physicsBody?.affectedByGravity = false
        staticObstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        
        
        
        
        
        
        
        return staticObstacle
    }
    
    func randomNumberGenerator ()-> CGFloat{
        var randomNumber = CGFloat()
        
        
        randomNumber = CGFloat(arc4random_uniform(UInt32(300)))
        
        return randomNumber
        
    }
    
    
    
    
    func gamePause(){
        
        
        
        
        
        self.physicsWorld.speed = 0
        
        
        
    }
    func gameUnPause(){
        
        
        
        
        self.physicsWorld.speed = 1
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

