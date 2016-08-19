//
//  Invader.swift
//  kayv
//
//  Created by Jax Reiff on 8/16/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import GameplayKit

class Invader : GKEntity {
    
    override init() {
        super.init()
        
        let texture = SKTexture(imageNamed: "invader")
        self.addComponent(SpriteComponent(texture: texture, size: CGSize(width: 20.0, height: 20.0)))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
