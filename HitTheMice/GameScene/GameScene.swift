//
//  GameScene.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-19.
//  Copyright (c) 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class GameScene: Scene,SKPhysicsContactDelegate {    
  let ball = Ball()
  let target = Target()
  let gameLayer = SKNode()
  let confirmationLayer = SKNode()
  
  var ballVelocityBeforeisPaused = CGVector()
  var cheesesLeft = maxCheesesCount
  var gameStarted = false
  var impulseAppliedToBall = CGVector()
  var obstacleNodes = [SKNode]()
  var lineNode = SKShapeNode()
 
  // MARK: - Initializers
  override func didMove(to view: SKView) {
    if soundState {
      if backgroundMusicPlayer != nil {
        backgroundMusicPlayer!.play()
      }
    }
    gameStarted = true
    initialScene()
  }
  
  func initialScene() {
    // Configure scene
    name = "GameScene"
    physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -gameScreenWidth*0.5, y: -gameScreenHeight*0.5), size: CGSize(width: gameScreenWidth,height: gameScreenHeight)))
    physicsBody!.categoryBitMask = CategoryBitMask.Edge.rawValue
    physicsWorld.contactDelegate = self

    // Add gameLayer
    gameLayer.name = "GameLayer"
    addChild(gameLayer)

    // Configure confirmationLayer
    confirmationLayer.name = "ConfirmationLayer"
    
    // Add ball
    ball.addToScene(atLayer: gameLayer, atPosition: CGPoint(x: 0,y: -gameScreenHeight*0.5+ball.frame.height*2.0))

    // Add line node
    addLineNode()
    
    // Add target
    target.addToScene(atLayer: gameLayer, atPosition: CGPoint(x: gameScreenWidth*0.5,y: gameScreenHeight*0.5-target.frame.height*0.5))
    target.startAnimation()
    
    // Add cheese
    for cheeseOrder in 1...maxCheesesCount {
      let cheese = Cheese()
      cheese.addToScene(atLayer: gameLayer, atPosition: CGPoint(x: -gameScreenWidth*0.5 + cheese.frame.width*CGFloat(cheeseOrder) - cheese.frame.width*0.5,y: gameScreenHeight*0.5 - cheese.frame.height*0.5))
    }
    
    // Add Pause button
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    pauseButton.size = CGSize(width: 100,height: 100)
    pauseButton.zPosition = SceneLayer.Function.rawValue
    addButton(parentNode: self,node:pauseButton,nodeName:"PauseResume",position: CGPoint(x: -size.height*viewAspectRatio*0.5 + pauseButton.frame.width*0.5,y: size.height*0.5 - pauseButton.frame.height*0.5))
    
    // Add bottom and top edge
    for positionY in [ball.position.y-ball.frame.width,gameScreenHeight*0.5-1.0] {
      let invisibleEdge = SKNode()
      invisibleEdge.name = "Bottom"
      invisibleEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -gameScreenWidth*0.5,y: positionY), to: CGPoint(x: gameScreenWidth*0.5,y: positionY))
      invisibleEdge.physicsBody!.categoryBitMask = CategoryBitMask.Bottom.rawValue
      invisibleEdge.physicsBody!.contactTestBitMask = CategoryBitMask.Ball.rawValue
      gameLayer.addChild(invisibleEdge)
    }

    // Add HUD
    let currentLevel = SKLabelNode()
    addLabel(parentNode: self, node: currentLevel, position: CGPoint(x: 0,y: size.height*0.5-pauseButton.frame.height*0.5), fontSize: gameScreenWidth*0.06, fontColor: SKColor.green, name: "CurrentLevel", text: "Level \(gameLevel)", fontName: "Chalkduster")

  }
  
  func addLineNode() {
    lineNode = SKShapeNode()
    lineNode.name = "LineNode"
    lineNode.strokeColor = SKColor.red
    gameLayer.addChild(lineNode)
    lineNode.path = updatePathToDraw(point: CGPoint(x: ball.position.x,y: gameScreenHeight))
  }

  func updatePathToDraw(point:CGPoint) -> CGPath {
    lineNode.alpha = 1
    let pathToDraw = CGMutablePath()
    let distanceByX = point.x - ball.position.x
    let distanceByY = abs(point.y - ball.position.y)
    pathToDraw.move(to:CGPoint(x: ball.position.x, y: ball.position.y))
    let toPointX = (gameScreenHeight*0.5 - ball.position.y)*distanceByX/distanceByY + ball.position.x
    pathToDraw.addLine(to:CGPoint(x: toPointX,y: gameScreenHeight*0.5))
    pathToDraw.closeSubpath()
    
    // Update impulse applied to ball
    let deltaX = (gameScreenHeight*0.5 - ball.position.y)*distanceByX/distanceByY
    let deltaY = gameScreenHeight*0.5 - ball.position.y
    let scaleRate = impulseToBall/sqrt(deltaX*deltaX + deltaY*deltaY)
    impulseAppliedToBall = CGVector(dx: deltaX*scaleRate,dy: deltaY*scaleRate)

    return pathToDraw
  }

  // MARK: - Touches Event
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameLayer.isPaused || ball.physicsBody?.velocity != CGVector.zero {
      return
    }
    
    for touch in touches {
      let location = touch.location(in: gameLayer)
      if abs(location.x) <= gameScreenWidth*0.5 && abs(location.y) <= gameScreenHeight*0.5 {
          lineNode.path = updatePathToDraw(point: location)
      }
    }
  }
    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first!.location(in:self)
    let touchedNode = atPoint(location)
    if touchedNode.name == "PauseResume" {
      if !gameLayer.isPaused {
        gamePaused()
      } else {
        gameResume()
      }
    }
    
    if gameLayer.isPaused {
      return
    }
    
    if ball.physicsBody?.velocity == CGVector(dx:0,dy:0) && impulseAppliedToBall.dx != 0 {
      ball.physicsBody?.applyImpulse(impulseAppliedToBall)
      lineNode.alpha = 0
    }
  }
  
  // MARK: - Game Control
  func gameOver() {
    if backgroundMusicPlayer != nil {
      backgroundMusicPlayer!.stop()
    }
    presentDelegate!.presentGameOverScene()
  }
  
  func gamePassed() {
    if backgroundMusicPlayer != nil {
      backgroundMusicPlayer!.stop()
    }
    presentDelegate!.presentPassedScene(savedCheeses:cheesesLeft)
  }
  
  func gamePaused() {
    if let _ = childNode(withName:"ConfirmationLayer") {
      return
    }
    if let pauseButton = childNode(withName:"PauseResume") as? SKSpriteNode {
      pauseButton.texture = SKTexture(imageNamed: "Resume")
    }
    addChild(confirmationLayer)
    gameLayer.alpha = 0.2
    gameLayer.isPaused = true
    ballVelocityBeforeisPaused = (ball.physicsBody?.velocity)!
    ball.physicsBody?.velocity = CGVector.zero
    if backgroundMusicPlayer != nil {
      backgroundMusicPlayer!.pause()
    }
    //Add button
    let backToHome = BackToHomeButton(imageName:"Home")
    backToHome.presentDelegate = presentDelegate
    backToHome.addToScene(atLayer: confirmationLayer, atPosition: CGPoint(x: -backToHome.frame.width*0.5,y: 0))
    
    let replay = ReplayButton(imageName: "Replay")
    replay.presentDelegate = presentDelegate
    replay.addToScene(atLayer: confirmationLayer, atPosition: CGPoint(x: replay.frame.width*0.5,y: backToHome.position.y))
  }
  
  func gameResume() {
    if soundState {
      if backgroundMusicPlayer != nil {
        backgroundMusicPlayer!.play()
      }
    }
    gameLayer.isPaused = false
    if let resumeButton = childNode(withName:"PauseResume") as? SKSpriteNode {
      resumeButton.texture = SKTexture(imageNamed: "Pause")
    }
    ball.physicsBody?.velocity = ballVelocityBeforeisPaused
    confirmationLayer.removeFromParent()
    gameLayer.alpha = 1
  }
  
  // MARK: - SKPhysicsContactDelegate
  func didBegin(_ contact: SKPhysicsContact) {
    if !gameStarted {
      return
    }
    switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
      case CategoryBitMask.Ball.rawValue | CategoryBitMask.Bottom.rawValue:
        gameOver()
      case CategoryBitMask.Ball.rawValue | CategoryBitMask.Target.rawValue:
        gamePassed()
      case CategoryBitMask.Cheese.rawValue | CategoryBitMask.Target.rawValue:
        cheesesLeft -= 1
        if cheesesLeft <= 0 {
          gameStarted = false
          gameOver()
        } else {
          var target = Target()
          if contact.bodyA.node is Cheese {
            target = contact.bodyB.node as! Target
            target.eatCheese(node: contact.bodyA.node!)
          }
          if contact.bodyB.node is Cheese {
            target = contact.bodyA.node as! Target
            target.eatCheese(node: contact.bodyB.node!)
          }
          target.startAnimation()
        }
      default:
        break
    }
  }
}
