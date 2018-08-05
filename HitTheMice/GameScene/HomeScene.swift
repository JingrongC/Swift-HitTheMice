//
//  HomeScene.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-10.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class HomeScene:Scene {
  override func didMove(to view: SKView) {      
    let gameLabel = SKLabelNode()
    gameLabel.text = gameGrade.description
    gameLabel.fontSize = gameScreenWidth*0.1
    //Indicate coming soon for Normal and Hard level
    if gameGrade.description != "Easy" {
        gameLabel.text = "\(gameGrade.description) (Coming next version...)"
        gameLabel.fontSize = gameScreenWidth*0.05
    }
    addLabel(parentNode: self, node: gameLabel, position:CGPoint(x: 0,y: gameScreenHeight*0.4) , fontSize: gameLabel.fontSize, fontColor: SKColor.red, name: "gameGradeLabel", text:gameLabel.text!, fontName: "Chalkduster")
    
    let leftArrow = SKSpriteNode(imageNamed: "LeftArrow")
    addButton(parentNode: self, node: leftArrow, nodeName: "LeftArrow", position: CGPoint(x: -gameScreenWidth*0.5 + leftArrow.frame.width*0.5,y: 0))
      
      let rightArrow = SKSpriteNode(imageNamed: "RightArrow")
    addButton(parentNode: self, node: rightArrow, nodeName: "RightArrow", position: CGPoint(x: gameScreenWidth*0.5 - rightArrow.frame.width*0.5,y: 0))

//        //Add Game Title
//        let gameTitle = SKLabelNode()
//        addLabel(parentNode: self, node: gameTitle, position: CGPoint(x: 0, gameScreenHeight*0.51), fontSize: gameScreenWidth*0.1, fontColor: SKColor.black, name: "GameTitle", text: "Hit The Mice", fontName: "Chalkduster")
        var innerDict = NSDictionary()
//        var scoreForEachLevel = [Int]()
        var scoreInTotal = 0
      innerDict = readFromPLForPlayer(player:currentPlayer)
      scoreInTotal = innerDict.value(forKey: "ScoreInTotal") as! Int

        let scoreLabel = SKLabelNode()
        addLabel(parentNode: self, node: scoreLabel, position: CGPoint(x: 0,y: -gameScreenHeight*0.45), fontSize: gameScreenWidth*0.05, fontColor: SKColor.red, name: "Score", text: "Score:\(scoreInTotal)", fontName: "Chalkduster")
      let scoreForEachLevel = innerDict.value(forKey:gameGrade.description) as! [Int]
        //Add tag base on score
        var previouSavedCheeses = 0
        for (idx,savedCheeses) in scoreForEachLevel.enumerated() {
            var levelTag = LevelTag()
            switch savedCheeses {
            case 1:
                levelTag = LevelTag(imageName:"Star1")
            case 2:
                levelTag = LevelTag(imageName:"Star2")
            case 3:
                levelTag = LevelTag(imageName:"Star3")
            case 4:
                levelTag = LevelTag(imageName:"Star4")
            case 5:
                levelTag = LevelTag(imageName:"Star5")
            default:
                if gameGrade.description != "Easy" {
                    levelTag = LevelTag(imageName:"Lock")
                } else if previouSavedCheeses != 0 || idx == 0  {
                       levelTag = LevelTag(imageName:"LevelMiceTag")
                    } else {
                       levelTag = LevelTag(imageName:"Lock")
                    }
                }
            previouSavedCheeses = savedCheeses
            let (column,row) = columnRow(index:idx,maxColumn:maxColumn)
            let tagGap = CGSize(width: gameScreenWidth*0.8/CGFloat(maxColumn),height: gameScreenHeight*0.8/CGFloat(maxRow))
            let tagPosition = pointFor(column: column,row: row,tagSize: tagGap)
            levelTag.presentDelegate = presentDelegate
            levelTag.addToScene(atLayer: self, atPosition: tagPosition)
            //Add level label
            let levelLabel = SKLabelNode()
            let labelName = String(idx+1)
            let labelPosition = CGPoint.zero
            addLabel(parentNode: levelTag, node: levelLabel, position:labelPosition , fontSize: levelTag.size.width*0.5, fontColor: SKColor.yellow, name: labelName, text: labelName, fontName: "Chalkduster")
        }
    }
    
    func columnRow(index:Int,maxColumn:Int) -> (Int,Int) {
        let row = index/maxColumn
        let column = index%maxColumn
        return (column,row)
    }
    
    func pointFor(column:Int,row:Int,tagSize:CGSize) -> CGPoint {
        let positionX = -tagSize.width*CGFloat(maxColumn/2) + tagSize.width*0.5 + tagSize.width*CGFloat(column)
        let positionY = tagSize.height*CGFloat(maxRow/2) - tagSize.height*0.5 - tagSize.height*CGFloat(row)
        return CGPoint(x: positionX,y: positionY)
    }
    
    //MARK: Touche Event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in:self)
        let touchedNode = atPoint(location)
        if let name = touchedNode.name {
            switch name {
            case "RightArrow":
                //                print("\(gameGrade.description)")
                var newRawValue = gameGrade.rawValue + 1
                if newRawValue == 3 {
                    newRawValue = 0
                }
                gameGrade = GameGrade(rawValue:newRawValue)!
                presentDelegate?.presentHomeScene(transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0))
            case "LeftArrow":
//                print("LeftArrow:\(gameGrade.rawValue)")
                var newRawValue = gameGrade.rawValue - 1
                if newRawValue == -1 {
                    newRawValue = 2
                }
                gameGrade = GameGrade(rawValue:newRawValue)!
                presentDelegate?.presentHomeScene(transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0))
            default:
                break
            }
        }
        
    }
    

    

}
