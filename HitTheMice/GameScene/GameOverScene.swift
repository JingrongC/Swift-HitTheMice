//
//  GameOverScene.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-09.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class GameOverScene:Scene {
  override func didMove(to view: SKView) {
    playSound(node: self, contactState: .GameOver)
    
    //Add button
    let backToHome = BackToHomeButton(imageName:"Home")
    backToHome.presentDelegate = presentDelegate
    backToHome.addToScene(atLayer: self, atPosition: CGPoint(x: -backToHome.frame.width*0.5,y: 0))
    
    let replay = ReplayButton(imageName: "Replay")
    replay.presentDelegate = presentDelegate
    replay.addToScene(atLayer: self, atPosition: CGPoint(x: replay.frame.width*0.5, y: backToHome.position.y))
    
    let gameOverLabel=SKLabelNode()
    addLabel(parentNode: self,node: gameOverLabel,position: CGPoint(x:0,y:backToHome.frame.height),fontSize: gameScreenWidth*0.07,fontColor: SKColor.red,name: "GameOver",text: "Game Over",fontName: "Chalkduster")
        gameOverLabel.run(SKAction.scale(by: 2.0, duration: 1.0))
  }    
}
