//
//  Plot.swift
//  SwiftML
//
//  Created by Qualan Woodard on 11/24/17.
//  Copyright © 2017 Qualan Woodard. All rights reserved.
//

import Cocoa
import SpriteKit
import GameKit
typealias predictF = (Double, Matrix) -> (Double)

class Plot: NSObject {
    var data: [(x: Double, y: Double)]?
    var label_color: SKColor! = SKColor.black
    var label_marker: SKNode?
    var series_name: String?
    var x_range: ClosedRange! = 0.0...1.0
    var y_range: ClosedRange! = 0.0...1.0

    var isLine: Bool! = false
    var coeff: Matrix? = Matrix.zeros(size: (2,1))
    
    
    init(data: [(x: Double, y: Double)], label_color: SKColor? = nil, label_marker: String? = nil) {
        super.init()

        self.data = data
        
        if let color = label_color {
            self.label_color = color
        } else {
            self.label_color = SKColor.black
        }
        
        
        self.label_marker = SKNode()
        switch label_marker! {
        case "+":
            let r = 6
            var y_points = [CGPoint(x:0,y:-r),CGPoint(x:0,y:r)]
            var x_points = [CGPoint(x:-r,y:0),CGPoint(x:r,y:0)]
            let y_line = SKShapeNode(points: &y_points, count: y_points.count)
            let x_line = SKShapeNode(points: &x_points, count: x_points.count)
            
            y_line.strokeColor = self.label_color
            y_line.lineWidth = 1
            x_line.strokeColor = self.label_color
            x_line.lineWidth = 1
            self.label_marker?.addChild(y_line)
            self.label_marker?.addChild(x_line)
        default:
            let circle = SKShapeNode(circleOfRadius: 4)
            circle.strokeColor = SKColor.clear
            circle.glowWidth = 1.0
            circle.fillColor = self.label_color!
            self.label_marker = circle as SKNode
        }
        var x_array:[Double]! = []
        var y_array:[Double]! = []
        
        data.forEach({point in
            x_array.append(point.0)
            y_array.append(point.1)
        })
        
        self.x_range = x_array.min()!...x_array.max()!
        self.y_range = y_array.min()!...y_array.max()!
    }
    
    init(theta: Matrix, line_color: SKColor? = nil) {
        super.init()
        self.isLine = true
        if line_color != nil {
            self.label_color = line_color
        }
        
        self.coeff = theta
        
        
        
    }
    
    
}



