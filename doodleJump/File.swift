//
//  File.swift
//  doodleJump
//
//  Created by  on 1/4/23.
//

import Foundation
import SpriteKit

    class MyScene:SKScene{
        var start = SKLabelNode()
        override func didMove(to view: SKView) {
            start = childNode(withName: "start")! as! SKLabelNode

        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let location = touches.first?.location(in: self)
            let gameScene = SKScene(fileNamed: "GameScene")!
            let transition = SKTransition.fade(with: .white, duration: 5)
//            if start?.contains(location)
            view?.presentScene(gameScene, transition: transition)
        }
    }

