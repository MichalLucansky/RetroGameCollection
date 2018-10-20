//
//  Pong.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit
import GameplayKit

class Pong: SKScene, SKPhysicsContactDelegate {
    private var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    private var player = Player()
    private var secondPlayer = Enemy()
    private var enemy = Enemy()
    private var ball = Ball()
    private var gamePauseEnd = SKLabelNode()
    private var endGame = SKLabelNode()
    private var pause = SKLabelNode()
    private var enemyScoreLabel = SKLabelNode()
    private var playerScoreLabel = SKLabelNode()
    private var enemyScore = 0
    private var playerScore = 0
    private var pauseStatus = false
    private var status  = PongMultiSingleSel.statusInit
    private var selectedNodes:[UITouch:SKSpriteNode] = [:]
    private var speedX = CGFloat(-15)
    private var speedY = CGFloat(15)
    private var enemyMovingSpeed = 0.30
    private var padleMoveArray = [CGFloat]()
    private var actualDirection = CGFloat()
    private var direction = String()

    
    override func didMove(to view: SKView) {
        
        
        
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "02 HHavok-main", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
                
            }
        }
        
        initialization()
        ball.ballMove(ball: ball, speedX: speedX, speedY: speedY)
    }
    
    
    
    // initialization of all sprites
    private func initialization(){
        self.physicsWorld.contactDelegate = self
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        
        player = childNode(withName: "Player") as! Player
        enemy = childNode(withName: "Enemy") as! Enemy
        ball = childNode(withName: "Ball") as! Ball
        
        enemyScoreLabel = childNode(withName: "EnemyScore") as! SKLabelNode
        enemyScoreLabel.text = ("UI Player : \(enemyScore)")
        playerScoreLabel = childNode(withName: "PlayerScoreLabel") as! SKLabelNode
        playerScoreLabel.text = ("Player : \(playerScore)")
        endGame = childNode(withName: "ENDGAME") as! SKLabelNode
        pause = childNode(withName: "Pause") as! SKLabelNode
        gamePauseEnd = childNode(withName: "GAMEISPAUSED") as! SKLabelNode
        gamePauseEnd.isHidden = true
        
        
        if status == false{
            multiPlayer()
        }
        
        
        
        
    }
    private func padleMoveDirection(){
        
        if padleMoveArray.count == 2{
            let temp = padleMoveArray[0]
            
            let dir =  padleMoveArray[1]
            
            actualDirection = dir - temp
            
            if actualDirection < 0 {
                direction = "LEFT"
                
            }else if actualDirection > 0{
                direction = "RIGHT"
                
            }else if actualDirection == 0{
                direction = "STOP"
                
                
            }
            padleMoveArray.removeFirst()
            
        }
    }

    
    private func ballSpeedIncreaser(pointCount: Int, playerWhoWon: SKSpriteNode){
        print(pointCount)
        switch pointCount {
        case 1...2:
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -15, dy: -15))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
                
            }
        case 3...5:
            enemyMovingSpeed = 0.26
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -17, dy: -17))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 17, dy: 17))
                
                
            }
        case 6...8:
            enemyMovingSpeed = 0.229
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -19, dy: -19))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 19, dy: 19))
                
                
            }
        case 9...10:
            enemyMovingSpeed = 0.22
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -21, dy: -21))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 21, dy: 21))
                
            }
        case 11...15:
            enemyMovingSpeed = 0.20
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -23, dy: -23))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 23, dy: 23))
                
            }
        case 16...19:
            enemyMovingSpeed = 0.176
            if playerWhoWon == player{
                ball.physicsBody?.applyImpulse(CGVector(dx: -25, dy: -25))
            }else if playerWhoWon == enemy{
                ball.physicsBody?.applyImpulse(CGVector(dx: 25, dy: 25))
                
            }
            
        default:
            break
        }
        
        
        
        
    }
    
    
    private func multiPlayer(){
        
        enemyScoreLabel.position = CGPoint(x: 0, y: 630)
        enemyScoreLabel.text = ("Player One : \(enemyScore)")
        enemyScoreLabel.zRotation =  (.pi / 2) * -2
        playerScoreLabel.text = ("Player Two : \(playerScore)")
        
        
        
    }
    
    
    
    //
    private func checkPointStatus(playerWhoWon: SKSpriteNode){
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        ballSpeedIncreaser(pointCount: playerScore + enemyScore + 1, playerWhoWon: playerWhoWon)
        
        if playerWhoWon == player {
            playerScore += 1
            playerScoreLabel.text = ("Player : \(playerScore)")
            
            
        }
        if playerWhoWon == enemy {
            enemyScore += 1
            enemyScoreLabel.text = ("UI Player : \(enemyScore)")
            
        }
        
        
        
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            
            
            if let node = selectedNodes[touch] {
                node.position.x = location.x
                let minX : CGFloat = -260, maxX: CGFloat = 260
                
                position.x = node.position.x
                if position.x > maxX{
                    position.x = maxX
                }
                if position.x < minX{
                    position.x = minX
                }
            }
            
            
        }
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            
            
            if location.y > CGFloat(300){
                let node = childNode(withName: "Enemy")
                selectedNodes[touch] = node as! SKSpriteNode?
            }else if location.y < CGFloat(-300){
                
                let node = childNode(withName: "Player")
                selectedNodes[touch] = node as! SKSpriteNode?
                
                
            }
            
            if let touchName = atPoint(location).name{
                
                switch touchName {
                    
                case "ENDGAME":
                    if let view = self.view {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = EndGameLost(fileNamed: "EndGameLost") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFit
                            
                            // Present the scene
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                    }
                    
                case "Pause":
                    pauseStatus = true
                    pause.isHidden = true
                    gamePauseEnd.isHidden = false
                    
                    
                case "GAMEISPAUSED":
                    
                    
                    pauseStatus = false
                    pause.isHidden = false
                    gamePauseEnd.isHidden = true
                    
                    
                    
                    
                    
                default:
                    break
                    
                }
                
            }
            
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if selectedNodes[touch] != nil {
                selectedNodes[touch] = nil
            }
        }
    }
    
    func gamePause(){
        
        
        
        
        
        self.physicsWorld.speed = 0
        
        
        
    }
    func gameUnPause(){
        
        
        
        
        self.physicsWorld.speed = 1
        
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        let node = childNode(withName: "Ball")
        if bodyAName == "Ball" && bodyBName == "Player" || bodyAName == "Player" && bodyBName! == "Ball"{
            
            
            
            switch direction {
            case "LEFT":
                print("idem")
                node?.physicsBody?.velocity = CGVector(dx: -500, dy: 500)
                node?.physicsBody?.angularDamping = 0.2
                
            case "RIGHT":
                print("idem")
                node?.physicsBody?.velocity = CGVector(dx: 500, dy: 500)
                node?.physicsBody?.angularDamping = 0.2
                
                
            default:
                break
            }
            
            
                    }
    }
    
    override func update(_ currentTime: TimeInterval) {
        padleMoveArray.append((childNode(withName: "Player")?.position.x)!)
        
        padleMoveDirection()
        
        if status == false{
            multiPlayer()
        }
        
        if pauseStatus == true {
            gamePause()
            
        }else if pauseStatus == false{
            gameUnPause()
        }
        
        
        if status {
            
            enemy.moveEnemy(ballPosition: ball, enemy: enemy, duration: enemyMovingSpeed)
        }
        
        if ball.position.y > enemy.position.y{
            checkPointStatus(playerWhoWon: player)
            
        }
        
        if ball.position.y < player.position.y{
            checkPointStatus(playerWhoWon: enemy)
        }
        
        if enemyScore == 10{
            
            
            
            if let view = self.view {
                // Load the SKScene from 'GameOverScene'
                if let scene = EndGameLost(fileNamed: "EndGameLost") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                    
                    
                }
                
            }
        }
        
        if playerScore == 10{
            
            
            if let view = self.view {
                // Load the SKScene from 'WinningSceneClass'
                if let scene = WinningSceneClass(fileNamed: "WinningScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                    
                    
                }
                
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

