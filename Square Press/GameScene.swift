//
//  GameScene.swift
//  Square Press
//
//  Created by Greg Willis on 8/29/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var leftSquare = SKSpriteNode()
    var rightSquare = SKSpriteNode()
    
    var mainLabel: UILabel!
    var scoreLabel: SKLabelNode!
    
    var redColor = UIColor.redColor()
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var grayColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    
    var squareSize: CGSize {
        return CGSize(width: (CGRectGetWidth(self.frame) * 0.3), height: (CGRectGetWidth(self.frame) * 0.3))
    }
    
    var currentScore = 0
    var timer = 12


    override func didMoveToView(view: SKView) {
        backgroundColor = grayColor
        
        spawnSquares()
        mainLabel = spawnMainLabel()
        scoreLabel = spawnScoreLabel()
        randomizeSquareColor()
        countDown()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if let touchedNode = nodeAtPoint(touchLocation) as? SKSpriteNode {
                if touchedNode.color.description == offWhiteColor.description {
                    addToScore()
                    randomizeSquareColor()
                } else {
                    gameOver()
                    print("\(touchedNode.color)")
                    print("\(offWhiteColor)")
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}

//MARK: - Spawn Functions
extension GameScene {
    func spawnSquares() {
        
        leftSquare = SKSpriteNode(color: redColor, size: squareSize)
        leftSquare.position = CGPoint(x: (CGRectGetWidth(frame) * 0.3) , y: CGRectGetMidY(frame))
        addChild(leftSquare)
        
        rightSquare = SKSpriteNode(color: offWhiteColor, size: squareSize)
        rightSquare.position = CGPoint(x: (CGRectGetWidth(frame) * 0.7) , y: CGRectGetMidY(frame))
        addChild(rightSquare)

    }

    
    func spawnMainLabel() -> UILabel {
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height * 0.4))
        if let mainLabel = mainLabel {
            mainLabel.textColor = offWhiteColor
            mainLabel.font = UIFont(name: "Futura", size: CGRectGetWidth(frame) * 0.14)
            mainLabel.textAlignment = .Center
            mainLabel.numberOfLines = 0
            mainLabel.text = "Choose the WHITE Square"
            view!.addSubview(mainLabel)
        }
        
        return mainLabel
    }
    
    func spawnScoreLabel() -> SKLabelNode {
        let score = SKLabelNode(fontNamed: "Futura")
        score.fontColor = offWhiteColor
        score.fontSize = CGRectGetWidth(frame) * 0.15
        score.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) * 0.2)
        score.text = "Score: \(currentScore)"
        
        addChild(score)
        
        
        return score
    }
}

//MARK: - Timer Functions
extension GameScene {
    func countDown() {
        
        let wait = SKAction.waitForDuration(1.0)
        let countDown = SKAction.runBlock {
            self.timer -= 1
            
            if self.timer <= 10 && self.timer > 0 {
                self.mainLabel.text = "\(self.timer)"
                
            }
            if self.timer <= 0 {
                self.gameOver()
            }
        }
        let sequence = SKAction.sequence([wait, countDown])
        runAction(SKAction.repeatActionForever(sequence))
    }
}

//MARK: - Helper Functions
extension GameScene {
    func randomizeSquareColor() {
        if Int(round(random())) == 0 {
            leftSquare.color = offWhiteColor
            rightSquare.color = redColor
        } else {
            leftSquare.color = redColor
            rightSquare.color = offWhiteColor
        }
    }
    
    func addToScore() {
        currentScore += 1
        scoreLabel.text = "Score: \(currentScore)"
    }
    
    func gameOver() {
        timer = 0
//        scoreLabel.removeFromParent()
        mainLabel.text = "Loser!"
        
        // TODO: - Launch GameScene
        let wait = SKAction.waitForDuration(2.0)
        let transition = SKAction.runBlock {
            self.mainLabel.removeFromSuperview()
            if let gameScene = GameScene(fileNamed: "GameScene"), view = self.view {
                gameScene.scaleMode = .ResizeFill
                view.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        runAction(SKAction.sequence([wait, transition]))
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
}
