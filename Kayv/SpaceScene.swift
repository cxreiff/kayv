//
//  GameScene.swift
//  Kayv
//
//  Created by Jax Reiff on 7/9/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpaceScene: SKScene {
    
    static var intensity: CGFloat = 0.0
    
    static var frequency: CGFloat = 6.0
    static var duration: CGFloat = 6.0
    
    static var lighter_blue = SKColor(hue: 0.56, saturation: 0.56, brightness: 1.0, alpha: 1.0)
    static var darker_blue = SKColor(hue: 0.56, saturation: 0.56, brightness: 0.64, alpha: 1.0)
    static var lighter_salmon = SKColor(hue: 0.0, saturation: 0.6, brightness: 1.0, alpha: 1.0)
    static var darker_salmon = SKColor(hue: 0.0, saturation: 0.6, brightness: 0.64, alpha: 1.0)
    static var lighter_magenta = SKColor(hue: 0.93, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    static var darker_magenta = SKColor(hue: 0.93, saturation: 1.0, brightness: 0.64, alpha: 1.0)
    
    private var lastUpdateTime : TimeInterval = 0
    private var timeElapsedSinceSpawn: TimeInterval = 0
    
    private var targetTouch: UITouch?
    
    private var entityManager: EntityManager!
    private var cam: SKCameraNode!
    
    private var corridor: SKEmitterNode!
    private var crosshair: Crosshair!
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black()
        
        self.entityManager = EntityManager(scene: self)
        self.cam = SKCameraNode()
        self.camera = cam
        
        self.crosshair = Crosshair(scene: self)
        
        self.corridor = SKEmitterNode()
        self.corridor.particleTexture = SKTexture(imageNamed: "corridor")
        self.corridor.particleBirthRate = SpaceScene.frequency
        self.corridor.particleLifetime = SpaceScene.duration
        self.corridor.particleColorBlendFactor = 1.0
        self.corridor.particleColor = SKColor.white()
        self.corridor.particleAlpha = 0.0
        self.corridor.particleAlphaSpeed = 1.0 / SpaceScene.duration
        self.corridor.particleScaleSpeed = 4.0 / SpaceScene.duration
        
        self.addChild(cam)
        self.addChild(corridor)
        self.addChild(crosshair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        targetTouch = touches.first!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dot = SKSpriteNode(imageNamed: "dot")
        dot.position = crosshair.position
        dot.colorBlendFactor = 1.0
        dot.color = arc4random_uniform(UInt32(2.0)) > UInt32(0) ? SpaceScene.lighter_salmon : SpaceScene.darker_salmon
        self.addChild(dot)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == targetTouch { targetTouch = nil }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        
        entityManager.update(dt)
        
        // Move crosshairs asymptotically towards touch, when touch lifts move back to center.
        if let location = targetTouch?.location(in: self) {
            crosshair.position.x += (location.x - crosshair.position.x) * 0.4
            crosshair.position.y += (location.y - crosshair.position.y) * 0.4
        } else {
            crosshair.position.x += (0.0 - crosshair.position.x) * 0.2
            crosshair.position.y += (0.0 - crosshair.position.y) * 0.2
        }
        
        cam.position = CGPoint(x: crosshair.position.x / 4.0, y: crosshair.position.y / 8.0)
        SpaceScene.intensity += 0.001
        if SpaceScene.intensity > 1.0 { }
    }
    
    class Crosshair: SKNode {
        private let crosshairX: SKSpriteNode
        private let crosshairY: SKSpriteNode
        
        init(scene: SKScene) {
            crosshairX = SKSpriteNode(imageNamed: "crosshairX")
            crosshairY = SKSpriteNode(imageNamed: "crosshairY")
            crosshairX.color = SKColor.white()
            crosshairY.color = SKColor.white()
            crosshairX.size = CGSize(width: 2, height: scene.frame.height * 2.0)
            crosshairY.size = CGSize(width: scene.frame.width * 2.0, height: 2)
            
            let emitterX = SKEmitterNode()
            emitterX.particleTexture = SKTexture(imageNamed: "crosshairX")
            emitterX.particleBirthRate = 32.0
            emitterX.particleLifetime = 0.1
            emitterX.particleSize = crosshairX.size
            emitterX.particleAlpha = 0.5
            emitterX.particleAlphaSpeed = -5
            emitterX.targetNode = scene
            
            let emitterY = SKEmitterNode()
            emitterY.particleTexture = SKTexture(imageNamed: "crosshairY")
            emitterY.particleBirthRate = 32.0
            emitterY.particleLifetime = 0.1
            emitterY.particleSize = crosshairY.size
            emitterY.particleAlpha = 0.5
            emitterY.particleAlphaSpeed = -5
            emitterY.targetNode = scene
            
            super.init()
            
            crosshairX.addChild(emitterX)
            crosshairY.addChild(emitterY)
            self.addChild(crosshairX)
            self.addChild(crosshairY)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
