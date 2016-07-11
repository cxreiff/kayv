//
//  EntityManager.swift
//  Myz
//
//  Created by Jax Reiff on 6/20/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    weak var scene: SKScene!
    lazy var componentSystems: [GKComponentSystem] = {
        return []
    }()
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(withDeltaTime: deltaTime)
        }
        
        for entity in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(with: entity)
            }
        }
        toRemove.removeAll()
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(with: entity)
        }
    }
    func add(_ entities: [GKEntity]) {
        for entity in entities { self.add(entity) }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        toRemove.insert(entity)
        entities.remove(entity)
    }
    func removeAllEntities() {
        for entity in self.entities {
            remove(entity)
        }
    }
}