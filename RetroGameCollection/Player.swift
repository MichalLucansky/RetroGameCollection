//
//  Player.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit




class Player :SKSpriteNode{
    
    
    
    func move (touchLocation : CGPoint){
        let minX : CGFloat = -260, maxX: CGFloat = 260
        
        position.x = touchLocation.x
        if position.x > maxX{
            position.x = maxX
        }
        if position.x < minX{
            position.x = minX
        }
        
        
    }
    
    func shot(playerPositionX: SKSpriteNode)-> SKSpriteNode{
        
        
        let categoryMask : UInt32 = 0x1 << 2
        let collisionMask : UInt32 = 0x1 << 1
        let contaktMask : UInt32 = 0x1 << 0
        let bullet = SKSpriteNode()
        let position = playerPositionX.position.x
        
        
        bullet.size.height = CGFloat(9)
        bullet.size.width = CGFloat(6)
        bullet.position.x = position
        bullet.position.y = CGFloat(-570)
        bullet.anchorPoint = CGPoint(x: 0.5, y : 0.5)
        bullet.name = "Bullet"
        bullet.color = UIColor.red
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 6, height: 9))
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = categoryMask
        bullet.physicsBody?.collisionBitMask = collisionMask
        bullet.physicsBody?.contactTestBitMask = contaktMask
        
        
        bullet.run(SKAction.moveTo(y: 600, duration: 2))
        
        
        
        
        
        return bullet
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

