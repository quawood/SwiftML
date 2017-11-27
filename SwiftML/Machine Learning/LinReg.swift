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

    let gradient = X.transpose()<*>(h-y)
    return gradient
}

func gradientDescent(X: Matrix, y: Matrix, initial_theta: Matrix, learningRate: Double, max_iterations: Int) -> Matrix {
    let m = Double(X.rows)
    var holder = initial_theta
    var running = true
    var i = 0
    while running {
        holder = holder - gradient(X: X, y: y, theta: holder)*learningRate*(1/m)
        i = i + 1
        if i > max_iterations {
            running = false
        }
        
    }
    return holder
}
func hypothesis(x: Double, theta: Matrix) -> Double {

    let dummy = Matrix([[x]])
    let F = mapFeatures(X: dummy, degree: theta.rows-1)

    let answer = F <*> theta
    
    return answer.sum()
}
func mapFeatures(X: Matrix, degree: Int) -> Matrix {
    var holder: [[Double]] = []
    for d in 0...degree {
        let row = X.transpose().pow(Double(d))
        holder.append(row.array[0])
    }
    return Matrix(holder).transpose()
}

func normalEquation(X: Matrix, y: Matrix) -> Matrix{
    return ((X.transpose() <*> X).inverse()) <*> (X.transpose() <*> y)
}
//
//func normalizeFeatures(X: Matrix) -> Matrix {
//
//}

