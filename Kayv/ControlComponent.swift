//
//  TapMoveComponent.swift
//  Myz
//
//  Created by Jax Reiff on 6/23/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class ControlComponent: GKComponent {
    
    private let force: CGFloat
    private weak var scene: SKScene?
    private var touch: UITouch?
    
    init(scene: SKScene, force: CGFloat) {
        self.scene = scene
        self.force = force
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTouch(_ touch: UITouch) {
        self.touch = touch
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let touch = self.touch, let scene = self.scene, let node = self.entity?.component(ofType: SpriteComponent.self)?.node {
            var movement = ControlComponent.touchVectorInScene(scene, touch: touch, center: node.position)
            movement.dx = movement.dx * self.force
            movement.dy = movement.dy * self.force
            node.physicsBody?.velocity = movement
            self.touch = nil
        }
    }
    
    private class func touchVectorInScene(_ scene: SKScene, touch: UITouch, center: CGPoint)-> CGVector {
        let dx = (touch.location(in: scene).x - center.x)
        let dy = (touch.location(in: scene).y - center.y)
        let magnitude = sqrt(pow(dx, 2) + pow(dy, 2))
        return CGVector(dx: dx / magnitude, dy: dy / magnitude)
    }
}
