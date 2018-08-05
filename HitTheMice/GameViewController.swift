//
//  GameViewController.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-19.
//  Copyright (c) 2015 Jingrong Chen. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GoogleMobileAds

@objc class GameViewController: UIViewController,PresentSceneDelegate,GADBannerViewDelegate {  
  // MARK: - Properties
  let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
  lazy var skView=SKView()
  var sceneSize = CGSize()
  
  // MARK: - Initializers
  override func viewDidLoad() {
    super.viewDidLoad()
      
    // Initial Background Music
    if let backgroundMusic = Bundle.main.url(forResource: "gamePlay", withExtension: "mp3") {
      do {
        try backgroundMusicPlayer = AVAudioPlayer(contentsOf: backgroundMusic)
        backgroundMusicPlayer!.numberOfLoops = -1
      }
      catch {
        print("Music is not working!")
      }
    }

    // BannerView
    bannerView.delegate = self
    bannerView.isHidden = true
    bannerView.frame.origin.y=view.bounds.size.height-bannerView.frame.height
    view.addSubview(bannerView)
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    bannerView.load(GADRequest())
  
    // SKView
    skView = view as! SKView
    skView.ignoresSiblingOrder = true
    viewAspectRatio = skView.bounds.size.width/skView.bounds.size.height
    sceneSize = CGSize(width: 1104,height: 1472)
    gameScreenHeight = 1242
    gameScreenWidth  = 828
    let gameData = readFromPLForPlayer(player: currentPlayer)
    let score = gameData.value(forKey: "ScoreInTotal") as! Int
    if score == 0 {
       presentGameScene()
    } else {
      presentHomeScene(transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    if let currentScene = skView.scene as? GameScene {
      if soundState && !currentScene.gameLayer.isPaused {
        if backgroundMusicPlayer != nil {
          backgroundMusicPlayer!.play()
        }
      }
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  //MARK: - PresentSceneDelegate
  func presentGameScene() {
    let scene = GameScene(size:sceneSize)
    scene.presentDelegate = self
    let sceneTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
    skView.presentScene(scene, transition: sceneTransition)
  }
  
  func presentHomeScene(transition sceneTransition:SKTransition) {
    let scene = HomeScene(size:sceneSize)
    scene.presentDelegate = self
    let sceneTransition = sceneTransition
    skView.presentScene(scene, transition: sceneTransition)
  }
  
  func presentPassedScene(savedCheeses cheeses:Int) {
    let scene = GamePassedScene(size:sceneSize)
    scene.savedCheeses = cheeses
    scene.presentDelegate = self
    let sceneTransition = SKTransition.doorsCloseVertical(withDuration: 0.5)
    skView.presentScene(scene, transition: sceneTransition)
  }
  
  func presentGameOverScene() {
    let scene = GameOverScene(size:sceneSize)
    scene.presentDelegate = self
    let sceneTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
    skView.presentScene(scene, transition: sceneTransition)
  }

  // MARK: - GADBannerViewDelegate
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    bannerView.isHidden = false
  }

  func adViewWillPresentScreen(_ bannerView: GADBannerView) {
    backgroundMusicPlayer?.pause()
    if let gameScene = skView.scene {
      gameScene.isPaused = true
    }
  }

  func adViewDidDismissScreen(_ bannerView: GADBannerView) {
    if let gameScene = skView.scene {
      gameScene.isPaused = false
    }
  }

  func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    bannerView.isHidden = true
  }    
}


