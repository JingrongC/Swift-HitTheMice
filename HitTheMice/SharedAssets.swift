//
//  SharedAssets.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-08-10.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit
import AVFoundation

// MARK: - extension 
extension CGPoint {
    func distanceToPoint(point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
    
    func radiansToPoint(point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        
        return -atan2(deltaX, deltaY)
    }
}

extension SKNode {
    func startAnimation(repeatAction:[SKAction]) {
        if repeatAction.count != 0 {
            run(SKAction.repeatForever(SKAction.sequence(repeatAction)))
        }
    }
}

// MARK: - protocol
protocol PresentSceneDelegate {
    func presentGameScene()
    func presentHomeScene(transition sceneTrasition:SKTransition)
    func presentPassedScene(savedCheeses cheeses:Int)
    func presentGameOverScene()
}

// MARK: - Properties
var soundState = true
var gameLevel = 1
var currentPlayer = "User"
var gameGrade = GameGrade.Easy


// MARK: - Constants
let backgroundQueue = DispatchQueue(label: "JingrontChen.HitTheMice.backgroundQueue")
let maxColumn = 4
let maxRow = 6
let maxGameLevel = maxColumn*maxRow
let initialInnerDictionary = ["ScoreInTotal":0,GameGrade.Easy.description:Array(repeating: 0, count: maxGameLevel),GameGrade.Normal.description:Array(repeating: 0, count: maxGameLevel),GameGrade.Hard.description:Array(repeating: 0, count: maxGameLevel)] as [String : Any]
let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
let plistPath = urls[urls.count-1].appendingPathComponent("Data.plist").path
let maxCheesesCount = 5
let maxBallsCount = 3
let targetMovingDuration:TimeInterval = 8.0
let maxTargetsCount = 1
let impulseToBall:CGFloat = 150.0
var gameScreenWidth:CGFloat = 0
var gameScreenHeight:CGFloat = 0
var viewAspectRatio:CGFloat = 0
var backgroundMusicPlayer:AVAudioPlayer?

// MARK: - functions
func addLabel(parentNode:SKNode,node:SKLabelNode,position:CGPoint,fontSize:CGFloat,fontColor:SKColor,name:String,text:String,fontName:String)
{
  node.fontName = fontName
  node.name = name
  node.text = text
  node.fontSize = fontSize
  node.fontColor = fontColor
  node.position = position
  parentNode.addChild(node)
}

func addButton(parentNode:SKNode,node:SKSpriteNode,nodeName:String,position:CGPoint) {
  node.name = nodeName
  node.position = position
  parentNode.addChild(node)
}

func playSound(node:SKNode,contactState:PlaySound) {
  if soundState {
    backgroundQueue.async(execute: {node.run(contactState.action())})
  }
}

// MARK: - GameData
// Retrieve data from property list; Create a new file if property list file not exist.
func readFromPLForPlayer(player:String) -> NSDictionary {
  var rootObj = NSMutableDictionary()
  if !FileManager.default.fileExists(atPath: plistPath) {
    rootObj.setValue(initialInnerDictionary, forKey: player)
    //Save to file if file not exists
    do {
      let plist = try PropertyListSerialization.data(fromPropertyList: rootObj, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0))
      try plist.write(to: URL(fileURLWithPath: plistPath))
    }
    catch {
      print("Error in creating PL")
    }
  }
  
  if let XMLData = NSData(contentsOfFile: plistPath) {
    do {
      rootObj = try PropertyListSerialization.propertyList(from: XMLData as Data, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! NSMutableDictionary
    }
    catch {
      print("Error in reading PL")
    }
  }
  return rootObj.value(forKey: player) as! NSDictionary
}

//Update data in property list
func writeToPLForPlayer(player:String,values:NSDictionary) {
  //Retrieve original data before appending
  var rootObj = NSMutableDictionary()
  if let XMLData = NSData(contentsOfFile: plistPath) {
    do {
      rootObj = try PropertyListSerialization.propertyList(from: XMLData as Data, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! NSMutableDictionary
    }
    catch {
      print("Error in reading PL")
    }
  }
  //Update data and save to file
  rootObj.setValue(values, forKey: player)
  do {
    let plist = try PropertyListSerialization.data(fromPropertyList: rootObj, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0))
    try plist.write(to: URL(fileURLWithPath: plistPath))
  }
  catch {
    print("Error in creating PL")
  }
}

// MARK: enum
enum SceneLayer:CGFloat {
  case Background = -1,GamePlay=0,Function=1
}

enum CategoryBitMask: UInt32 {
  case Ball = 1
  case Target = 2
  case Edge = 4
  case Bottom = 8
  case Paddle = 16
  case Obstacle = 32
  case Cheese = 64
  
  static var allButCheese = CategoryBitMask.Ball.rawValue | CategoryBitMask.Target.rawValue | CategoryBitMask.Bottom.rawValue | CategoryBitMask.Paddle.rawValue | CategoryBitMask.Obstacle.rawValue | CategoryBitMask.Edge.rawValue
  
  static var allButCheeseAndBottom = CategoryBitMask.Ball.rawValue | CategoryBitMask.Target.rawValue | CategoryBitMask.Obstacle.rawValue | CategoryBitMask.Paddle.rawValue | CategoryBitMask.Edge.rawValue
}

enum PlaySound {
  case GameOver,HitPaddle, HitTarget, HitObstacle,EatCheese,GamePassed,Balloonpop,Congrats,GamePlayScene
  func action() -> SKAction {
    switch self {
      case .GameOver:
        return SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: false)
      case .HitPaddle:
        return SKAction.playSoundFileNamed("paddle.caf", waitForCompletion: false)
      case .HitTarget:
        return SKAction.playSoundFileNamed("targetHit.caf", waitForCompletion: false)
      case .HitObstacle:
        return SKAction.playSoundFileNamed("obstacle.wav", waitForCompletion: false)
      case .EatCheese:
        return SKAction.playSoundFileNamed("eatCheese.wav", waitForCompletion: false)
      case .GamePassed:
        return SKAction.playSoundFileNamed("LevelUp.wav", waitForCompletion: false)
      case .Balloonpop:
        return SKAction.playSoundFileNamed("Balloonpop.wav", waitForCompletion: false)
      case .Congrats:
        return SKAction.playSoundFileNamed("congrats.wav", waitForCompletion: false)
      case .GamePlayScene:
        return SKAction.playSoundFileNamed("gamePlay.mp3", waitForCompletion: false)
    }
  }
}

enum GameGrade:Int {
  case Easy=0,Normal,Hard
  var impulseToBall:CGFloat {
    switch self {
    case .Easy:
      return 100.0
    case .Normal:
      return 150.0
    case .Hard:
      return 200.0
    }
  }
  var targetMovingDuration:TimeInterval {
    switch self {
    case .Easy:
      return 1
    case .Normal:
      return 0.5
    case .Hard:
      return 0.5
    }
  }
  var description:String {
    switch self {
    case .Easy:
      return "Easy"
    case .Normal:
      return "Normal"
    case .Hard:
      return "Hard"
    }
  }
  var numberOfTargetsAndBalls:(Int,Int) {
    switch self {
    case .Easy:
      return (1,3)
    case .Normal:
      return (2,5)
    case .Hard:
      return (3,6)
    }
  } 
}
