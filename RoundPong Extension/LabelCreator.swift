//
//  LabelCreator.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class LabelCreator {
    
    private var text: String
    private var position: CGPoint
    private var fontSize: CGFloat
    private var name: String
    
    init(text:String, position:CGPoint, fontSize: CGFloat, name: String) {
        self.text = text
        self.position = position
        self.fontSize = fontSize
        self.name = name
    }
    
    
    func createLabel() -> SKLabelNode {
        
        let label = SKLabelNode()
        
        label.fontColor = UIColor.green
        label.fontSize = self.fontSize
        label.name = self.name
        label.position = self.position
        label.text = self.text
        return label
    }
    
    
    
}
