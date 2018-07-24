//
//  GameScene.swift
//  Gnop
//
//  Created by graduation on 7/19/18.
//  Copyright © 2018 Tarko Games. All rights reserved.
//


//Icon made by google from www.flaticon.com

import SpriteKit
import GameplayKit

let ballRadius = 20

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = [Int]()
    
    let ballCategory  : UInt32 = 0x1 << 0
    let paddleCategory: UInt32 = 0x1 << 1
    
    var playerScore = SKLabelNode(fontNamed: "Press Start")
    var enemyScore = SKLabelNode(fontNamed: "Press Start")
    
    let paddle = SKSpriteNode()
    
    //var playButton = SKLabelNode(fontNamed: "Press Start")
    
    let easyButton = SKLabelNode(fontNamed: "Press Start")
    let hardButton = SKLabelNode(fontNamed: "Press Start")
    let impossibleButton = SKLabelNode(fontNamed: "Press Start")
    var easiness = 0.04
    var playerMode = CGVector(dx: -125, dy : -75)
    var enemyMode = CGVector(dx: 125, dy : 75)

    let toPlay = SKLabelNode(fontNamed: "Press Start")

    
    let player = SKShapeNode(circleOfRadius: CGFloat(ballRadius))
    let enemy = SKShapeNode(circleOfRadius: CGFloat(ballRadius))
    
    let playTexture = SKTexture(imageNamed: "play-arrow.png")
    let pauseTexture = SKTexture(imageNamed: "pause-button.png")
    let button = SKSpriteNode()
    
    let replayTexture = SKTexture(imageNamed: "replay-arrow.png")
    let replayButton = SKSpriteNode()
    let homeTexture = SKTexture(imageNamed: "home-button.png")
    let homeButton = SKSpriteNode()
    
    let leftArrowTexture = SKTexture(imageNamed: "left-arrow-key.png")
    let rightArrowTexture = SKTexture(imageNamed: "right-arrow-key.png")
    let leftArrow = SKSpriteNode()
    let rightArrow = SKSpriteNode()

    
    var gameIsPaused = true
    var gameStarted = false
    
    let gifView = UIImageView()
    
   // let seq = SKAction()
    let fade = SKAction.fadeAlpha(to: 0, duration: 0.5)
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        
        gifView.frame = CGRect(x: 0, y: 30, width: self.frame.width/2, height: self.frame.width/2)
        gifView.loadGif(name: "gnop")
        view.addSubview(gifView)
        
        
        
        toPlay.text = "swipe to start game"
        toPlay.fontSize = 30
        toPlay.position = CGPoint(x: 0, y: -self.frame.height/2 + 50)
        toPlay.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addChild(toPlay)
        
        let actionL = SKAction.setTexture(leftArrowTexture, resize: true)
        leftArrow.run(actionL)
        leftArrow.position = CGPoint(x: -330, y: -self.frame.height/2 + 60);
        self.addChild(leftArrow)
        
        let actionR = SKAction.setTexture(rightArrowTexture, resize: true)
        rightArrow.run(actionR)
        rightArrow.position = CGPoint(x: 330, y: -self.frame.height/2 + 65);
        self.addChild(rightArrow)
        
        
        
        
       /* playButton.text = "PLAY"
        playButton.fontSize = 100
        playButton.position = CGPoint(x: 0, y: -200)
        playButton.fontColor = SKColor.black
        self.addChild(playButton)
         */
        
        easyButton.text = "easy"
        easyButton.fontSize = 80
        easyButton.position = CGPoint(x: 0, y: -175)
        easyButton.fontColor = SKColor.black
        self.addChild(easyButton)
        
        hardButton.text = "hard"
        hardButton.fontSize = 60
        hardButton.position = CGPoint(x: 0, y: -300)
        hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addChild(hardButton)
        
        impossibleButton.text = "impossible"
        impossibleButton.fontSize = 60
        impossibleButton.position = CGPoint(x: 0, y: -425)
        impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addChild(impossibleButton)
        
        
        let action = SKAction.setTexture(pauseTexture, resize: true)
        button.run(action)
        button.position = CGPoint(x: self.frame.width/2 - 35, y: self.frame.height/2 - 40);
        
        let replayButtonAction = SKAction.setTexture(replayTexture, resize: true)
        replayButton.run(replayButtonAction)
        replayButton.position = CGPoint(x: self.frame.width/2 - 35, y: self.frame.height/2 - 130);
        let homeButtonAction = SKAction.setTexture(homeTexture, resize: true)
        homeButton.run(homeButtonAction)
        homeButton.position = CGPoint(x: self.frame.width/2 - 35, y: self.frame.height/2 - 220);
        
        playerScore.fontSize = 75
        playerScore.position = CGPoint(x: 0, y: -125)
        playerScore.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        
        enemyScore.fontSize = 75
        enemyScore.position = CGPoint(x: 0, y: 50)
        enemyScore.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        
        //Set physics bodies for sides of screen
        let topLeftCorner = CGPoint(x: -self.frame.width/2, y: self.frame.height/2)
        let topRightCorner = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        let bottomLeftCorner = CGPoint(x: -self.frame.width/2, y: -self.frame.height/2)
        let bottomRightCorner =  CGPoint(x: self.frame.width/2, y: -self.frame.height/2)
        
        let leftBorder = SKPhysicsBody(edgeFrom: topLeftCorner, to: bottomLeftCorner)
        let rightBorder = SKPhysicsBody(edgeFrom: topRightCorner, to: bottomRightCorner)
        
        leftBorder.friction = 0
        leftBorder.restitution = 1
        
        rightBorder.friction = 0
        rightBorder.restitution = 1
        
        
        let leftBorderNode = SKNode()
        let rightBorderNode = SKNode()
        
        leftBorderNode.physicsBody = leftBorder
        leftBorderNode.physicsBody?.friction = 0
        leftBorderNode.physicsBody?.restitution = 1
        self.addChild(leftBorderNode)
        
        rightBorderNode.physicsBody = rightBorder
        rightBorderNode.physicsBody?.friction = 0
        rightBorderNode.physicsBody?.restitution = 1
        self.addChild(rightBorderNode)
        
        //create paddle and both balls
        paddle.size = CGSize(width: 150, height: 15)
        paddle.position = CGPoint(x: 0, y: 0)
        paddle.color = SKColor.black
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.allowsRotation = true
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.angularDamping = 0
        paddle.physicsBody?.linearDamping = 0
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.categoryBitMask =  paddleCategory
        paddle.physicsBody?.contactTestBitMask =  ballCategory
        paddle.physicsBody?.collisionBitMask =  ballCategory
        self.addChild(paddle)
        
        player.position = CGPoint(x: 0, y: -self.frame.height/2 + 150)
        player.fillColor = SKColor.black
        player.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ballRadius))
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 1
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask =  ballCategory
        player.physicsBody?.contactTestBitMask =  paddleCategory
        player.physicsBody?.collisionBitMask =  paddleCategory
        self.addChild(player)
        
        enemy.position = CGPoint(x: 0, y: self.frame.height/2 - 150)
        enemy.fillColor = SKColor.black
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ballRadius))
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.restitution = 1
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.categoryBitMask =  ballCategory
        enemy.physicsBody?.contactTestBitMask =  paddleCategory
        enemy.physicsBody?.collisionBitMask =  paddleCategory
        self.addChild(enemy)
        
    }
    
    func startGame(){
        score = [0,0]
        gifView.removeFromSuperview()
       // playButton.removeFromParent()
        
        self.addChild(playerScore)
        self.addChild(enemyScore)
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"

        self.addChild(button)
        
        easyButton.removeFromParent()
        hardButton.removeFromParent()
        impossibleButton.removeFromParent()

        
        
        
        toPlay.run(fade)
        leftArrow.run(fade)
        rightArrow.run(fade)
        shootPaddle(startPlayer: player)
        gameIsPaused = false
        gameStarted = true
        
        
        
        
    }
    
    func unpauseGame(){
        self.physicsWorld.speed = 1
        gameIsPaused = false
        let action = SKAction.setTexture(pauseTexture, resize: true)
        button.run(action)
        replayButton.removeFromParent()
        homeButton.removeFromParent()
    }
    
    func replayGame(){
        player.position.x = 0
        resetScore()
        shootPaddle(startPlayer: player)
        unpauseGame()
    }
    
    func shootPaddle(startPlayer: SKShapeNode){
        paddle.position = CGPoint(x: 0, y: 0)
        paddle.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        paddle.physicsBody?.angularVelocity = 0
        //paddle.zRotation = 0
        //let xVector = CGFloat(arc4random_uniform(151))
        //let yVector = CGFloat(150 - xVector)
        if startPlayer == self.player{
            paddle.physicsBody?.applyImpulse(enemyMode)
        }
        else {
            paddle.physicsBody?.applyImpulse(playerMode)
        }
        
    }
  
    func resetScore(){
        score = [0,0]
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
    }
    
    func addScore(playerWhoWon : SKShapeNode){
        
        if playerWhoWon == player{
            score[0] += 1
            shootPaddle(startPlayer: player)
        }
        if playerWhoWon == enemy{
            score[1] += 1
            shootPaddle(startPlayer: enemy)
        }
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
           // if playButton.contains(location) {
            //}
            if easyButton.contains(location) && gameStarted == false {
                easyButton.fontColor = SKColor.black
                easyButton.fontSize = 80
                hardButton.fontSize = 60
                hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                impossibleButton.fontSize = 60
                impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                playerMode = CGVector(dx: -95, dy : -60)
                enemyMode = CGVector(dx: 95, dy : 60)

            }
            else if hardButton.contains(location) && gameStarted == false{
                hardButton.fontColor = SKColor.black
                hardButton.fontSize = 80
                easyButton.fontSize = 60
                easyButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                impossibleButton.fontSize = 60
                impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                
                easiness = 0.02
                playerMode = CGVector(dx: -125, dy : -75)
                enemyMode = CGVector(dx: 125, dy : 75)

            }
            else if impossibleButton.contains(location) && gameStarted == false{
                impossibleButton.fontColor = SKColor.black
                impossibleButton.fontSize = 75
                easyButton.fontSize = 60
                easyButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                hardButton.fontSize = 60
                hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                
                easiness = 0
                playerMode = CGVector(dx: -200, dy : -150)
                enemyMode = CGVector(dx: 200, dy : 150)

            }
            else if button.contains(location) {
                if gameIsPaused == false{ //pause

                    self.physicsWorld.speed = 0.0
                    gameIsPaused = true
                    let action = SKAction.setTexture(playTexture, resize: true)
                    button.run(action)
                    self.addChild(replayButton)
                    self.addChild(homeButton)

                }
                else { //unpause
                    unpauseGame()
                }
            }
            else if replayButton.contains(location) && gameIsPaused==true{
                replayGame()
            }
            else if homeButton.contains(location){
                
            }
            else if location.x > -self.frame.width / 2 + CGFloat(ballRadius)*2 && location.x < self.frame.width / 2 - CGFloat(ballRadius){
                if gameIsPaused == false{
                player.run(SKAction.moveTo(x: location.x, duration: 0))
                }
                if gameStarted == false{
                    if location.y < player.position.y{
                        startGame()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if location.x > -self.frame.width / 2 + CGFloat(ballRadius) && location.x < self.frame.width / 2 - CGFloat(ballRadius)  && gameIsPaused == false{
                player.run(SKAction.moveTo(x: location.x, duration: 0))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if paddle.position.x > -self.frame.width / 2 + CGFloat(ballRadius) && paddle.position.x < self.frame.width / 2 - CGFloat(ballRadius){
            if paddle.position.y > self.frame.height/2 - 400 && paddle.position.y < self.frame.height/2  - 300{
                enemy.run(SKAction.moveTo(x: paddle.position.x, duration: 0.1))
            }
            else if paddle.position.y > self.frame.height/2 - 300{
                enemy.run(SKAction.moveTo(x: paddle.position.x, duration: easiness))
            }
        }
        if paddle.position.y > self.frame.height / 2 - 10 {
            addScore(playerWhoWon: player)
        }
        else if paddle.position.y < -self.frame.height / 2 - 10{
            addScore(playerWhoWon: enemy)
        }
       if (paddle.physicsBody?.velocity.dy)! < CGFloat(200) && (paddle.physicsBody?.velocity.dy)! > CGFloat(-200) && gameIsPaused == false{
            if (paddle.physicsBody?.velocity.dy)! > 0{
                paddle.physicsBody?.velocity.dy = (paddle.physicsBody?.velocity.dy)! + 200
                paddle.physicsBody?.velocity.dx = (paddle.physicsBody?.velocity.dx)! - 200
            }
            else if (paddle.physicsBody?.velocity.dy)! < 0{
                paddle.physicsBody?.velocity.dy = (paddle.physicsBody?.velocity.dy)! - 200
                paddle.physicsBody?.velocity.dx = (paddle.physicsBody?.velocity.dx)! + 200
            }
        }
    }
}

