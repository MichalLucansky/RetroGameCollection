//
//  SpaceInvadersClass.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 13.6.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//

import SpriteKit

class SpaceInvadersClass: SKScene, SKPhysicsContactDelegate {
    
    // NOTE: Nodes in the scene
    
    private var backgroundMusic: SKAudioNode!
    private var shipLiveLabel = SKLabelNode()
    private var scoreLabel = SKLabelNode()
    private var bossHealthLabel = SKLabelNode()
    private var pauseLabel = SKLabelNode()
    private var unPauseLabel = SKLabelNode()
    private var life1 = SKSpriteNode()
    private var life2 = SKSpriteNode()
    private var life3 = SKSpriteNode()
    //NOTE: variables
    private var dynamicAsteroidCoun = 0
    private var bossHealth = 100
    private var invadersCount = 24
    private var shotCount = 1
    private var score = 0
    static var lifeCount = 3
    //NOTE: ship, shot
    private var ship = Player()
    private var shot = Player()
    // NOTE: asteroid vars
    static var shipLiveCount = [SKSpriteNode]()
    private var  asteroidPositionArray = [CGPoint(x: -180, y: -400), CGPoint(x: 0, y: -400), CGPoint(x: 180, y: -400)]
    // NOTE: data to pass or save
    private var soundStatus = UserDefaults.standard
    static var scoreToPass = Int()
    private var gameId = UserDefaults.standard
    private var spaceInvadersScore = UserDefaults.standard
    //NOTE: invader move controll settings
    private var timeOfLastMove : CFTimeInterval = 0.0
    private var timePerMove : CFTimeInterval = 0.8
    internal var descendInvaderSpeed = CGFloat()
    private var invaderSpeed = InvaderSpeed()
    private var invaderMovementDirection: InvaderMoveDirection = .right
    //NOTE: names
    private let shipFiredBullet = "shipFiredBullet"
    private let invaderFiredBullet = "invaderFiredBullet"
    private let bossFiredBullet = "bossFiredBullet"
    private let bulletSize = CGSize(width:8, height:16)
    //NOTE: LVL settings
    static var nextLvlSpaceInvaders = false
    static var lvl = 1
    static var lvlCount = 1
    // NOTE: Invader speed settings
    private struct InvaderSpeed{
        
        let speedOne = CGFloat(30)
        let speedTwo = CGFloat(60)
        let speedTree = CGFloat(75)
        
    }
    //Bullet types
    private enum BulletType{
        
        case shipFiredBullet
        case invaderFiredBullet
        case bossFiredBullet
        
    }
    // possible move directions
    private enum InvaderMoveDirection {
        case left
        case right
        case downRight
        case downLeft
        case none
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // BG music
        if soundStatus.bool(forKey: "SOUNDSTATUS"){
            if let musicURL = Bundle.main.url(forResource: "01 A Night Of Dizzy Spells", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        score = SpaceInvadersClass.scoreToPass // loading score from previous lvl
        
        //managing nodes view in scene
        
        createStarLayers()
        
        childNode(withName: "starfieldNode")?.zPosition = -2
        switch SpaceInvadersClass.lifeCount {
        case 1 :
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life1") as! SKSpriteNode)
            childNode(withName: "life2")?.isHidden = true
            childNode(withName: "life3")?.isHidden = true
        case 2 :
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life1") as! SKSpriteNode)
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life2") as! SKSpriteNode)
            childNode(withName: "life3")?.isHidden = true
        case 3 :
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life1") as! SKSpriteNode)
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life2") as! SKSpriteNode)
            SpaceInvadersClass.shipLiveCount.append(childNode(withName: "life3") as! SKSpriteNode)
        default:
            break
        }
        
        //setting invader speed, depending on lvl
        switch SpaceInvadersClass.lvl {
        case 1 :
            descendInvaderSpeed = invaderSpeed.speedOne
        case 2 :
            descendInvaderSpeed = invaderSpeed.speedTwo
        case 3 :
            descendInvaderSpeed = invaderSpeed.speedTree
        case 4 ://Boss level
            enumerateChildNodes(withName: "invaders"){
                node, stop in
                node.removeFromParent()
            }
            addChild(bossHealthLabel)
            bossHealthLabel.fontName = "lcd phone"
            bossHealthLabel.fontColor = UIColor(red: 0, green: 238, blue: 11, alpha: 1)
            bossHealthLabel.position = CGPoint(x: 0, y: 0)
            
            descendInvaderSpeed = invaderSpeed.speedTwo
            self.addChild(self.bossInvader(position: CGPoint(x: 0, y: 400)))
        case 5 :
            SpaceInvadersClass.lvl = 1
            descendInvaderSpeed = invaderSpeed.speedOne
            SpaceInvadersClass.nextLvlSpaceInvaders = true
        default:
            break
            
            
            
        }
        
        // creating asteroids if needed
        if SpaceInvadersClass.nextLvlSpaceInvaders{
            
            for i in 0..<3{
                addChild(asteroidCreator(position: asteroidPositionArray[i]))
            }
            
        }
        
        
        
        initialization()
        self.physicsWorld.contactDelegate = self
        
        
        
        
    }
    
    //NOTE: Boss invaders creator
    private func bossInvader(position: CGPoint) -> SKSpriteNode{
        
        
        let bossInvader = SKSpriteNode()
        let texture = SKTexture(imageNamed: String(format: "invaderBoss.png"))
        
        let asteroidCategoryMask : UInt32 = 0x1 << 1
        let asteroidCollisionMask : UInt32 = 0x1 << 2
        let asteroidContactMask : UInt32 = 0x1 << 2
        
        bossInvader.size = CGSize(width: 200, height: 110)
        bossInvader.name = "bossIvader"
        bossInvader.position = position
        bossInvader.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bossInvader.color = UIColor.gray
        bossInvader.texture = texture
        
        bossInvader.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 110))
        bossInvader.physicsBody?.isDynamic = true
        bossInvader.physicsBody?.affectedByGravity = false
        bossInvader.physicsBody?.affectedByGravity = false
        bossInvader.physicsBody?.categoryBitMask = asteroidCategoryMask
        bossInvader.physicsBody?.collisionBitMask = asteroidCollisionMask
        bossInvader.physicsBody?.contactTestBitMask = asteroidContactMask
        
        
        
        return bossInvader
        
        
        
        
        
        
    }
    
    private func dynamicAsteroidCreator(position: CGPoint) -> SKSpriteNode{
        
        let dynamicAsteroid = SKSpriteNode()
        let asteroidCategoryMask : UInt32 = 0x1 << 1
        let asteroidCollisionMask : UInt32 = 0x1 << 2
        let asteroidContactMask : UInt32 = 0x1 << 2
        
        dynamicAsteroid.size = CGSize(width: 60, height: 60)
        dynamicAsteroid.name = "dynamicAsteroid"
        dynamicAsteroid.position = position
        dynamicAsteroid.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dynamicAsteroid.color = UIColor.gray
        dynamicAsteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        dynamicAsteroid.physicsBody?.isDynamic = true
        dynamicAsteroid.physicsBody?.affectedByGravity = false
        dynamicAsteroid.physicsBody?.affectedByGravity = false
        dynamicAsteroid.physicsBody?.categoryBitMask = asteroidCategoryMask
        dynamicAsteroid.physicsBody?.collisionBitMask = asteroidCollisionMask
        dynamicAsteroid.physicsBody?.contactTestBitMask = asteroidContactMask
        dynamicAsteroid.run(SKAction.moveTo(x: 600, duration: 10))
        
        
        return dynamicAsteroid
        
    }
    
    
    private func asteroidCreator(position: CGPoint) -> SKSpriteNode{
        
        let asteroid = SKSpriteNode()
        let asteroidCategoryMask : UInt32 = 0x1 << 1
        let asteroidCollisionMask : UInt32 = 0x1 << 2
        let asteroidContactMask : UInt32 = 0x1 << 2
        let texture = SKTexture(imageNamed: "texture1")
        
        asteroid.size = CGSize(width: 60, height: 60)
        asteroid.name = "asteroid"
        asteroid.color = UIColor.brown
       
        asteroid.texture = texture
        asteroid.position = position
        asteroid.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        asteroid.physicsBody?.isDynamic = false
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.categoryBitMask = asteroidCategoryMask
        asteroid.physicsBody?.collisionBitMask = asteroidCollisionMask
        asteroid.physicsBody?.contactTestBitMask = asteroidContactMask
        
        
        
        
        
        
        return asteroid
    }
    
    private func bulletCreator(bulletType: BulletType)-> SKSpriteNode{
        
        var bullet = SKSpriteNode()
        let shipBulletcategoryMask : UInt32 = 0x1 << 2
        let shipBulletcollisionMask : UInt32 = 0x1 << 1
        let shipBulletcontaktMask : UInt32 = 0x1 << 0
        let invaderBulletcategoryMask : UInt32 = 0x1 << 1
        let invaderBulletcollisionMask : UInt32 = 0x1 << 2
        let invaderBulletcontaktMask : UInt32 = 0x1 << 0
        
        switch bulletType {
        case .shipFiredBullet:
            bullet = SKSpriteNode(color: SKColor.green, size: bulletSize)
            bullet.name = shipFiredBullet
            bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 16))
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = shipBulletcategoryMask
            bullet.physicsBody?.collisionBitMask = shipBulletcollisionMask
            bullet.physicsBody?.contactTestBitMask = shipBulletcontaktMask
            
        case.invaderFiredBullet:
            
            bullet = SKSpriteNode(color: SKColor.red, size: bulletSize)
            bullet.name = invaderFiredBullet
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 16))
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = invaderBulletcategoryMask
            bullet.physicsBody?.collisionBitMask = invaderBulletcollisionMask
            bullet.physicsBody?.contactTestBitMask = invaderBulletcontaktMask
            
        case .bossFiredBullet:
            bullet = SKSpriteNode(color: SKColor.red, size: bulletSize)
            bullet.name = bossFiredBullet
            bullet.size = CGSize(width: 8, height: 16)
            bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 16))
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = invaderBulletcategoryMask
            bullet.physicsBody?.collisionBitMask = invaderBulletcollisionMask
            bullet.physicsBody?.contactTestBitMask = invaderBulletcontaktMask
            
            
        }
        
        
        
        return bullet
    }
    
    private func fireBullet(bullet: SKNode, destination: CGPoint, duration: CFTimeInterval){
        let bulletFired = SKAction.sequence([SKAction.move(to: destination, duration: duration),SKAction.wait(forDuration: 3.0 / 60.0),SKAction.removeFromParent()])
        bullet.run(SKAction.group([bulletFired]))
        addChild(bullet)
    }
    
    
    
    private func invaderFired(forUpdate: CFTimeInterval){
        let existingBullet = childNode(withName: invaderFiredBullet )
        
        if existingBullet == nil {
            
            var invaderArray = [SKNode]()
            
            enumerateChildNodes(withName: "invaders"){
                node, stop in
                invaderArray.append(node)
                
                
            }
            if invaderArray.count > 0 {
                
                let invadersIndex = Int(arc4random_uniform(UInt32(invaderArray.count)))
                
                let chosenInvader = invaderArray[invadersIndex]
                let bullet = bulletCreator(bulletType: .invaderFiredBullet)
                bullet.position = CGPoint(x: chosenInvader.position.x, y: chosenInvader.position.y)
                
                let bulletDestination = CGPoint(x: chosenInvader.position.x, y: -600)
                
                
                fireBullet(bullet: bullet, destination: bulletDestination, duration: 2.0)
            }
            
        }
        
        
        
    }
    
    private func bossFired(forUpdate: CFTimeInterval){
        let existingBullet = childNode(withName: bossFiredBullet)
        
        if existingBullet == nil{
            if let boss = childNode(withName: "bossIvader"){
                
                let bullet = bulletCreator(bulletType: .bossFiredBullet)
                bullet.position = CGPoint(x: boss.position.x, y: boss.position.y)
                
                let bulletDestination = CGPoint(x: boss.position.x, y: -600)
                
                shotCount = 1
                
                fireBullet(bullet: bullet, destination: bulletDestination, duration: 1.0)
                
                
                
                
            }
            
        }
        
        
    }
    
    private func shipFired(){
        let existingBullet = childNode(withName: shipFiredBullet )
        
        
        if existingBullet == nil{
            if let ship = childNode(withName: "ship"){
                
                let bullet = bulletCreator(bulletType: .shipFiredBullet)
                bullet.position = CGPoint(x: ship.position.x, y: ship.position.y)
                
                let bulletDestination = CGPoint(x: ship.position.x, y: 650)
                
                shotCount = 1
                
                fireBullet(bullet: bullet, destination: bulletDestination, duration: 1.5)
                if soundStatus.bool(forKey: "SOUNDSTATUS"){
                    self.run(SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false))
                }
            }
            
        }
        
        
        
    }
    
    private func moveBoss(forUpdate currentTime: CFTimeInterval, invaderSpeed: CGFloat){
        
        
        if (currentTime - timeOfLastMove < timePerMove){
            return
        }
        
        
        bossMovementControl()
        
        let node = childNode(withName: "bossIvader")
        
        switch self.invaderMovementDirection{
        case .right :
            node?.position = CGPoint(x:  (node?.position.x)! + 30, y:  (node?.position.y)!)
        case . left:
            node?.position = CGPoint(x:  (node?.position.x)! - 30, y:  (node?.position.y)!)
        case .downLeft, .downRight:
            node?.position = CGPoint(x:  (node?.position.x)!, y:  (node?.position.y)! - invaderSpeed)
            
        case.none:
            break
            
            
        }
        self.timeOfLastMove = currentTime
        
        
        
        
        
        
    }
    
    
    
    
    
    
    private func moveInvader(forUpdate currentTime: CFTimeInterval, invaderSpeed: CGFloat){
        
        
        if (currentTime - timeOfLastMove < timePerMove){
            return
        }
        
        
        invaderMovementControl()
        
        enumerateChildNodes(withName: "invaders")
        {node, stop in
            
            switch self.invaderMovementDirection{
            case .right :
                node.position = CGPoint(x: node.position.x + 30, y: node.position.y)
            case . left:
                node.position = CGPoint(x: node.position.x - 30, y: node.position.y)
            case .downLeft, .downRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y - invaderSpeed)
                
            case.none:
                break
                
                
            }
            self.timeOfLastMove = currentTime
            
            
            
        }
        
        
    }
    
    private func invaderMovementControl(){
        
        
        let proposedMoveDirection: InvaderMoveDirection = invaderMovementDirection
        
        
        enumerateChildNodes(withName: "invaders")
        { node, stop in
            
            switch proposedMoveDirection{
            case.right:
                if (node.position.x >= CGFloat(300)) {
                    
                    self.invaderMovementDirection = .downLeft
                    
                    stop.pointee = true
                    
                }
            case.left:
                if (node.position.x <= CGFloat(-300)){
                    
                    
                    self.invaderMovementDirection = .downRight
                    
                    stop.pointee = true
                    
                    
                }
            case.downLeft:
                self.invaderMovementDirection = .left
                stop.pointee = true
            case.downRight:
                self.invaderMovementDirection = .right
                stop.pointee = true
                
            default:
                break
                
                
                
                
            }
            
        }
    }
    
    
    private func bossMovementControl(){
        
        
        let proposedMoveDirection: InvaderMoveDirection = invaderMovementDirection
        
        
        let node = childNode(withName: "bossIvader")
        
        switch proposedMoveDirection{
        case.right:
            if ((node?.position.x)! >= CGFloat(250)) {
                
                self.invaderMovementDirection = .downLeft
                
                
            }
        case.left:
            if ((node?.position.x)! <= CGFloat(-250)){
                
                
                self.invaderMovementDirection = .downRight
                
            }
        case.downLeft:
            self.invaderMovementDirection = .left
        case.downRight:
            self.invaderMovementDirection = .right
            
            
        default:
            break
            
            
            
            
            
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            
            if location.y < CGFloat(0){
                let node = childNode(withName: "ship")
                node?.position.x = location.x
                
            }
            
            if let locationName = atPoint(location).name{
                switch locationName{
                case "Pause":
                    self.scene?.isPaused = true
                    self.physicsWorld.speed = 0
                    pauseLabel.isHidden = true
                    unPauseLabel.isHidden = false
                    
                case "EndGame":
                    SpaceInvadersClass.lvl = 1
                    SpaceInvadersClass.lvlCount = 1
                    SpaceInvadersClass.lifeCount = 3
                    SpaceInvadersClass.scoreToPass = score
                    gameId.set(2, forKey: "ID")
                    
                    if let view = self.view {
                        if let scene = BlockBreakerGameOver(fileNamed: "BlockBreakerGameOver") {
                            scene.scaleMode = .aspectFit
                            view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                        }
                        
                        
                    }
                case "unpause":
                    self.scene?.isPaused = false
                    
                    self.physicsWorld.speed = 1
                    pauseLabel.isHidden = false
                    unPauseLabel.isHidden = true
                default:
                    break
                }
                
            }
            
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if atPoint(location).name != nil{
                
                shotCount = 0
                
                
            }
            
            
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if atPoint(location).name != nil{
                
                shotCount = 0
                
                
            }
            
            if location.y < CGFloat(-300){
                let node = childNode(withName: "ship")
                node?.position.x = location.x
                
            }
            
        }
    }
    
    
    
    private func initialization(){
        if spaceInvadersScore.value(forKey: "SpaceInvaders") == nil{
            spaceInvadersScore.set(score, forKey: "SpaceInvaders")
            
        }
        
        unPauseLabel.isHidden = true
        scoreLabel = childNode(withName: "score") as! SKLabelNode
        ship = childNode(withName: "ship") as! Player
        unPauseLabel = childNode(withName: "unpause") as! SKLabelNode
        pauseLabel = childNode(withName: "Pause") as! SKLabelNode
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        
        if  nodeNames.contains(shipFiredBullet) && nodeNames.contains("invaders"){
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            if soundStatus.bool(forKey: "SOUNDSTATUS"){
                self.run(SKAction.playSoundFileNamed("invaderkilled.wav", waitForCompletion: false))
            }
            score += 5
            shotCount = 1
            invadersCount -= 1
            
        }
        if nodeNames.contains(invaderFiredBullet) && nodeNames.contains("ship") || nodeNames.contains(bossFiredBullet) && nodeNames.contains("ship"){
            if soundStatus.bool(forKey: "SOUNDSTATUS"){
                self.run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
            }
            
            let shipToDelete = SpaceInvadersClass.shipLiveCount.removeLast()
            SpaceInvadersClass.lifeCount -= 1
            shipToDelete.removeFromParent()
            
            
            
        }
        
        if nodeNames.contains(shipFiredBullet) && nodeNames.contains("asteroid"){
            
            contact.bodyB.node?.removeFromParent()
            
            
            
            
            
        }
        if nodeNames.contains(shipFiredBullet) && nodeNames.contains("dynamicAsteroid"){
            
            contact.bodyB.node!.removeFromParent()
            
        }
        if  nodeNames.contains(shipFiredBullet) && nodeNames.contains("bossIvader"){
            contact.bodyB.node!.removeFromParent()
            
            score += 10
            bossHealth -= 5
            shotCount = 1
            
            
        }
    }
    
    
    
    
    private func endGame(){
        SpaceInvadersClass.scoreToPass = score
        if score > spaceInvadersScore.integer(forKey: "SpaceInvaders"){
            GameCenterManager.instance.saveScore(score: score, leaderBoardId: .spaceInvaders)
            spaceInvadersScore.set(score, forKey: "SpaceInvaders")
            
        }
        
        gameId.set(2, forKey: "ID")
        let lowLvl = CGFloat(-400)
        
        if SpaceInvadersClass.lifeCount == 0{
            SpaceInvadersClass.lvlCount = 1
            SpaceInvadersClass.lvl = 1
            SpaceInvadersClass.nextLvlSpaceInvaders = false
            ship.removeFromParent()
            
            
            SpaceInvadersClass.lifeCount = 3
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = BlockBreakerGameOver(fileNamed: "BlockBreakerGameOver") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                }
                
                
            }
            
            
        }
        
        if invadersCount == 0 || bossHealth == 0{
            gameId.set(2, forKey: "ID")
            SpaceInvadersClass.scoreToPass = score
            SpaceInvadersClass.lvl += 1
            SpaceInvadersClass.lvlCount += 1
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = NextLvlClass(fileNamed: "NextLvlScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))
                }
                
                
            }
            
            
            
            
            
        }
        
        enumerateChildNodes(withName: "invaders") {
            node, stop in
            if ((node.frame.minY) <= lowLvl){
                self.gameId.set(2, forKey: "ID")
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = BlockBreakerGameOver(fileNamed: "BlockBreakerGameOver") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFit
                        
                        // Present the scene
                        view.presentScene(scene,transition: SKTransition.moveIn(with: SKTransitionDirection.left, duration: TimeInterval(0.5)))                    }
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        self.endGame()
        scoreLabel.text = "SCORE: \(score)"
        
        if SpaceInvadersClass.lvl != 4{
            self.invaderFired(forUpdate: currentTime)
            self.moveInvader(forUpdate: currentTime, invaderSpeed: descendInvaderSpeed)
            if shotCount == 0{
                
                
                self.shipFired()
                
                
            }
            
        }else {
            bossHealthLabel.text = "Boss Health : \(bossHealth)"
            self.bossFired(forUpdate: currentTime)
            self.moveBoss(forUpdate: currentTime, invaderSpeed: descendInvaderSpeed)
            
            if shotCount == 0{
                
                
                self.shipFired()
                
                
            }
            
            
            
        }
        
        
        if SpaceInvadersClass.lvlCount == 9 && dynamicAsteroidCoun == 0{
            
            
            
            
            addChild(dynamicAsteroidCreator(position: CGPoint(x: -360, y: -300)))
            dynamicAsteroidCoun += 1
        }
        if  childNode(withName: "dynamicAsteroid") != nil{
            
            
            
            if (childNode(withName: "dynamicAsteroid")?.position.x)! > CGFloat(330){
                childNode(withName: "dynamicAsteroid")?.removeFromParent()
                dynamicAsteroidCoun = 0
            }
        }
        
        
        
        
    }
    
    
    
    func starfieldEmitterNode(speed: CGFloat, lifetime: CGFloat, scale: CGFloat, birthRate: CGFloat, color: SKColor) -> SKEmitterNode {
        let star = SKLabelNode(fontNamed: "Helvetica")
        star.fontSize = 80.0
        star.text = "✦"
        let textureView = SKView()
        let texture = textureView.texture(from: star)
        texture!.filteringMode = .nearest
        
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = texture
        emitterNode.particleBirthRate = birthRate
        emitterNode.particleColor = color
        emitterNode.particleLifetime = lifetime
        emitterNode.particleSpeed = speed
        emitterNode.particleScale = scale
        emitterNode.particleColorBlendFactor = 1
        emitterNode.position = CGPoint(x: (view?.frame.minX)!, y: frame.maxY)
        emitterNode.particlePositionRange = CGVector(dx: 750, dy: 0)
        emitterNode.particleSpeedRange = 16.0
        
        //Rotates the stars
        emitterNode.particleAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(-Double.pi/4), duration: 1),
            SKAction.rotate(byAngle: CGFloat(Double.pi/4), duration: 1)]))
        
        //Causes the stars to twinkle
        let twinkles = 20
        let colorSequence = SKKeyframeSequence(capacity: twinkles*2)
        let twinkleTime = 1.0 / CGFloat(twinkles)
        for i in 0..<twinkles {
            colorSequence.addKeyframeValue(SKColor.white,time: CGFloat(i) * 2 * twinkleTime / 2)
            colorSequence.addKeyframeValue(SKColor.yellow, time: (CGFloat(i) * 2 + 1) * twinkleTime / 2)
        }
        emitterNode.particleColorSequence = colorSequence
        
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        return emitterNode
    }
    
    func createStarLayers() {
        //A layer of a star field
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(speed: -48, lifetime: size.height / 23, scale: 0.2, birthRate: 1, color: SKColor.lightGray))
        
        addChild(starfieldNode)
        
        //A second layer of stars
        let emitterNode = starfieldEmitterNode(speed: -32, lifetime: size.height / 10, scale: 0.14, birthRate: 2, color: SKColor.gray)
        emitterNode.zPosition = -10
        starfieldNode.addChild(emitterNode)

//        //A third layer
//        emitterNode = starfieldEmitterNode(speed: -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.darkGray)
//        starfieldNode.addChild(emitterNode)
    }
}

