//
//  SpriteComponent.swift
//  Myz
//
//  Created by Jax Reiff on 6/19/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: UIColor.white, size: size)
        node.zPosition = 1
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
