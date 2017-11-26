//
//  GameScene.swift
//  SwiftML
//
//  Created by Qualan Woodard on 11/24/17.
//  Copyright © 2017 Qualan Woodard. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    
    
    func generatePoints(n: Int) -> [(x:Double, y: Double)] {
        var points:[(x:Double, y: Double)]! = []
        for _ in 0..<n {
            let random_x = Double(CGFloat.random(min: 0, max: 50))
            let random_y = Double(CGFloat.random(min: 0, max: 50))
            points.append((x: random_x, y: random_y))
        }
        return points
    }

    override func didMove(to view: SKView) {
        var testplots:[Plot]! = []
        
        //create test plots
        let testplot1 = Plot(data: generatePoints(n: 15), label_color: SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0), label_marker: "+")
        testplot1.series_name = "blue"
        let testplot2 = Plot(data: generatePoints(n: 15), label_color: SKColor(calibratedRed: 0.949, green: 0.7804, blue: 0.2824, alpha: 1.0), label_marker: "+")
        testplot2.series_name = "yellow"
        let testplot3 = Plot(data: generatePoints(n: 15), label_color: SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0), label_marker: "+")
        testplot3.series_name = "magenta"
        
        //add testplots to graph and setup other peripherals
        testplots.append(testplot1)
        testplots.append(testplot2)
        testplots.append(testplot3)
        let testgraph = Graph(height: 400, width: 600, plots: testplots, squeeze: 0.8)
        testgraph.x_label = "random x"
        testgraph.y_label = "random y"
        testgraph.addLabels()
        testgraph.addLegend()
        
        
        self.addChild(testgraph)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}


