//
//  Ball.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-26.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Ball:Sprite {    
  // MARK: - Properties
  var originalPosition = CGPoint()

  // MARK: - Initializers
  convenience  init() {
    self.init(texture: SKTexture(imageNamed: "Ball"))
    name = "Ball"
    size = CGSize(width: 60,height: 60)
  }
  
  override func configurePhysicsBody() {
    physicsBody = SKPhysicsBody(circleOfRadius: frame.width*0.5)
    physicsBody!.categoryBitMask = CategoryBitMask.Ball.rawValue
    physicsBody!.collisionBitMask = CategoryBitMask.allButCheeseAndBottom
    physicsBody!.contactTestBitMask = CategoryBitMask.allButCheese
    physicsBody!.friction = 0
    physicsBody!.restitution = 1
    physicsBody!.linearDamping = 0
    physicsBody!.angularDamping = 0
    physicsBody!.allowsRotation = false
    physicsBody!.isDynamic = true
    physicsBody!.affectedByGravity = false
  }
  
  override func addToScene(atLayer parentNode: SKNode, atPosition point: CGPoint) {
    position = point
    originalPosition = point
    parentNode.addChild(self)
  }
}
