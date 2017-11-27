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
            let random_x = Double(Int.random(min: 0, max: 100))/10
            let random_y = Double(Int.random(min: 0, max: 100))/10
            points.append((x: random_x, y: random_y))
        }
        return points
    }

    override func didMove(to view: SKView) {
        var testplots:[Plot]! = []
        var testdata:[(x:Double, y: Double)]! = generatePoints(n: 3)
        
        //create test plots
        let testplot1 = Plot(data: testdata, label_color: SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0), label_marker: "+")
        testplot1.series_name = "blue"
        testplots.append(testplot1)
        
        let testplot2 = Plot(data: generatePoints(n: 3), label_color: SKColor(calibratedRed: 0.949, green: 0.7804, blue: 0.2824, alpha: 1.0), label_marker: "+")
        testplot2.series_name = "yellow"
        let testplot3 = Plot(data: generatePoints(n: 3), label_color: SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0), label_marker: "+")
        testplot3.series_name = "magenta"
        
        testplots.append(testplot2)
        testplots.append(testplot3)
        

        //use linear regression to find regression line for testplo1
            let regression = createRegression(data: testdata, degree: 2)
            regression.series_name = "degree \(2)"
            testplots.append(regression)

        //add graph
        let testgraph = Graph(height: 400, width: 600, plots: testplots, squeeze: 0.8)
        testgraph.x_label = "random x"
        testgraph.y_label = "random y"
        testgraph.addLabels()
        testgraph.addLegend()
        
        self.addChild(testgraph)

        
    }
    
    func createRegression(data: [(x:Double, y: Double)], degree: Int) -> Plot {
        let M = Matrix(data)
        let xColumn = M.transpose().array[0]
        let yColumn = M.transpose().array[1]
        let X = mapFeatures(X:Matrix([xColumn]).transpose() , degree: degree)
        let y = Matrix([yColumn]).transpose()
        
        //gradient descent
        //let finaltheta = gradientDescent(X: X, y: y, initial_theta: Matrix.zeros(size: (degree+1,1)), learningRate: 0.0001, max_iterations: 100000)
        
        //normal equation
        let finaltheta = normalEquation(X: X, y: y)
        let hypothesis:predictF! = hypothesis(x:theta:)
        let lineplot = Plot(function: hypothesis, theta:finaltheta, line_color: SKColor.black)
        return lineplot
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


