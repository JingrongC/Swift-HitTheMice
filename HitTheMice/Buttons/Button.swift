//
//  Button.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-26.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Button:SKSpriteNode {
  var presentDelegate:PresentSceneDelegate?
  convenience init(imageName:String) {
    self.init(texture: SKTexture(imageNamed: imageName))
    name = imageName
    isUserInteractionEnabled = true
    size = CGSize(width: 170,height: 170)
  }
  
  func addToScene(atLayer parentNode:SKNode, atPosition point:CGPoint) {
    position = point
    parentNode.addChild(self)
  }
}
