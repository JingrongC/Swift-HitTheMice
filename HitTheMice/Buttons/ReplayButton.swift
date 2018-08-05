//
//  ReplayButton.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-10-13.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//

import SpriteKit

class ReplayButton:Button {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        presentDelegate!.presentGameScene()
    }
}
