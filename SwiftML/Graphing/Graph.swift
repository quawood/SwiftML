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
    
    var x_label: String! = "x-axis" 
    var y_label: String! = "y-axis"

    var cropNode: SKCropNode!
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
        var x_points = [CGPoint(x:graph_origin.x-1,y:graph_origin.y),
                       CGPoint(x:graph_origin.x + width, y: graph_origin.y)]
        let y_axis = SKShapeNode(points: &y_points, count: y_points.count)
        let x_axis = SKShapeNode(points: &x_points, count: x_points.count)
        y_axis.strokeColor = NSColor.black
        y_axis.lineWidth = 1
        x_axis.strokeColor = NSColor.black
        x_axis.lineWidth = 1
        
        
        self.addChild(y_axis)
        self.addChild(x_axis)
        cropNode = SKCropNode()
        cropNode.maskNode = SKSpriteNode(color: NSColor.black, size: CGSize(width: width, height: height))
        cropNode.zPosition = 3
        self.addChild(cropNode)
        
        

        
  
    }

    convenience init(height: CGFloat, width: CGFloat, plots: [Plot], squeeze: CGFloat) {
        self.init(height: height, width: width)
        self.plots = plots
        self.squeeze = squeeze
        

        addPlots(plots: plots)
        
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLegend() {
        let rowh = 40
        let roww = 150
        let n = plots!.count
        let legendh = rowh*n
        let legend = SKShapeNode(rectOf: CGSize(width: roww, height: legendh))

        
        legend.position = CGPoint(x: (width/2) + CGFloat(roww/2), y: (height/2)-CGFloat(legendh/2))
        var c = 0
        for i in 0..<n {
            if plots![i].isLine {
                c = c + 1
            }
            var tick_points = [CGPoint(x:(-roww/2)+10,y:(legendh-rowh)/2 - (i*rowh)), CGPoint(x:(-roww/2)+30,y:(legendh-rowh)/2 - (i*rowh))]
            let tick = SKShapeNode(points: &tick_points, count: tick_points.count)
            tick.strokeColor = plots![i].label_color!
            tick.lineWidth = 3
            
            legend.addChild(tick)
            
            var plotLabel = SKLabelNode()
            if let name = plots![i].series_name {
                plotLabel = SKLabelNode(text: name)
            } else {
                if !plots![i].isLine {
                    plotLabel = SKLabelNode(text: "series \(i+1)")
                } else {
                    plotLabel = SKLabelNode(text: "Line \(c)")
                }
                
            }
            plotLabel.fontSize = 15
            plotLabel.fontColor = NSColor.black
            plotLabel.fontName = "Thonburi"
            plotLabel.position = CGPoint(x: -20+plotLabel.frame.width/2, y: CGFloat((legendh-rowh)/2 - (i*rowh)-5))
            
            legend.addChild(plotLabel)
            
            
        }
        legend.strokeColor = NSColor.gray
        legend.lineWidth = 1
        self.addChild(legend)
    }
    
    func addPlots(plots: [Plot]) {
        let non_lines = plots.filter({!$0.isLine})
        
        var xlow:Double! = 0
        var xhigh:Double! = 0
        var ylow:Double! = 0
        var yhigh:Double! = 0
        
        if non_lines.count != 0 {
            xlow = non_lines.map({($0 as Plot).x_range.lowerBound}).min()
            xhigh = non_lines.map({($0 as Plot).x_range.upperBound}).max()
            ylow = non_lines.map({($0 as Plot).y_range.lowerBound}).min()
            yhigh = non_lines.map({($0 as Plot).y_range.upperBound}).max()
        } else {
            xlow = plots.map({($0 as Plot).x_range.lowerBound}).min()
            xhigh = plots.map({($0 as Plot).x_range.upperBound}).max()
            ylow = plots.map({($0 as Plot).y_range.lowerBound}).min()
            yhigh = plots.map({($0 as Plot).y_range.upperBound}).max()
        }
        self.domain = xlow...xhigh
        self.range = ylow...yhigh
        let x_dif = domain.upperBound - domain.lowerBound
        let y_dif = range.upperBound - range.lowerBound
        
        for plot in plots {
            var linepoints: [CGPoint] = []
            if !plot.isLine {
                for point in plot.data! {
                    let x = point.x
                    let y = point.y
                    
                    var marker = SKNode()
                    marker = plot.label_marker?.copy() as! SKNode
                    
                    let pos = CGPoint(x: (x-domain.lowerBound)/x_dif, y: (y-range.lowerBound)/y_dif)
                    marker.position = CGPoint(x: (squeeze!*width)*(pos.x-0.5), y: (squeeze!*height)*(pos.y-0.5))
                    
                    marker.removeFromParent()
                    cropNode.addChild(marker)
                    
                }
            } else if plot.isLine{
                let x_step = x_dif/100
                for i in 0...100 {
                    let x = domain.lowerBound + Double(i)*x_step
                    let y = hypothesis(x: x, theta: plot.coeff!)
                    let pos = CGPoint(x: (x-domain.lowerBound)/x_dif, y: (y-range.lowerBound)/y_dif)
                    linepoints.append(CGPoint(x: squeeze!*(width)*(pos.x-0.5), y: squeeze!*(height)*(pos.y-0.5)))
                }
            }
            let curve = SKShapeNode(points: &linepoints, count: linepoints.count)
            curve.strokeColor = NSColor.black
            curve.lineWidth = 1
            curve.zPosition = 4
            cropNode.addChild(curve)

        }
    }
    
    func addLabels() {
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
        
        for child in self.children{
            if child.name == "ytitle" {
                child.removeFromParent()
            }
        }
        let ytitle = SKLabelNode(text: y_label)
        ytitle.name = "xtitle"
        ytitle.fontSize = 20
        ytitle.position = CGPoint(x:(-width/2)-60, y: 0)
        ytitle.fontColor = NSColor.black
        ytitle.fontName = "Thonburi"
        ytitle.zRotation = CGFloat(Double.pi/2)
        
        self.addChild(ytitle)


    }
    
}



