//
//  NextLevelButton.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-10-13.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class NextLevelButton:Button {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameLevel += 1
        presentDelegate!.presentGameScene()
    }
}
