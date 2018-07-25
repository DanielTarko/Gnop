//
//  WinScene.swift
//  Gnop
//
//  Created by graduation on 7/25/18.
//  Copyright © 2018 Tarko Games. All rights reserved.
//

import SpriteKit

class WinScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let youLabel = SKLabelNode(fontNamed: "Press Start")
        youLabel.fontSize = 180
        youLabel.fontColor = SKColor.black
        youLabel.position = CGPoint(x: 0, y: 250)
        youLabel.text = "YOU"
        self.addChild(youLabel)
        
        
        let label = SKLabelNode(fontNamed: "Press Start")
        label.fontSize = 180
        label.fontColor = SKColor.black
        label.position = CGPoint(x: 0, y: 40)
        if winner == "player"{
            label.text = "WIN"
        }
        else{
            label.text = "LOSE"
        }
        self.addChild(label)
        
        let continueLabel = SKLabelNode(fontNamed: "Press Start")
        continueLabel.fontSize = 20
        continueLabel.fontColor = SKColor.black
        continueLabel.text = "tap anywhere to continue"
        continueLabel.position = CGPoint(x: 0, y: -200)
        self.addChild(continueLabel)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hi")
        if let nextScene = GameScene(fileNamed: "GameScene"){
            nextScene.scaleMode = self.scaleMode
            view?.presentScene(nextScene)
        }
    }
}
