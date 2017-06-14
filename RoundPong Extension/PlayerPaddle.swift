//
//  PlayerPaddle.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerPaddle: SKSpriteNode {
    
    private let nodeColor = UIColor.white
    
    
    private let playerCategoryMask : UInt32 = 0x1 << 1
    private let playerCollisionMask : UInt32 = 0x1 << 2
    private let playerContactMask : UInt32 = 0x1 << 2
    
    
    
    func playerNode(path: UIBezierPath) -> SKShapeNode{
        
        
        let player = SKShapeNode()
        
        
        player.path = path.cgPath
        player.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
        player.physicsBody?.usesPreciseCollisionDetection = false
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 1
        player.name = "player"
        player.strokeColor = UIColor.red
        player.lineWidth = 5
        
        
        player.physicsBody?.isDynamic = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = playerCategoryMask
        player.physicsBody?.contactTestBitMask = playerContactMask
        player.physicsBody?.collisionBitMask = playerCollisionMask
        player.zPosition = 3
        
        
        return player
        
    }
    
    
    func calculatePosition (playerNode: SKShapeNode, radius: CGFloat, angle: CGFloat) {
        
        var position = CGPoint()
        
        position.x = (radius) * cos(angle)
        position.y =  (radius) * sin(angle)
        playerNode.position = position
        playerNode.zRotation = angle
        
        
    }
    
    
    
    
    
    
}
