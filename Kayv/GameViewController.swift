//
//  GameViewController.swift
//  Kayv
//
//  Created by Jax Reiff on 7/9/16.
//  Copyright © 2016 Jax Reiff. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
            view.presentScene(GameScene(size: view.bounds.size))
        }
    }
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main().bounds)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
