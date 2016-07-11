//
//  GameScene.swift
//  Kayv
//
//  Created by Jax Reiff on 7/9/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    static let frequency: CGFloat = 4.0
    static let duration: CGFloat = 2.0
    
    var initialTilt: CGFloat?
    
    private var entityManager: EntityManager!
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var corridor: SKEmitterNode!
    private var crosshairX: SKSpriteNode!
    private var crosshairY: SKSpriteNode!
    
    private var motionManager: CMMotionManager!
    
    private var focus: CGPoint { get { return CGPoint(x: (crosshairX?.position.x)!, y: (crosshairY?.position.y)!) } }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black()
        
        self.entityManager = EntityManager(scene: self)
        
        self.corridor = SKEmitterNode()
        self.corridor.particleTexture = SKTexture(imageNamed: "corridor")
        self.corridor.particleBirthRate = GameScene.frequency
        self.corridor.particleLifetime = GameScene.duration
        self.corridor.particleAlpha = 0.0
        self.corridor.particleAlphaSpeed = 1.0 / GameScene.duration
        self.corridor.particleScaleSpeed = 2.0 / GameScene.duration
        
        self.crosshairX = SKSpriteNode(imageNamed: "crosshairX")
        self.crosshairY = SKSpriteNode(imageNamed: "crosshairY")
        self.crosshairX.size = CGSize(width: 4, height: self.frame.height)
        self.crosshairY.size = CGSize(width: self.frame.width, height: 4)
        self.crosshairX.constraints = [SKConstraint.positionX(SKRange(lowerLimit: self.frame.minX, upperLimit: self.frame.maxX))]
        self.crosshairY.constraints = [SKConstraint.positionY(SKRange(lowerLimit: self.frame.minY, upperLimit: self.frame.maxY))]
        
        self.motionManager = CMMotionManager()
        self.motionManager.startAccelerometerUpdates()
        if let tiltData = motionManager.accelerometerData { self.initialTilt = CGFloat(tiltData.acceleration.y) }
        
        self.addChild(corridor)
        self.addChild(crosshairX)
        self.addChild(crosshairY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        let dt = currentTime - self.lastUpdateTime
        
        entityManager.update(dt)
        
        self.lastUpdateTime = currentTime
        
        if let tiltData = motionManager.accelerometerData {
            if initialTilt == nil { self.initialTilt = CGFloat(tiltData.acceleration.y) }
            crosshairX?.position.x += CGFloat(tiltData.acceleration.x) * 16
            crosshairY?.position.y += (CGFloat(tiltData.acceleration.y) - initialTilt!) * 16
        }
    }
}
