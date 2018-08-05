//
//  Cheese.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-08.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Cheese:Sprite {    
  convenience init() {
    self.init(texture: SKTexture(imageNamed: "Cheese"))
    name = "Cheese"
    size = CGSize(width: 60,height: 43)
  }
  
  override func configurePhysicsBody() {
    physicsBody = SKPhysicsBody(rectangleOf:frame.size)
    physicsBody?.categoryBitMask = CategoryBitMask.Cheese.rawValue
    physicsBody?.collisionBitMask = CategoryBitMask.Target.rawValue
    physicsBody?.contactTestBitMask = CategoryBitMask.Target.rawValue
    physicsBody?.isDynamic = false
    physicsBody?.affectedByGravity = false
  }    
}
