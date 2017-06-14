//
//  CircleBorder.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class CircleBorder: SKSpriteNode {
    
    private let borderCategoryMask : UInt32 = 0x1 << 1
    private let borderCollisionMask : UInt32 = 0x1 << 2
    private let borderContaktMask : UInt32 = 0x1 << 2
    
    func createCircle(path: UIBezierPath) -> SKShapeNode{
        
        
        let circleShape = SKShapeNode()
        
        
        circleShape.path = path.cgPath
        
        circleShape.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
        circleShape.physicsBody?.usesPreciseCollisionDetection = false
        circleShape.physicsBody?.friction = 0
        circleShape.physicsBody?.restitution = 1
        circleShape.name = "moveCircleRadius"
        circleShape.strokeColor = UIColor.blue
        circleShape.zPosition = 0
        circleShape.physicsBody?.isDynamic = false
        circleShape.physicsBody?.affectedByGravity = false
        circleShape.physicsBody?.categoryBitMask = borderCategoryMask
        circleShape.physicsBody?.contactTestBitMask = borderContaktMask
        circleShape.physicsBody?.collisionBitMask = borderCollisionMask
        
        
        return circleShape
        
    }
    
    
    
    
}
