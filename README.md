Collection of classes to assist in running Machine Learning algorithms in Swift.
Current capabilities:
* Create graphs from tuple data
* Create polynomial regressions on data
* Linear regression using both gradient descent and normal equation

![alt text](https://github.com/quawood/SwiftML/blob/master/SwiftML/samples/sample1.png)
![alt text](https://github.com/quawood/SwiftML/blob/master/SwiftML/samples/sample2.png)

Challenges:
* Difficult to increase degree past 5 without needing to wait significant time for graph
* current learning rate set to 0.001 and iterations set to 100000, time to create regression to significant

Ideas for fixes: 
* feature normalization
* want to be able to create curves that are not necessarily functions (e.g. circles)

Next up:
* K-means clustering
* manual graph scaling
