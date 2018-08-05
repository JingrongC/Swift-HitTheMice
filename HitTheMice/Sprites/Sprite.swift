//
//  Sprite.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-26.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Sprite: SKSpriteNode {
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    configurePhysicsBody()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configurePhysicsBody() {}
  
  func addToScene(atLayer parentNode:SKNode, atPosition point:CGPoint) {
    position = point
    parentNode.addChild(self)
  }
}
