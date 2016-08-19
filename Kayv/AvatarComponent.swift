//
//  AvatarComponent.swift
//  Myz
//
//  Created by Jax Reiff on 6/19/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import SpriteKit
import GameplayKit

class AvatarComponent: GKComponent {
    
    // Constants
    static let Key = "pixels"
    static let DocumentsDirectory = FileManager().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("player")
    
    static let TileColors = [SKColor.clear(), SKColor.cyan(), SKColor.magenta(), SKColor.yellow()]
    
    // Properties
    var pixels: [[Int]]
    var tiles: [[SKShapeNode?]]
    
    // Initialization
    init(pixels: [[Int]], node: SKSpriteNode) {
        self.pixels = pixels
        self.tiles = [[nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil]]
        super.init()
        self.initializeTiles(node)
    }
    convenience init(node: SKSpriteNode) {
        self.init(pixels: [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], node: node)
    }
    
    private func initializeTiles(_ node: SKSpriteNode) {
        for (rownum, row) in self.pixels.enumerated() {
            for (itemnum, item) in row.enumerated() {
                let tile = SKShapeNode(rect: CGRect(x: (node.size.width / 4) * CGFloat(rownum) - node.size.width / 2,
                    y: (node.size.height / 4) * CGFloat(itemnum) - node.size.width / 2,
                    width: node.size.width / 4, height: node.size.height / 4))
                tile.zPosition = -0.2
                tile.fillColor = AvatarComponent.TileColors[item]
                node.addChild(tile)
                tiles[rownum][itemnum] = tile
            }
        }
    }
    
    func setPixel(row: Int, col: Int, val: Int) {
        pixels[row][col] = val
        tiles[row][col]!.fillColor = AvatarComponent.TileColors[val]
        self.save()
    }
    func getPixel(row: Int, col: Int) -> Int {
        return pixels[row][col]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pixels = aDecoder.decodeObject(forKey: AvatarComponent.Key) as! [[Int]]
        self.tiles = [[nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil]]
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.pixels, forKey: AvatarComponent.Key)
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: AvatarComponent.ArchiveURL.path!)
        if !isSuccessfulSave { print("error: failed to save player avatar") }
    }
    
    class func loadAvatar(_ node: SKSpriteNode) -> AvatarComponent? {
        let avatar = NSKeyedUnarchiver.unarchiveObject(withFile: AvatarComponent.ArchiveURL.path!) as? AvatarComponent
        avatar?.initializeTiles(node)
        return avatar
    }
    
}
