//
//  Enemy.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    
    
    func moveEnemy(ballPosition: SKSpriteNode, enemy: SKSpriteNode, duration: Double) {
        
        
        
        
        
        enemy.run(SKAction.moveTo(x: ballPosition.position.x, duration: duration
            
        ))
        
        
    }
    
    
    
    
    
}
