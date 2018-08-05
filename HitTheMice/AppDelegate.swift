//
//  AppDelegate.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-07-19.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var musicWasPlayingBeforeEnterBackground = false
  
  private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    if backgroundMusicPlayer != nil {
        musicWasPlayingBeforeEnterBackground = backgroundMusicPlayer!.isPlaying
        backgroundMusicPlayer!.pause()
    }
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    if musicWasPlayingBeforeEnterBackground {
      if backgroundMusicPlayer != nil {
          backgroundMusicPlayer!.play()
      }
    }
  }

}

