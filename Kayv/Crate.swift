//
//  Enemy.swift
//  Myz
//
//  Created by Jax Reiff on 6/24/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class Crate: GKEntity {
    
    let sprite: SpriteComponent
    
    init(scene: SKScene, size: CGSize) {
        self.sprite = SpriteComponent(texture: SKTexture(imageNamed: "crate"), size: size)
        let trail = TrailComponent(scene: scene, node: sprite.node, color: SKColor.red())
        
        super.init()
        
        sprite.node.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.node.physicsBody?.allowsRotation = false
        trail.emitter.particleColor = SKColor.red()
        trail.emitter.particleLifetime = 100.0
        
        self.addComponent(sprite)
        self.addComponent(trail)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
