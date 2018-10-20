//
//  BlockBreakerClass.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class BlockBreaker: SKScene, SKPhysicsContactDelegate{
    
    private var backgroundMusic: SKAudioNode!
    private var soundStatus = UserDefaults.standard
    private var highScore = UserDefaults.standard
    private var playerPadle = Player()
    private var ball = SKSpriteNode()
    private var bricks = [SKSpriteNode]()
    private var score = Int()
    private var obstacle = Utilities()
    private var scoreLabel = SKLabelNode()
    private var menuLabel = SKLabelNode()
    private var pauseLabel = SKLabelNode()
    private var unpauseLabel = SKLabelNode()
    private var obstacleNumber = 0
    static var nextLvlInit = false
    private var randomNumber = GameScene()
    static var speedX = CGFloat(15)
    static var speedY = CGFloat(-15)
    private var padleMoveArray = [CGFloat]()
    private var actualDirection = CGFloat()
    private var direction = String()
    private var brickCount = 0
    static var scoreToPass = Int()
    private var gameId = UserDefaults.standard
    private let textures: [Int: String] = [0: "texture1", 1: "texture2",2: "texture3",3: "texture4",4: "texture5",5: "texture6",6: "texture8",7: "texture9",8: "texture10"]
    
    
    override func didMove(to view: SKView) {
        
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "03 Chibi Ninja", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
            
        }
        
        
        if highScore.value(forKey: "highScore") == nil {
            highScore.set(0, forKey: "highScore")
        }
        
        
        
        if BlockBreaker.nextLvlInit{
            
            score = BlockBreaker.scoreToPass
            
            BlockBreaker.speedX += 2
            BlockBreaker.speedY += -1
            
        }else{
            BlockBreaker.speedX = BlockBreaker.speedX
            BlockBreaker.speedY = BlockBreaker.speedY
        }
        
        
        initialization()
        
        ball.physicsBody?.applyImpulse(CGVector(dx: BlockBreaker.speedX, dy: BlockBreaker.speedY))
        
        if BlockBreaker.nextLvlInit {
            var i = 0
            let numberOfObstacles = Int(randomNumber.randomNumberGenerator(start: 1, end: 5))
            
            while i != numberOfObstacles{
                BlockBreaker.nextLvlInit = true
                self.addChild(obstacle.staticSpriteGenerator(position: CGPoint(x: randomNumber.randomNumberGenerator(start: -360, end: 360), y: 0), width:  randomNumber.randomNumberGenerator(start: 60, end: 110)))
                i += 1
            }
            
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
    
    private func addObstacle(){
        
        
        self.addChild(obstacle.randomSpriteGenerator(position: CGPoint(x: -400, y: 150), width:  randomNumber.randomNumberGenerator(start: 120, end: 300), height: 40))
        obstacleNumber += 1
        
    }
    
    
    
    
    private func initialization(){

        scoreLabel.text = "SCORE: \(score)"
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
        let texture = SKTexture(imageNamed: textures[Int(randomNumber.randomNumberGenerator(start: 0, end: 8))] ?? "texture1")
        if let children = scene?.children {
            for child in children {
                if child.name == "brick"{
                    
                    let brick = child as! SKSpriteNode
                    brick.texture = texture
                }
            }
        }

        playerPadle = childNode(withName: "Player") as! Player
        playerPadle.texture = SKTexture(imageNamed: "texture7")
        ball = childNode(withName: "ball") as! SKSpriteNode
        scoreLabel = childNode(withName: "Score") as! SKLabelNode
        menuLabel = childNode(withName: "EndGame") as! SKLabelNode
        pauseLabel = childNode(withName: "Pause") as! SKLabelNode
        unpauseLabel = childNode(withName: "UNPAUSE") as! SKLabelNode
        unpauseLabel.isHidden = true
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            playerPadle.move(touchLocation: location)
            
            if let locationName = atPoint(location).name{
                switch locationName{
                case "Pause":
                    self.physicsWorld.speed = 0
                    pauseLabel.isHidden = true
                    unpauseLabel.isHidden = false
                case "EndGame":
                    
                    gameId.set(1, forKey: "ID")
                    
                    
                    if let view = self.view {
                        if let scene = BlockBreakerGameOver(fileNamed: "BlockBreakerGameOver") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                case "UNPAUSE":
                    self.physicsWorld.speed = 1
                    pauseLabel.isHidden = false
                    unpauseLabel.isHidden = true
                default:
                    break
                }
                
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            playerPadle.move(touchLocation: location)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if bodyAName == "ball" && bodyBName == "brick" || bodyAName == "brick" && bodyBName! == "ball"{
            if bodyAName == "brick"{
                
                contact.bodyA.node?.removeFromParent()
                
                brickCount += 1
                score += 10
                scoreLabel.text = "SCORE: \(score)"
                
                
            }else if  bodyBName == "brick"{
                
                contact.bodyB.node?.removeFromParent()
                brickCount += 1
                score += 10
                scoreLabel.text = "SCORE: \(score)"
                
            }
        }
        
        if bodyAName == "ball" && bodyBName == "Player" || bodyAName == "Player" && bodyBName == "ball"{
            
            let node = childNode(withName: "ball")
            
            
            switch direction {
            case "LEFT":
                node?.physicsBody?.velocity = CGVector(dx: -500, dy: 500)
                node?.physicsBody?.angularDamping = 0.2
                
            case "RIGHT":
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
        
        
        
        
        
        
        
        scoreLabel.text = "SCORE: \(score)"
        if BlockBreaker.nextLvlInit && obstacleNumber == 0{
            
            addObstacle()
            
            
        }
        
        if BlockBreaker.nextLvlInit{
            
            if   (childNode(withName: "Obstacle")?.position.x)! > self.frame.width / 2 {
                obstacleNumber -= 1
                childNode(withName: "Obstacle")?.removeFromParent()
                
                
                
            }
        }
        
        
        
        
        
        
        
        
        if ball.position.y < playerPadle.position.y {
            gameId.set(1, forKey: "ID")
            BlockBreaker.scoreToPass = score
            if highScore.integer(forKey: "highScore") < score{
                highScore.set(score, forKey: "highScore")
                
            }
            
            BlockBreaker.nextLvlInit = false
            if let view = self.view {
                // Load the SKScene from 'GameOverScene'
                if let scene = BlockBreakerGameOver(fileNamed: "BlockBreakerGameOver") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                    
                    
                }
                
            }
            
            
        }
        
        
        
        if brickCount == 9{
            gameId.set(1, forKey: "ID")
            BlockBreaker.scoreToPass = score
            if highScore.integer(forKey: "highScore") < score{
                highScore.set(score, forKey: "highScore")
                
            }
            
            BlockBreaker.nextLvlInit = true
            if let view = self.view {
                // Load the SKScene from 'GameOverScene'
                if let scene = NextLvlClass(fileNamed: "NextLvlScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
}

