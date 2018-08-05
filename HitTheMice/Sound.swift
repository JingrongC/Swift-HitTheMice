//
//  Sound.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-19.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Sound:SKSpriteNode {    
  convenience  init() {
    var soundTexture = SKTexture()
    if soundState {
      soundTexture = SKTexture(imageNamed: "SoundOn")
    } else {
      soundTexture = SKTexture(imageNamed: "SoundOff")
    }
    self.init(texture: soundTexture)
    name = "Sound"
    isUserInteractionEnabled = true
    size = CGSize(width:100,height:100)
  }

  func addToScene(atLayer parentNode: SKNode,atPosition point:CGPoint) {
    position = point
    parentNode.addChild(self)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if soundState {
      soundState = false
      texture = SKTexture(imageNamed: "SoundOff")
      if backgroundMusicPlayer != nil {
        backgroundMusicPlayer!.stop()
      }
    } else {
      soundState = true
      texture = SKTexture(imageNamed: "SoundOn")
      if let _ = self.scene as? GameScene {
        if backgroundMusicPlayer != nil {
          backgroundMusicPlayer!.play()
        }
      }
    }
  }
}
