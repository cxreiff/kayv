//
//  TrailComponent.swift
//  Myz
//
//  Created by Jax Reiff on 6/23/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class TrailComponent: GKComponent {
    
    // Constants
    private static let Duration: CGFloat = 0.4
    private static let Frequency: CGFloat = 16
    
    // Properties
    let emitter: SKEmitterNode
    
    init(scene: SKScene, node: SKSpriteNode, color: SKColor){
        self.emitter = SKEmitterNode()
        
        super.init()
        
        self.emitter.particleTexture = SKTexture(imageNamed: "trail")
        self.emitter.particleColor = color
        self.emitter.particleColorBlendFactor = 1.0
        self.emitter.particleSize = node.size
        self.emitter.particleBirthRate = TrailComponent.Frequency
        self.emitter.particleLifetime = TrailComponent.Duration
        self.emitter.particleAlphaSpeed = (-1 / TrailComponent.Duration)
        self.emitter.particleZPosition = 0.6
        self.emitter.particleAlpha = 0.8
        self.emitter.targetNode = scene
        
        node.addChild(self.emitter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // Shrink particle respective to speed
        if let velocity = emitter.parent?.physicsBody?.velocity {
            self.emitter.particleScaleSpeed = -0.01 * (sqrt(pow(velocity.dx, 2) + pow(velocity.dy, 2)))
        }
        if let resting = self.emitter.parent?.physicsBody?.isResting {
            if resting {
                self.emitter.particleBirthRate = 0
            } else {
                self.emitter.particleBirthRate = TrailComponent.Frequency
            }
        }
    }
}
