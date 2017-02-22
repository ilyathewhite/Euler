//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point O1, draggable
sketch.addPoint("O1", hint: (200, 300))

// point A1, draggable
sketch.addPoint("A1", hint: (250, 400))

// circle c1, draggable
sketch.addCircle("c1", withCenter: "O1", throughPoint: "A1")

// point O2, draggable
sketch.addPoint("O2", hint: (350, 300))

// point A2, draggable
sketch.addPoint("A2", hint: (400, 350))

// circle c2, draggable
sketch.addCircle("c2", withCenter: "O2", throughPoint: "A2")

// c1 x c2, point 1
sketch.addIntersection("X1", ofCircle: "c1", andCircle: "c2", selector: topPoint)

// c1 x c2, point 2
sketch.addIntersection("X2", ofCircle: "c1", andCircle: "c2", selector: bottomPoint)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
