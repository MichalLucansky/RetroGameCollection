//
//  GameScene.swift
//  RoundPong Extension
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit
import WatchKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball = Ball()
    private var player = PlayerPaddle()
    private var playerPosition = CGPoint()
    private var path = UIBezierPath()
    private var playerPath = UIBezierPath()
    private var circle = CircleBorder()
    static var angle : CGFloat = 0.1
    static var gameStatus = true
    private  var gameOver1 = LabelCreator(text: "", position: CGPoint(x: 0, y: 0), fontSize: 32, name: "GameOverLabel")
    private var tap = LabelCreator(text: "Tap Twice to Continue...", position: CGPoint(x: 0, y: -90), fontSize: 23, name: "TapLabel")
    private var gameOverLabel = SKLabelNode()
    private var tapLab = SKLabelNode()
    private var score = 0
    private var playerNode = SKShapeNode()
    private var ballNode = SKSpriteNode()
    private var direction = String()
    
    
    override func sceneDidLoad() {
        
        gameOverLabel = gameOver1.createLabel()
        tapLab = tap.createLabel()
        
        
        self.scene?.isPaused = true
        GameScene.gameStatus = true
        gameInit()
        self.physicsWorld.contactDelegate = self
        
        
        
    }

    
    private func gameInit(){
        
        if GameScene.gameStatus{
            gameOverLabel.removeFromParent()
            tapLab.removeFromParent()
        }
        
        
        
        // Y position of the player paddle and radius of the circular border
        
        let positionYRadius = CGFloat((self.frame.height - 90) / 2)
        
        
        
        
        // creating Player Node
        playerPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: positionYRadius - 5  , startAngle: CGFloat(0.5) , endAngle: CGFloat(1), clockwise: true)
        playerNode = player.playerNode(path: playerPath )
        addChild(playerNode)
        
        
        
        
        // Creating path for the moving radius circle
        
        path =  UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: positionYRadius, startAngle: .pi * -2, endAngle: CGFloat(0), clockwise: true)
        addChild(circle.createCircle(path: path))
        
        // Add ball with move impulse
        
        ballNode = ball.ball()
        addChild(ballNode)
        ballNode.physicsBody?.applyImpulse(CGVector(dx: 12, dy: 12))
        
    }
    
    
    private func gameOver(){
        
        GameScene.angle = 0.1
        GameScene.gameStatus = false
        gameOverLabel.text = "Your score is \(score) !"
        addChild(gameOverLabel)
        addChild(tapLab)
        self.scene?.isPaused = true
        playerNode.removeFromParent()
        ballNode.removeFromParent()
        childNode(withName: "moveCircleRadius")?.removeFromParent()
        score = 0
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let node1 = contact.bodyA
        let node2 = contact.bodyB
        let node = childNode(withName: "ball")
        direction = InterfaceController.moveDirection
        if node1.node?.name == "ball" && node2.node?.name == "player" || node1.node?.name == "player" && node2.node?.name == "ball"{
            
            
           
            
            switch  direction{
            case "UP":
                
                if ((node?.position.x)! > CGFloat(0) && (node?.position.y)! > CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: -2, dy: -5))
                }else if((node?.position.x)! > CGFloat(0) && (node?.position.y)! < CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: 5))
                }else if ((node?.position.x)! < CGFloat(0) && (node?.position.y)! > CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: -5))
                }else if((node?.position.x)! < CGFloat(0) && (node?.position.y)! < CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: -5))
                }
               
                
            case "DOWN":

                if ((node?.position.x)! > CGFloat(0) && (node?.position.y)! > CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: -2, dy: -5))
                }else if((node?.position.x)! > CGFloat(0) && (node?.position.y)! < CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: 5))
                }else if ((node?.position.x)! < CGFloat(0) && (node?.position.y)! > CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: -5))
                }else if((node?.position.x)! < CGFloat(0) && (node?.position.y)! < CGFloat(0)){
                    node?.physicsBody?.applyImpulse(CGVector(dx: 2, dy: -5))
                }
                
            default:
                break
            }
            
            
            score += 1
            
            
        }
        if node1.node?.name == "ball" && node2.node?.name == "moveCircleRadius" || node1.node?.name == "moveCircleRadius" && node2.node?.name == "ball"{
            
            
            ballNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
            GameScene.gameStatus = false
            
            
        }
     

        
        
        
    }
    
    
    
    private func moveControll(){
        let ball = ballNode
        
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        let speed = xSpeed + ySpeed
                if(speed > 250){
            
            ball.physicsBody?.linearDamping = 2
        }else{
            
        ball.physicsBody?.linearDamping = 0
        }
        if(speed < 190){
            if ((ball.position.x) > CGFloat(0) && (ball.position.y) > CGFloat(0)){
                ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            }else if((ball.position.x) > CGFloat(0) && (ball.position.y) < CGFloat(0)){
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }else if ((ball.position.x) < CGFloat(0) && (ball.position.y) > CGFloat(0)){
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: -10))
            }else if((ball.position.x) < CGFloat(0) && (ball.position.y) < CGFloat(0)){
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }
        }
        
    
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
      moveControll()

        
        if GameScene.gameStatus == true{
            
            player.calculatePosition(playerNode: playerNode, radius: 1, angle: GameScene.angle)
            
        }
            
        else if GameScene.gameStatus == false{
            gameOver()
            
        }
    }
    
    
    
}
