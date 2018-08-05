//
//  SpriteObstacle.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-09-10.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit


class SpriteObstacle:SKSpriteNode {
  convenience init(imageName:String,rotation:CGFloat,size:CGSize) {
    self.init(texture: SKTexture(imageNamed: imageName))
    name = imageName
    configurePhysicsBody()
    zRotation = rotation
    self.size=size
  }
  
  func configurePhysicsBody() {
    physicsBody = SKPhysicsBody(rectangleOf:frame.size)
    physicsBody!.categoryBitMask = CategoryBitMask.Obstacle.rawValue
    physicsBody!.contactTestBitMask = CategoryBitMask.Ball.rawValue
    physicsBody!.friction = 0
    physicsBody!.restitution = 1
    physicsBody!.linearDamping = 0
    physicsBody!.angularDamping = 0
    physicsBody!.allowsRotation = false
    physicsBody!.isDynamic = false
    physicsBody!.affectedByGravity = false
  }    
}
