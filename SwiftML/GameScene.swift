//
//  GameScene.swift
//  SwiftML
//
//  Created by Qualan Woodard on 11/24/17.
//  Copyright © 2017 Qualan Woodard. All rights reserved.
//

import SpriteKit
import GameplayKit
typealias dataTuple = [(x:Double, y: Double)]
class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    
    func generatePoints(n: Int) -> dataTuple {
        var points:[(x:Double, y: Double)]! = []
        for _ in 0..<(n/4) {
            //pure random
            let random_x = Double(CGFloat.random(min:0, max: 2))
            let random_y = Double(CGFloat.random(min:0, max: 2))
            points.append((x: random_x, y: random_y))
        }
        for _ in 0..<(n/4) {
            //pure random
            let random_x = Double(CGFloat.random(min:0, max: 2))
            let random_y = Double(CGFloat.random(min:2.5, max: 4.5))
            points.append((x: random_x, y: random_y))
        }
        for _ in 0..<(n/4) {
            //pure random
            let random_x = Double(CGFloat.random(min:2.5, max: 4.5))
            let random_y = Double(CGFloat.random(min:0, max: 2))
            points.append((x: random_x, y: random_y))
        }
        for _ in 0..<(n/4) {
            //pure random
            let random_x = Double(CGFloat.random(min:2.5, max: 4.5))
            let random_y = Double(CGFloat.random(min:2.5, max: 4.5))
            points.append((x: random_x, y: random_y))
        }

        return points
    }

    override func didMove(to view: SKView) {
        var testplots:[Plot]! = []
        var testdata1:dataTuple! = generatePoints(n: 100)
        let testplot1 = Plot(data: testdata1, label_color: SKColor(calibratedRed: 0.949, green: 0.7804, blue: 0.2824, alpha: 1.0), label_marker: "+")
        testplots.append(testplot1)
        
        
        let centroids = k_means(n: 4, data: Matrix(testdata1), max_iter: 10000).0
        var testdata2:dataTuple! = [(x: centroids[0][0], y: centroids[0][1]), (x: centroids[1][0], y: centroids[1][1]),(x: centroids[2][0], y: centroids[2][1]),(x: centroids[3][0], y: centroids[3][1])]
        let testplot2 = Plot(data: testdata2, label_color: SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0), label_marker: "o")
        testplots.append(testplot2)
        
        
//        var testdata3:dataTuple! = elbow_method(data: Matrix(testdata1), max_n: 10)
//        let testplot3 = Plot(data: testdata3, label_color: SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0), label_marker: "o")
//        testplots.append(testplot3)
        
        

        //add graph
        let testgraph = Graph(height: 400, width: 600, plots: testplots, squeeze: 0.8)
        testgraph.x_label = "random x"
        testgraph.y_label = "random y"
        testgraph.addLabels()
        testgraph.addLegend()
        
        self.addChild(testgraph)

        
        
    }
    
    func createRegression(dataSet: dataTuple, degree: Int, color: SKColor? = nil) -> Plot {
            let M = Matrix(dataSet)
            let xColumn = M.transpose().array[0]
            let yColumn = M.transpose().array[1]
            let X = mapFeatures(X:Matrix([xColumn]).transpose() , degree: degree)
            let y = Matrix([yColumn]).transpose()
            
            //gradient descent
            //let finaltheta = gradientDescent(X: X, y: y, initial_theta: Matrix.zeros(size: (degree+1,1)), learningRate: 0.0001, max_iterations: 100000)
            
            //normal equation
            let finaltheta = normalEquation(X: X, y: y)
        
           let lineplot = Plot(theta: finaltheta, line_color: SKColor.black)
        
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


// SKColor(calibratedRed: 0.949, green: 0.7804, blue: 0.2824, alpha: 1.0)
// SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0)
//SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0)
