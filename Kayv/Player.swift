//
//  Player.swift
//  Myz
//
//  Created by Jax Reiff on 6/19/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    // Shortcuts to Components
    let sprite: SpriteComponent
    let avatar: AvatarComponent
    let control: ControlComponent
    let trail: TrailComponent
    
    init(scene: SKScene, size: CGSize) {
        self.sprite = SpriteComponent(texture: (SKTexture(imageNamed: "player")), size: size)
        self.control = ControlComponent(scene: scene, force: 256 )
        self.trail = TrailComponent(scene: scene, node: self.sprite.node, color: SKColor.white())
        
        if let loadedAvatar = AvatarComponent.loadAvatar(sprite.node) {
            self.avatar = loadedAvatar
        } else {
            self.avatar = AvatarComponent(node: self.sprite.node)
        }
        
        super.init()
        
        self.sprite.node.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.sprite.node.physicsBody?.linearDamping = 0.75
        self.sprite.node.physicsBody?.allowsRotation = false
        self.sprite.node.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        self.sprite.node.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
        self.sprite.node.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue | CollisionTypes.enemy.rawValue
        
        self.addComponent(sprite)
        self.addComponent(control)
        self.addComponent(trail)
        self.addComponent(avatar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
