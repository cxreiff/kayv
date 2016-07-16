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
    
    static let frequency: CGFloat = 6.0
    static let duration: CGFloat = 4.0
    
    private var initialTilt: CGFloat?
    private var lastUpdateTime : TimeInterval = 0
    private var timeElapsedSinceSpawn: TimeInterval = 0
    private var isTransitioning: Bool = false
    
    private var targetTouch: UITouch?
    
    private var entityManager: EntityManager!
    private var cam: SKCameraNode!
    
    private var corridor: SKEmitterNode!
    private var crosshairX: SKSpriteNode!
    private var crosshairY: SKSpriteNode!
    
    private var motionManager: CMMotionManager!
    
    private var focus: CGPoint { get { return CGPoint(x: crosshairX.position.x, y: crosshairY.position.y) } }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black()
        
        self.entityManager = EntityManager(scene: self)
        self.cam = SKCameraNode()
        self.camera = cam
        
        self.corridor = SKEmitterNode()
        self.corridor.particleTexture = SKTexture(imageNamed: "corridor")
        self.corridor.particleBirthRate = GameScene.frequency
        self.corridor.particleLifetime = GameScene.duration
        self.corridor.particleColorBlendFactor = 1.0
        self.corridor.particleColor = SKColor.white()
        self.corridor.particleAlpha = 0.0
        self.corridor.particleAlphaSpeed = 1.0 / GameScene.duration
        self.corridor.particleScaleSpeed = 4.0 / GameScene.duration
        
        self.crosshairX = SKSpriteNode(imageNamed: "crosshairX")
        self.crosshairY = SKSpriteNode(imageNamed: "crosshairY")
        self.crosshairX.color = SKColor.white()
        self.crosshairY.color = SKColor.white()
        self.crosshairX.size = CGSize(width: 4, height: self.frame.height * 2.0)
        self.crosshairY.size = CGSize(width: self.frame.width * 2.0, height: 4)
        self.crosshairX.constraints = [SKConstraint.positionX(SKRange(lowerLimit: self.frame.minX,
                                                                      upperLimit: self.frame.maxX))]
        self.crosshairY.constraints = [SKConstraint.positionY(SKRange(lowerLimit: self.frame.minY,
                                                                      upperLimit: self.frame.maxY))]
        
        self.motionManager = CMMotionManager()
        self.motionManager.startAccelerometerUpdates()
        if let tiltData = motionManager.accelerometerData { self.initialTilt = CGFloat(tiltData.acceleration.y) }
        
        self.addChild(cam)
        self.addChild(corridor)
        self.addChild(crosshairX)
        self.addChild(crosshairY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        targetTouch = touches.first!
        
        colorShift(red: 0.0, green: 1.0, blue: 1.0, duration: 4.0)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == targetTouch { targetTouch = nil }
            
            colorShift(red: 0.0, green: 0.0, blue: 0.0, duration: 4.0)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        let dt = currentTime - self.lastUpdateTime
        
        entityManager.update(dt)
        
        self.lastUpdateTime = currentTime
        
        if let location = targetTouch?.location(in: self) {
            crosshairX.position.x += (location.x - crosshairX.position.x) * 0.4
            crosshairY.position.y += (location.y - crosshairY.position.y) * 0.4
        }
        
//        if let tiltData = motionManager.accelerometerData {
//            if initialTilt == nil { self.initialTilt = CGFloat(tiltData.acceleration.y) }
//            crosshairX?.position.x += CGFloat(tiltData.acceleration.x) * 16
//            crosshairY?.position.y += (CGFloat(tiltData.acceleration.y) - initialTilt!) * 16
//        }
        
//        self.timeElapsedSinceSpawn += dt
//        if timeElapsedSinceSpawn > 30 {
//            self.addChild(SKSpriteNode(imageNamed: "corridor"))
//            self.timeElapsedSinceSpawn = 0
//        }
        
        if isTransitioning { corridor.particleColor = crosshairX.color }
        
        cam.position = CGPoint(x: crosshairX.position.x / 4.0, y: crosshairY.position.y / 8.0)
    }
    
    private func colorShift(red: CGFloat, green: CGFloat, blue: CGFloat, duration: TimeInterval) {
        isTransitioning = true
        let background = SKColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.run(SKAction.sequence([SKAction.colorize(with: background, colorBlendFactor: 1.0, duration: duration),
                                    SKAction.run({ self.isTransitioning = false })]))
        if (red + green + blue > 1.5) {
            crosshairX.run(SKAction.colorize(with: SKColor.black(), colorBlendFactor: 1.0, duration: duration))
            crosshairY.run(SKAction.colorize(with: SKColor.black(), colorBlendFactor: 1.0, duration: duration))
        } else {
            crosshairX.run(SKAction.colorize(with: SKColor.white(), colorBlendFactor: 1.0, duration: duration))
            crosshairY.run(SKAction.colorize(with: SKColor.white(), colorBlendFactor: 1.0, duration: duration))
        }
    }
}
