//
//  GameScene.swift
//  Myz
//
//  Created by Jax Reiff on 6/19/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class CaveScene: SKScene, SKPhysicsContactDelegate {
    
    // Whether to use accelerometer for gravity
    private static let Tilt = false
    
    // Properties
    var entityManager: EntityManager!
    var cam: SKCameraNode!
    var starfield: ParallaxField.Starfield!
    var player: Player!
    var level: Level!
    
    private var motionManager: CMMotionManager!
    private var gravityTouch: UITouch!
    private var lastUpdateTimeInterval: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        
        // Configure Scene
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        
        // Initialize Members
        
        self.entityManager = EntityManager(scene: self)

        self.cam = SKCameraNode()
        self.camera = self.cam
        
        starfield = ParallaxField.Starfield(scene: self, star_size: CGSize(width: 2, height: 2), star_count: 32)
        starfield.alpha = 0.8
        
        self.player = Player(scene: self, size: CGSize(width: self.size.width / 9 - 2, height: self.size.width / 9 - 2))
        self.player.sprite.node.position = CGPoint(x: frame.midX, y: 0)
        let left = self.frame.minX + player.sprite.node.size.width / 2.0
        let right = self.frame.maxX - player.sprite.node.size.width / 2.0
        self.player.sprite.node.constraints = [SKConstraint.positionX(SKRange(lowerLimit: left, upperLimit: right))]
        
        self.level = Level(scene: self)
        let newEntities = level.addLevel(scene: self)!
        
        if CaveScene.Tilt {
            self.motionManager = CMMotionManager()
            self.motionManager.startAccelerometerUpdates()
        }
        
        physicsWorld.contactDelegate = self
        
        // Add Members to Scene
        self.addChild(cam)
        self.addChild(starfield)
        self.addChild(level)
        entityManager.add(player)
        entityManager.add(newEntities)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player.sprite.node {
            playerCollidedWithNode(contact.bodyB.node!)
        } else if contact.bodyB.node == player.sprite.node {
            playerCollidedWithNode(contact.bodyA.node!)
        }
    }
    func playerCollidedWithNode(_ node: SKNode) {
        if node.name == "crate" {
            if let node = node as? SKSpriteNode {
                node.physicsBody?.isDynamic = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gravityTouch = touches.first!
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first! == gravityTouch { gravityTouch = touches.first! }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first! == gravityTouch { gravityTouch = nil }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.lastUpdateTimeInterval == 0 { self.lastUpdateTimeInterval = currentTime }
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        self.cam.position.y = player.sprite.node.position.y
        
        if let dy = player.sprite.node.physicsBody?.velocity.dy { starfield.moveStars(-dy / 16 + 52) }
        
        if let touch = gravityTouch { player.control.setTouch(touch) }
        
        if CaveScene.Tilt {
            if let tiltData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: tiltData.acceleration.x * 4, dy: tiltData.acceleration.y * 4)
            }
        }
        
        if player.sprite.node.position.y < level.lowerEdge + self.frame.height {
            if let newEntities = level.addLevel(scene: self) { entityManager.add(newEntities) }
        }
        
        entityManager.update(deltaTime)
    }
}
