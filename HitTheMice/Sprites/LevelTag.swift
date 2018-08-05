//
//  LevelTag.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-10-02.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class LevelTag:SKSpriteNode {
  var presentDelegate:PresentSceneDelegate?
  
  convenience init(imageName:String) {
    self.init(texture: SKTexture(imageNamed: imageName))
    name = imageName
    isUserInteractionEnabled = true
    size = CGSize(width: 128,height: 128)
  }
  
  func addToScene(atLayer parentNode:SKNode, atPosition point:CGPoint) {
    position = point
    parentNode.addChild(self)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if name != "Lock" {
      let levelNode = children[0] as! SKLabelNode
      let selectedLevel = Int(levelNode.name!)!
      gameLevel = selectedLevel
      presentDelegate!.presentGameScene()
    } else {
      shakingTag()
    }
  }
  
  func shakingTag() {
    let moveLeft = SKAction.move(by: CGVector(dx: -5.0,dy: 0), duration: 0.05)
    let moveRight = SKAction.move(by: CGVector(dx: 5.0,dy: 0), duration: 0.05)
    let seqActions = [moveLeft,moveRight,moveRight,moveLeft]
    run(SKAction.repeat(SKAction.sequence(seqActions), count: 5))
  }
}
