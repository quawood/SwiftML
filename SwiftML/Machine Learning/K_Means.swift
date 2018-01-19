import Foundation

func elbow_method(data: Matrix, max_n: Int) -> dataTuple{
    var errors: dataTuple = []
    for n in 1..<max_n {
        let belongings = k_means(n: n, data: data, max_iter: 2000)
        let error = total_error(data: data, to_centroids: belongings.1, centroids: belongings.0)
        errors.append((x: Double(n), y: error))
    }
    return errors
}

func total_error(data: Matrix, to_centroids: [Int], centroids: [[Double]]) -> Double {
    let nrows = data.size.0
    let ncolumns = data.size.1
    var total_error = 0.0
    for cent in 0...to_centroids.max()! {
        for r in 0..<nrows {
            if to_centroids[r] == cent {
                let row = data[row: r]
                total_error = total_error + euc_dist(a: row.array[0], b: centroids[cent])
            }
        }
        
    }
    return total_error
}
func k_means(n: Int, data: Matrix, max_iter: Int) -> ([[Double]], [Int]) {
    var centroids: [[Double]] = []
    var to_centroid: [Int] = []
    let nrows = data.size.0
    let ncolumns = data.size.1
    
    //create starting centroids
    for cent in 0..<n {
        centroids.append([])
        for c in 0..<ncolumns {
            let col = data[column: c]
            let randnum = Double.random(min: col.min().0, max:col.max().0)
            centroids[cent].append(randnum)
        }
    }
    
    //initialize to_centroid array
    for _ in 0..<nrows {
        to_centroid.append(0)
    }
    
    for _ in 0..<max_iter {
        
        //assign data to centroids
        for r in 0..<nrows {
            let row = data[row: r]
            let row_array = row.array[0]
            var min_dist = euc_dist(a: row_array, b: centroids[0])
            to_centroid[r] = 0
            for cent in 1..<n {
                let dist = euc_dist(a: row_array, b: centroids[cent])
                if  dist < min_dist {
                    min_dist = dist
                    to_centroid[r] = cent
                    
                }
            }
        }
        
        
        //reposition centroids
        for cent in 0..<n {
            var belong_comps = Matrix.zeros(size: (1, ncolumns))
            var nbelongs = 0
            for r in 0..<nrows {
                if to_centroid[r] == cent {
                   let row = data[row: r]
                    belong_comps = belong_comps + row
                    nbelongs = nbelongs + 1
                }
            }
            centroids[cent] = (belong_comps/Double(nbelongs)).array[0]
        }
        
    }

    return (centroids, to_centroid)
    
    

    
    
}

func euc_dist(a: [Double], b: [Double]) -> Double {
    var sum = 0.0
    if a.count == b.count {
        for i in 0..<a.count {
            sum = sum + pow(b[i] - a[i] , 2)
        }
    }
    
    return sqrt(sum)
}
