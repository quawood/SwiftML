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
            //pure random
            let random_x = Double(CGFloat.random(min:0, max: 1))
            let random_y = Double(CGFloat.random(min:0, max: 1))
            
            
            
            //non-even circular distribution
//            let r = Double(CGFloat.random(min:0, max: 1))
            
            //even circular distribution
//            let r = sqrt(Double(CGFloat.random(min:0, max: 1)))
//            
//            let angle = Double(CGFloat.random(min: 0, max: CGFloat(2*Double.pi)))
//            let random_x = r*cos(angle)
//            let random_y = r*sin(angle)
            points.append((x: random_x, y: random_y))
        }
        return points
    }

    override func didMove(to view: SKView) {
        var testplots:[Plot]! = []
        
        //create test data
        let testdata1:[(x:Double, y: Double)]! = generatePoints(n:6)
        let testdata2:[(x:Double, y: Double)]! = generatePoints(n:900)
        let testdata3:[(x:Double, y: Double)]! = generatePoints(n:900)
        
        //create test plots from test data
        let testplot1 = Plot(data: testdata1, label_color: SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0), label_marker: "o")
        testplot1.series_name = "blue"
        
        let testplot2 = Plot(data: testdata2, label_color: SKColor(calibratedRed: 0.949, green: 0.7804, blue: 0.2824, alpha: 1.0), label_marker: "+")
        testplot2.series_name = "yellow"
        let testplot3 = Plot(data: testdata3, label_color: SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0), label_marker: "+")
        testplot3.series_name = "magenta"
        
        testplots.append(testplot1)
//        testplots.append(testplot2)
//        testplots.append(testplot3)


        //create regressions for test plots
        let regression = createRegression(data: testdata1, degree: 4)
        testplots.append(regression)
//
//        let regression2 = createRegression(data: testdata2, degree: 2, color: SKColor(calibratedRed: 0.949-0.7, green: 0.7804-0.7, blue: 0, alpha: 1.0))
//        testplots.append(regression2)
//
//        let regression3 = createRegression(data: testdata3, degree: 2, color: SKColor(calibratedRed: 0.8863-0.6, green: 0.4706-0.6, blue: 0.6078-0.6, alpha: 1.0))
//        testplots.append(regression3)

        //add graph
        let testgraph = Graph(height: 400, width: 600, plots: testplots, squeeze: 0.8)
        testgraph.x_label = "random x"
        testgraph.y_label = "random y"
        testgraph.addLabels()
        testgraph.addLegend()
        
        self.addChild(testgraph)

        
    }
    
    func createRegression(data: [(x:Double, y: Double)], degree: Int, color: SKColor? = nil) -> Plot {
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
        if let color = color {
            lineplot.label_color = color
        }
        
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


