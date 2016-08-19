//
//  Level.swift
//  Myz
//
//  Created by Jax Reiff on 6/20/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class Level: SKNode {
    
    private static let NumLevels = 5
    
    // Shuffler (highestValue should be equal to the number of levels)
    private static let Shuffler = GKShuffledDistribution(lowestValue: 1, highestValue: Level.NumLevels)
    
    let nodeSize: CGSize
    
    let wall: SKSpriteNode, wall_end: SKSpriteNode, wall_pipe: SKSpriteNode, wall_elbow: SKSpriteNode, wall_edge: SKSpriteNode

    var lowerEdge: CGFloat = 0
    
    init(scene: SKScene) {
        self.nodeSize = CGSize(width: scene.frame.width / 9, height: scene.frame.width / 9)
        
        self.wall = SKSpriteNode(imageNamed: "wall")
        self.wall.size = self.nodeSize
        self.wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        self.wall.physicsBody?.isDynamic = false
        self.wall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        
        self.wall_end = SKSpriteNode(imageNamed: "wall-end")
        self.wall_end.size = self.nodeSize
        self.wall_end.physicsBody = SKPhysicsBody(rectangleOf: wall_end.size)
        self.wall_end.physicsBody?.isDynamic = false
        self.wall_end.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        
        self.wall_pipe = SKSpriteNode(imageNamed: "wall-pipe")
        self.wall_pipe.size = self.nodeSize
        self.wall_pipe.physicsBody = SKPhysicsBody(rectangleOf: wall_pipe.size)
        self.wall_pipe.physicsBody?.isDynamic = false
        self.wall_pipe.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        
        self.wall_elbow = SKSpriteNode(imageNamed: "wall-elbow")
        self.wall_elbow.size = self.nodeSize
        self.wall_elbow.physicsBody = SKPhysicsBody(rectangleOf: wall_elbow.size)
        self.wall_elbow.physicsBody?.isDynamic = false
        self.wall_elbow.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        
        self.wall_edge = SKSpriteNode(imageNamed: "wall-edge")
        self.wall_edge.size = self.nodeSize
        self.wall_edge.physicsBody = SKPhysicsBody(rectangleOf: wall_elbow.size)
        self.wall_edge.physicsBody?.isDynamic = false
        self.wall_edge.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadLevel(scene: SKScene, levelID: Int) -> [GKEntity]? {
        if let levelPath = Bundle.main.pathForResource("level" + String(levelID), ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")
                var entities = [GKEntity]()
                for line in lines {
                    if (line.isEmpty) { break }
                    for (column, letter) in line.characters.enumerated() {
                        let xPos = nodeSize.width * (CGFloat(column) - 4)
                        let yPos = lowerEdge
                        let position = CGPoint(x: xPos, y: yPos)
                        switch letter {
                        case "x":
                            let node = wall.copy() as! SKSpriteNode
                            node.position = position
                            self.addChild(node)
                        case "|":
                            let node = wall_pipe.copy() as! SKSpriteNode
                            node.position = position
                            self.addChild(node)
                        case "-":
                            let node = wall_pipe.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI_2)
                            self.addChild(node)
                        case "^":
                            let node = wall_end.copy() as! SKSpriteNode
                            node.position = position
                            self.addChild(node)
                        case "v":
                            let node = wall_end.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI)
                            self.addChild(node)
                        case "<":
                            let node = wall_end.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI_2)
                            self.addChild(node)
                        case ">":
                            let node = wall_end.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI_2 * 3.0)
                            self.addChild(node)
                        case "{":
                            let node = wall_elbow.copy() as! SKSpriteNode
                            node.position = position
                            self.addChild(node)
                        case "}":
                            let node = wall_elbow.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI_2 * 3.0)
                            self.addChild(node)
                        case "\\":
                            let node = wall_elbow.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI_2)
                            self.addChild(node)
                        case "/":
                            let node = wall_elbow.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI)
                            self.addChild(node)
                        case "[":
                            let node = wall_edge.copy() as! SKSpriteNode
                            node.position = position
                            self.addChild(node)
                        case "]":
                            let node = wall_edge.copy() as! SKSpriteNode
                            node.position = position
                            node.zRotation = CGFloat(M_PI)
                            self.addChild(node)
                        case "e":
                            let size = CGSize(width: nodeSize.width - 2, height: nodeSize.height - 2)
                            let crate = Crate(scene: scene, size: size)
                            crate.sprite.node.physicsBody?.isDynamic = false
                            crate.sprite.node.physicsBody?.categoryBitMask = CollisionTypes.enemy.rawValue
                            crate.sprite.node.name = "crate"
                            crate.sprite.node.position = position
                            entities.append(crate)
                        default:
                            break
                        }
                    }
                    self.lowerEdge -= nodeSize.height
                }
                return entities
            }
        }
        return nil
    }
    
    func addLevel(scene: SKScene) -> [GKEntity]? {
        return self.loadLevel(scene: scene, levelID: self.children.isEmpty ? 0 : Level.Shuffler.nextInt())
    }
}

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case enemy = 4
}
