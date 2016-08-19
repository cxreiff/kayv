//
//  Starfield.swift
//  Myz
//
//  Created by Jax Reiff on 6/26/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class ParallaxField: SKNode {
    
    // Constants
    static let speeds: [CGFloat] = [0.6, 0.4, 0.2]
    
    // Properties
    var field: [[SKSpriteNode]] = [[], [], []]
    
    init(scene: SKScene, image:  String, size: CGSize, count: Int) {
        super.init()
        for layer in 0..<field.count {
            for _ in 1...count {
                let speck = SKSpriteNode(imageNamed: image)
                let x_pos = CGFloat(Float(arc4random()) / Float(UINT32_MAX) - 0.5) * scene.frame.width
                let y_pos = CGFloat(Float(arc4random()) / Float(UINT32_MAX) - 0.5) * scene.frame.height
                speck.position = CGPoint(x: x_pos, y: (scene.camera?.position.y)! + y_pos)
                speck.size = size
                speck.zPosition = 0.2
                field[layer].append(speck)
                self.addChild(speck)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func moveStars(_ dy: CGFloat) {
        if let scene = self.scene {
            for (index, layer) in field.enumerated() {
                for star in layer {
                    star.run(SKAction.move(by: CGVector(dx: 0.0, dy: dy / 32 * Starfield.speeds[index]), duration: 0.4))
                    if star.position.y < (scene.camera?.position.y)! - scene.frame.height / 2 {
                        star.position.y += scene.frame.height
                    } else if star.position.y > (scene.camera?.position.y)! + scene.frame.height / 2 {
                        star.position.y -= scene.frame.height
                    } else { continue }
                    star.position.x = CGFloat(Float(arc4random()) / Float(UINT32_MAX) - 0.5) * scene.frame.width
                }
            }
        }
    }
    
    class Starfield: ParallaxField {
        init(scene: SKScene, star_size: CGSize, star_count: Int) {
            super.init(scene: scene, image: "star", size: star_size, count: star_count)
        }
        required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}
