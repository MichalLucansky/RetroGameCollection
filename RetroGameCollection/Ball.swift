//
//  Ball.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit


class Ball: SKSpriteNode{
    
    
    
    
    func ballMove (ball:SKSpriteNode, speedX: CGFloat, speedY: CGFloat){
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: speedX, dy: speedY))
        
        
        
    }
    
    
    
    
    
    
}
