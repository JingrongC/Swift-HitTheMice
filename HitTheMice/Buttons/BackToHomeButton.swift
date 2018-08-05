//
//  BackToHomeButton.swift
//  Hit The Mice
//
//  Created by Jingrong Chen on 2015-10-13.
//  Copyright © 2015 Jingrong Chen. All rights reserved.
//
//  Abstract:
//  
//


import SpriteKit

class BackToHomeButton:Button {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        presentDelegate!.presentHomeScene(transition:SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
}
