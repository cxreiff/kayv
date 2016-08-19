//
//  MenuScene.swift
//  Myz
//
//  Created by Jax Reiff on 5/22/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    
    private var player: Player!, starfield: ParallaxField.Starfield!
    
    private let caveButton: SKSpriteNode, spaceButton: SKSpriteNode
    
    override init(size: CGSize) {
        
        caveButton = SKSpriteNode(texture: SKTexture(imageNamed: "start-button"), color: UIColor.clear(),
                                  size: CGSize(width: size.width / 3, height: size.height / 10))
        spaceButton = SKSpriteNode(texture: SKTexture(imageNamed: "start-button"), color: UIColor.clear(),
                                  size: CGSize(width: size.width / 3, height: size.height / 10))
        
        super.init(size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.backgroundColor = SKColor.black()
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: 0, y: self.frame.midY)
        self.camera = camera
        starfield = ParallaxField.Starfield(scene: self, star_size: CGSize(width: 2, height: 2), star_count: 32)
        starfield.alpha = 0.0
        
        player = Player(scene: self, size: CGSize(width: self.size.height / 3, height: self.size.height / 3))
        player.sprite.node.physicsBody?.isDynamic = false
        player.sprite.node.position = CGPoint(x: 0, y: self.frame.midY + 20.0)
        player.sprite.node.alpha = 0.0
        player.trail.emitter.particleAlpha = 0.0
        
        caveButton.position = CGPoint(x: 0, y: self.size.height * (1 / 16))
        caveButton.alpha = 0.0
        caveButton.zPosition = 0.4
        spaceButton.position = CGPoint(x: 0, y: self.size.height * (15 / 16))
        spaceButton.alpha = 0.0
        spaceButton.zPosition = 0.4
        spaceButton.yScale = -1.0
        
        self.addChild(camera)
        self.addChild(starfield)
        self.addChild(caveButton)
        self.addChild(spaceButton)
        self.addChild(player.sprite.node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        caveButton.run(SKAction.moveTo(y: self.size.height * 1 / 6, duration: 0.4))
        caveButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.4))
        
        spaceButton.run(SKAction.moveTo(y: self.size.height * 5 / 6, duration: 0.4))
        spaceButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.4))
        
        player.sprite.node.run(SKAction.moveTo(y: self.frame.midY, duration: 0.4))
        player.sprite.node.run(SKAction.fadeAlpha(to: 1.0, duration: 0.4))
        
        starfield.run(SKAction.fadeAlpha(to: 0.6, duration: 0.8))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if caveButton.contains(location) { caveButton.alpha = 0.6 }
            if spaceButton.contains(location) { spaceButton.alpha = 0.6 }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if caveButton.contains(location) { caveButton.alpha = 0.6 }
            else { caveButton.alpha = 1.0 }
            if spaceButton.contains(location) { spaceButton.alpha = 0.6 }
            else { spaceButton.alpha = 1.0 }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if player.sprite.node.contains(location) {
                let loc = touch.location(in: player.sprite.node)
                let col = Int((loc.y + player.sprite.node.size.height / 2) * 4 / player.sprite.node.size.height)
                let row = Int((loc.x + player.sprite.node.size.width / 2) * 4 / player.sprite.node.size.width)
                if row < 0 || row >= 4 || col < 0 || col >= 4 { continue }
                let val = (player.avatar.getPixel(row: row, col: col) + 1) % AvatarComponent.TileColors.count
                player.avatar.setPixel(row: row, col: col, val: val)

            } else if caveButton.contains(location) {
                caveButton.run(SKAction.moveTo(y: self.size.height * 1 / 16, duration: 0.4))
                caveButton.run(SKAction.fadeOut(withDuration: 0.4))
                spaceButton.run(SKAction.fadeOut(withDuration: 0.4))
                player.trail.emitter.particleAlpha = 0.4
                player.sprite.node.physicsBody?.isDynamic = true
                self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.8)
            } else if spaceButton.contains(location) {
                spaceButton.run(SKAction.moveTo(y: self.size.height * 15 / 16, duration: 0.4))
                spaceButton.run(SKAction.fadeOut(withDuration: 0.4))
                caveButton.run(SKAction.fadeOut(withDuration: 0.4))
                player.trail.emitter.particleAlpha = 0.4
                player.sprite.node.physicsBody?.isDynamic = true
                self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 1.8)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.sprite.node.position.y < -232 {
            self.scene!.view?.presentScene(CaveScene(size: self.size), transition: SKTransition.fade(withDuration: 2.0))
        } else if player.sprite.node.position.y > self.frame.maxY + 232 {
            self.scene!.view?.presentScene(SpaceScene(size: self.size), transition: SKTransition.fade(withDuration: 2.0))
        }
        starfield.moveStars(52)
    }
}
