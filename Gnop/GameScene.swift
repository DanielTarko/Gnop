//
//  GameScene.swift
//  Gnop
//
//  Created by graduation on 7/19/18.
//  Copyright © 2018 Tarko Games. All rights reserved.
//


//Icons made by google from www.flaticon.com

import SpriteKit
import GameplayKit

let ballRadius = 20

var winner = String()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = [Int]()
    
    let ballCategory  : UInt32 = 0x1 << 0
    let paddleCategory: UInt32 = 0x1 << 1
    
    var playerScore = SKLabelNode(fontNamed: "Press Start")
    var enemyScore = SKLabelNode(fontNamed: "Press Start")
    
    let paddle = SKSpriteNode()
    
    let easyButton = SKLabelNode(fontNamed: "Press Start")
    let hardButton = SKLabelNode(fontNamed: "Press Start")
    let impossibleButton = SKLabelNode(fontNamed: "Press Start")
    var easiness = 0.04
    var playerMode = CGVector(dx: -95, dy : -60)
    var enemyMode = CGVector(dx: 95, dy : 60)

    let toPlay = SKLabelNode(fontNamed: "Press Start")
    let toWin = SKLabelNode(fontNamed: "Press Start")

    
    let player = SKShapeNode(circleOfRadius: CGFloat(ballRadius))
    let enemy = SKShapeNode(circleOfRadius: CGFloat(ballRadius))
    
    let playTexture = SKTexture(imageNamed: "play-arrow.png")
    let pauseTexture = SKTexture(imageNamed: "pause-button.png")
    let pauseButton = SKSpriteNode()
    let playButton = SKSpriteNode()
    
    let replayTexture = SKTexture(imageNamed: "replay-arrow.png")
    let replayButton = SKSpriteNode()
    
    let leftArrowTexture = SKTexture(imageNamed: "left-arrow-key.png")
    let rightArrowTexture = SKTexture(imageNamed: "right-arrow-key.png")
    let leftArrow = SKSpriteNode()
    let rightArrow = SKSpriteNode()

    
    var gameIsPaused = true
    var gameStarted = false
    
    let gifView = UIImageView()
    
    let fade = SKAction.fadeAlpha(to: 0, duration: 0.5)
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        
        gifView.frame = CGRect(x: 0, y: 30, width: self.frame.width/2, height: self.frame.width/2)
        gifView.loadGif(name: "gnop")
        gifView.animationRepeatCount = 1
        view.addSubview(gifView)
        
    
        
        toPlay.text = "touch & drag to start"
        toPlay.fontSize = 25
        toPlay.position = CGPoint(x: 0, y: -self.frame.height/2 + 75)
        toPlay.fontColor = SKColor.black
        self.addChild(toPlay)
        
        toWin.text = "first to 11 wins"
        toWin.fontSize = 25
        toWin.position = CGPoint(x: 0, y: -self.frame.height/2 + 125)
        toWin.fontColor = SKColor.black
        self.addChild(toWin)
        
        let actionL = SKAction.setTexture(leftArrowTexture, resize: true)
        leftArrow.run(actionL)
        leftArrow.position = CGPoint(x: -310, y: -self.frame.height/2 + 85);
        self.addChild(leftArrow)
        
        let actionR = SKAction.setTexture(rightArrowTexture, resize: true)
        rightArrow.run(actionR)
        rightArrow.position = CGPoint(x: 310, y: -self.frame.height/2 + 85);
        self.addChild(rightArrow)
        
        
        

        easyButton.text = "easy"
        easyButton.fontSize = 80
        easyButton.position = CGPoint(x: 0, y: -120)
        easyButton.fontColor = SKColor.black
        self.addChild(easyButton)
        
        hardButton.text = "hard"
        hardButton.fontSize = 60
        hardButton.position = CGPoint(x: 0, y: -245)
        hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addChild(hardButton)
        
        impossibleButton.text = "impossible"
        impossibleButton.fontSize = 60
        impossibleButton.position = CGPoint(x: 0, y: -360)
        impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addChild(impossibleButton)
 
        
        let action = SKAction.setTexture(pauseTexture, resize: true)
        pauseButton.run(action)
        pauseButton.position = CGPoint(x: self.frame.width/2 - 45, y: self.frame.height/2 - 50)
        
        let playaction = SKAction.setTexture(playTexture, resize: true)
        playButton.run(playaction)
        playButton.position = CGPoint(x: -100, y: 400);
        
        let replayButtonAction = SKAction.setTexture(replayTexture, resize: true)
        replayButton.run(replayButtonAction)
        replayButton.position = CGPoint(x: 100, y: 400);
        
        playerScore.fontSize = 75
        playerScore.position = CGPoint(x: 0, y: -25)
        playerScore.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
        
        enemyScore.fontSize = 75
        enemyScore.position = CGPoint(x: 0, y: 150)
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
        
        player.position = CGPoint(x: 0, y: -self.frame.height/2 + 225)
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
        
        enemy.position = CGPoint(x: 0, y: self.frame.height/2 - 80)
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

        self.addChild(pauseButton)
        
        easyButton.removeFromParent()
        hardButton.removeFromParent()
        impossibleButton.removeFromParent()
   
        toPlay.run(fade)
        toWin.run(fade)
        leftArrow.run(fade)
        rightArrow.run(fade)
        shootPaddle(startPlayer: enemy) //they are are reversed
        gameIsPaused = false
        gameStarted = true
    }
    
    func pauseGame(){
        self.physicsWorld.speed = 0.0
        gameIsPaused = true
        self.addChild(playButton)
        self.addChild(replayButton)
        self.addChild(easyButton)
        self.addChild(hardButton)
        self.addChild(impossibleButton)
        pauseButton.removeFromParent()
    }
    
    func unpauseGame(){
        self.physicsWorld.speed = 1
        gameIsPaused = false
        playButton.removeFromParent()
        replayButton.removeFromParent()
        easyButton.removeFromParent()
        hardButton.removeFromParent()
        impossibleButton.removeFromParent()
        self.addChild(pauseButton)
    }
    
    func replayGame(){
        player.position.x = 0
        resetScore()
        shootPaddle(startPlayer: player)
        unpauseGame()
    }
    
    func shootPaddle(startPlayer: SKShapeNode){
        paddle.position = CGPoint(x: 0, y: 100)
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
            if score[0] == 11 {
                winner = "player"
                if let nextScene = WinScene(fileNamed: "WinScene"){
                    nextScene.scaleMode = self.scaleMode
                    view?.presentScene(nextScene)
                }
            }
        }
        if playerWhoWon == enemy{
            score[1] += 1
            shootPaddle(startPlayer: enemy)
            if score[1] == 11{
                winner = "enemy"
                if let nextScene = WinScene(fileNamed: "WinScene"){
                    nextScene.scaleMode = self.scaleMode
                    view?.presentScene(nextScene)
                }
            }
        }
        playerScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
           // if playButton.contains(location) {
            //}
            if easyButton.contains(location) && gameIsPaused == true {
                easyButton.fontColor = SKColor.black
                easyButton.fontSize = 80
                hardButton.fontSize = 60
                hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                impossibleButton.fontSize = 60
                impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                
                easiness = 0.04
                playerMode = CGVector(dx: -95, dy : -60)
                enemyMode = CGVector(dx: 95, dy : 60)
                if gameStarted == true{
                    shootPaddle(startPlayer: player)
                    resetScore()
                }

            }
            else if hardButton.contains(location) && gameIsPaused == true{
                hardButton.fontColor = SKColor.black
                hardButton.fontSize = 80
                easyButton.fontSize = 60
                easyButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                impossibleButton.fontSize = 60
                impossibleButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                
                easiness = 0.02
                playerMode = CGVector(dx: -125, dy : -75)
                enemyMode = CGVector(dx: 125, dy : 75)
                if gameStarted == true{
                    shootPaddle(startPlayer: player)
                    resetScore()

                }

            }
            else if impossibleButton.contains(location) && gameIsPaused == true{
                impossibleButton.fontColor = SKColor.black
                impossibleButton.fontSize = 75
                easyButton.fontSize = 60
                easyButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                hardButton.fontSize = 60
                hardButton.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha:0.5)
                
                easiness = 0
                playerMode = CGVector(dx: -200, dy : -150)
                enemyMode = CGVector(dx: 200, dy : 150)
                if gameStarted == true{
                    shootPaddle(startPlayer: player)
                    resetScore()

                }

            }
            if pauseButton.contains(location) {
              //pause
                pauseGame()
               
            }
            else if playButton.contains(location){
                unpauseGame()
            }
            else if replayButton.contains(location) && gameIsPaused==true{
                replayGame()
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

