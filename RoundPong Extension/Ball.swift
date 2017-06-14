//
//  Ball.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    
    private let nodeColor = UIColor.green
    
    
    private let ballCategoryMask : UInt32 = 0x1 << 2
    private let ballCollisionMask : UInt32 = 0x1 << 1
    private let ballContactMask : UInt32 = 0x1 << 1
    
    
    func ball() -> SKSpriteNode{
        
        
        let ball = SKSpriteNode()
        
        ball.size = CGSize(width: 10, height: 10)
        ball.name = "ball"
        ball.position = CGPoint(x: 0, y: 0)
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.color = nodeColor
        
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.mass = 0.1
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.categoryBitMask = ballCategoryMask
        ball.physicsBody?.collisionBitMask = ballCollisionMask
        ball.physicsBody?.contactTestBitMask = ballContactMask
        ball.zPosition = 1
        return ball
        
        
        
    }
    
    
}
