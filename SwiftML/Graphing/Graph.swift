//
//  Graph.swift
//  SwiftML
//
//  Created by Qualan Woodard on 11/24/17.
//  Copyright © 2017 Qualan Woodard. All rights reserved.
//

import Cocoa
import SpriteKit
import GameKit

class Graph: SKNode {
    var width: CGFloat! = 400
    var height: CGFloat! = 400
    var domain: ClosedRange! = 0.0...10.0
    var range: ClosedRange! = 0.0...10.0
    
    var x_label: String! = "x-axis" {
        didSet {
            //set up titles and labels
            for child in self.children{
                if child.name == "xtitle" {
                    child.removeFromParent()
                }
            }
            let xtitle = SKLabelNode(text: x_label)
            xtitle.name = "xtitle"
            xtitle.fontSize = 20
            xtitle.position = CGPoint(x: 0, y: (-height/2)-60)
            xtitle.fontColor = NSColor.black
            xtitle.fontName = "Thonburi"

            self.addChild(xtitle)

            
        }
    }
    var y_label: String! = "y-axis" {
        didSet {
            for child in self.children{
                if child.name == "ytitle" {
                    child.removeFromParent()
                }
            }
            let ytitle = SKLabelNode(text: y_label)
            ytitle.name = "ytitle"
            ytitle.fontSize = 20
            ytitle.position = CGPoint(x: (-width/2)-60, y: 0)
            ytitle.zRotation = CGFloat(Double.pi/2)
            ytitle.fontColor = NSColor.black
            ytitle.fontName = "Thonburi"
            
            self.addChild(ytitle)
            
        }
    }
    
    var plots: [Plot]?
    var squeeze: CGFloat?
    
    init(height: CGFloat, width: CGFloat) {
        super.init()
        self.height = height
        self.width = width
        
        //set up axes
        let graph_origin = CGPoint(x: -width/2, y: -height/2)
        var y_points = [graph_origin,
                       CGPoint(x:graph_origin.x, y: height + graph_origin.y)]
        var x_points = [graph_origin,
                       CGPoint(x:graph_origin.x + width, y: graph_origin.y)]
        let y_axis = SKShapeNode(points: &y_points, count: y_points.count)
        let x_axis = SKShapeNode(points: &x_points, count: x_points.count)
        y_axis.strokeColor = NSColor(calibratedRed:0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        y_axis.lineWidth = 3
        x_axis.strokeColor = NSColor(calibratedRed:0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        x_axis.lineWidth = 3
        self.addChild(y_axis)
        self.addChild(x_axis)
        
        //setup grdilines
        for i in 1...6 {
            var points = [CGPoint(x: CGFloat(i)*(width/6)-(width/2),y: -height/2 + 1), CGPoint(x: CGFloat(i)*(width/6)-(width/2),y:(-height/2)-10)]
            let tick = SKShapeNode(points: &points, count: points.count)
            tick.strokeColor = NSColor(calibratedRed:0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            tick.lineWidth = 2
            
            self.addChild(tick)
        }
        for i in 1...6 {
            var points = [CGPoint(x: -width/2 + 1, y: (-height/2) + CGFloat(i)*(height/6)), CGPoint(x:(-width/2)-10, y: (-height/2) + CGFloat(i)*(height/6))]
            let tick = SKShapeNode(points: &points, count: points.count)
            tick.strokeColor = NSColor(calibratedRed:0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            tick.lineWidth = 2
            self.addChild(tick)
        }

  
    }

    convenience init(height: CGFloat, width: CGFloat, plots: [Plot], squeeze: CGFloat) {
        self.init(height: height, width: width)
        self.plots = plots
        self.squeeze = squeeze
        let xlow = plots.map({($0 as Plot).x_range.lowerBound}).min()!
        let xhigh = plots.map({($0 as Plot).x_range.upperBound}).max()!
        let ylow = plots.map({($0 as Plot).y_range.lowerBound}).min()!
        let yhigh = plots.map({($0 as Plot).y_range.upperBound}).max()!
        self.domain = xlow...xhigh
        self.range = ylow...yhigh
        let x_dif = domain.upperBound - domain.lowerBound
        let y_dif = range.upperBound - range.lowerBound
        
        for plot in plots {
            for point in plot.data! {
                let x = point.x
                let y = point.y
                
                var marker = SKNode()
                marker = plot.label_marker?.copy() as! SKNode
                
                let pos = CGPoint(x: (x-domain.lowerBound)/x_dif, y: (y-range.lowerBound)/y_dif)
                marker.position = CGPoint(x: (squeeze*width)*(pos.x-0.5), y: (squeeze*height)*(pos.y-0.5))
                
                marker.removeFromParent()
                self.addChild(marker)
                
            }
        }
        
        
        
        
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



