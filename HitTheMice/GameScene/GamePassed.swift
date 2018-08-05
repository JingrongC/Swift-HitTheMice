//
//  LevelUpScene.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-16.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class GamePassedScene:Scene {
  var savedCheeses = Int()
  override func didMove(to view: SKView) {
    // Post ads after certain seconds
    let gameData = readFromPLForPlayer(player:currentPlayer)
    var scoreForEachLevel = gameData.value(forKey: gameGrade.description) as! [Int]
    var scoreInTotal = 0
    let previousSavedCheeses = scoreForEachLevel[gameLevel-1]
    if previousSavedCheeses < savedCheeses {
        scoreForEachLevel[gameLevel-1] = savedCheeses
        gameData.setValue(scoreForEachLevel, forKey: gameGrade.description)
    }
    for savedCheeses in scoreForEachLevel {
        scoreInTotal = scoreInTotal + savedCheeses
    }
    gameData.setValue(scoreInTotal, forKey: "ScoreInTotal")
    writeToPLForPlayer(player: currentPlayer, values: gameData)
      
    //Check if reach maximum level
    if gameLevel < maxGameLevel {
      playSound(node: self, contactState: .GamePassed)
      backgroundColor = SKColor.blue
      //Add button
      let backToHome = BackToHomeButton(imageName:"Home")
      backToHome.presentDelegate = presentDelegate
      backToHome.addToScene(atLayer: self, atPosition: CGPoint(x: -backToHome.frame.width, y: -backToHome.frame.height))
    
      
      let replay = ReplayButton(imageName: "Replay")
      replay.presentDelegate = presentDelegate
      replay.addToScene(atLayer: self, atPosition: CGPoint(x: 0, y: backToHome.position.y))
      
      let nextLevel = NextLevelButton(imageName: NSLocalizedString("Next", comment: ""))
      nextLevel.presentDelegate = presentDelegate
      nextLevel.addToScene(atLayer: self, atPosition: CGPoint(x: replay.frame.width,y: backToHome.position.y))
    
      let scoreState = SKLabelNode()
      if savedCheeses >= 5 {
         scoreState.text = "Excellent!"
      } else {
         scoreState.text = "Good Job!"
      }
      addLabel(parentNode: self, node:scoreState,position: CGPoint(x:0,y:backToHome.position.y + backToHome.frame.height),fontSize: gameScreenWidth*0.08,fontColor: SKColor.red,name: "scoreState",text: scoreState.text!,fontName: "Chalkduster")
      scoreState.run(SKAction.scale(by: 2.0, duration: 1.0))
      for cheeseOrder in 0...savedCheeses-1 {
        let cheese = Cheese()
        cheese.xScale = 2.0
        cheese.yScale = 2.0
        cheese.position = CGPoint(x:(-2.5+CGFloat(cheeseOrder))*cheese.frame.width,y:backToHome.frame.height + cheese.frame.height*2.0)
        addChild(cheese)
      }
    } else {
      // Add congrats page if gameLevel reach maximum
      playSound(node: self, contactState: .Congrats)
      
      // Add button
      let backToHome = BackToHomeButton(imageName:"Home")
      let comments = SKLabelNode()
      comments.text = "You have passed all levels."
      addLabel(parentNode: self, node:comments,position:CGPoint.zero,fontSize: gameScreenWidth*0.06,fontColor: SKColor.red,name: "comments",text: comments.text!,fontName: "Chalkduster")
        let scoreState = SKLabelNode()
        scoreState.text = "Congrats!"
      addLabel(parentNode: self, node:scoreState,position: CGPoint(x: 0,y: comments.position.y + backToHome.frame.height),fontSize: gameScreenWidth*0.08,fontColor: SKColor.red,name: "scoreState",text: scoreState.text!,fontName: "Chalkduster")
      scoreState.run(SKAction.scale(by: 2.0, duration: 1.0))
        backToHome.presentDelegate = presentDelegate
        backToHome.addToScene(atLayer: self, atPosition: CGPoint(x: 0,y: comments.position.y-backToHome.frame.height))
    }
  }
}
