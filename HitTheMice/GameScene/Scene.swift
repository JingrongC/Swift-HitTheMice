//
//  Scene.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-09-15.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class Scene:SKScene {
  var presentDelegate:PresentSceneDelegate?
  
  override init(size:CGSize) {
    super.init(size:size)
    scaleMode = .aspectFill
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let background = SKSpriteNode(imageNamed: "Background")
    background.size = self.size
    background.zPosition = SceneLayer.Background.rawValue
    addChild(background)
    
    // Add sound button
    let sound = Sound()
    sound.zPosition = SceneLayer.Function.rawValue
    sound.addToScene(atLayer: self,atPosition:CGPoint(x: size.height*viewAspectRatio*0.5-sound.size.width*0.5,y: size.height*0.5 - sound.frame.height*0.5))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
