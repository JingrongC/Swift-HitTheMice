//
//  Target.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-26.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Target:Sprite {    
  // MARK: - Properties
  var gotHit = false

  // MARK:  Initializers
  convenience init() {
    self.init(texture: SKTexture(imageNamed: "Mice"))
    name = "Target"
    size = CGSize(width: 100,height: 50)
  }

  override func configurePhysicsBody() {
    let bodySize = CGSize(width: frame.size.width*0.75,height: frame.size.height)
    physicsBody = SKPhysicsBody(rectangleOf: bodySize,center:CGPoint(x: -frame.size.width*0.5+bodySize.width*0.5,y: 0))
    physicsBody!.categoryBitMask = CategoryBitMask.Target.rawValue
    physicsBody!.collisionBitMask = CategoryBitMask.Ball.rawValue
    physicsBody!.contactTestBitMask = CategoryBitMask.Ball.rawValue | CategoryBitMask.Cheese.rawValue
    physicsBody!.friction = 0
    physicsBody!.restitution = 1
    physicsBody!.linearDamping = 0
    physicsBody!.angularDamping = 0
    physicsBody!.allowsRotation = false
    physicsBody!.isDynamic = true
    physicsBody!.affectedByGravity = false
  }
  
  // MARK: - convenience methods
  func startAnimation() {
    // Moving
    let actionStart = SKAction.moveTo(x: gameScreenWidth*0.5-frame.width*0.5, duration: 0)
    let fadeIn = SKAction.fadeIn(withDuration: 0)
    let initialAction = SKAction.sequence([actionStart,fadeIn])
    let moving = SKAction.moveBy(x: -gameScreenWidth*0.5, y:0, duration: targetMovingDuration)
      run(initialAction,completion:{self.run(SKAction.repeatForever(moving), withKey: "Moving")})
  }

  func stopAnimation() {
    removeAction(forKey: "Moving")
  }
  
  func wasHit() {
    stopAnimation()
  }
  
  func eatCheese(node:SKNode) {
    stopAnimation()
    node.removeFromParent()
    playSound(node: self,contactState: .EatCheese)
  }
}
