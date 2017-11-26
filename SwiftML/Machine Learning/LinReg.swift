//
//  LinReg.swift
//  SwiftML
//
//  Created by Qualan Woodard on 11/25/17.
//  Copyright © 2017 Qualan Woodard. All rights reserved.
//

import Foundation


func cost(X: Matrix, y: Matrix, theta: Matrix) -> Double {
    let h = X <*> theta
    let m = Double(X.rows)
    
    let cost = 0.5*(1/m)*h.pow(2).sum()
    return cost
}

func gradient(X: Matrix, y: Matrix, theta: Matrix) -> Matrix {
    let h = X <*> theta
    let m = Double(X.rows)
    
    let gradient = (1/m)*X.transpose()<*>(h-y)
    return gradient
}

func gradientDescent(X: Matrix, y: Matrix, initial_theta: Matrix, learningRate: Double, iterations: Int) -> Matrix {
    var holder = Matrix.zeros(size: (initial_theta.rows, 1))
    holder = initial_theta
    var i = 0
    while i<iterations {
        holder = holder - gradient(X: X, y: y, theta: holder)*learningRate
        i = i + 1
        
    }
    return holder
}

//func mapFeatures(X: Matrix) -> Matrix {
//
//}
//
//func normalizeFeatures(X: Matrix) -> Matrix {
//
//}

