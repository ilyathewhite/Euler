//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (100, 250))

// point B, draggable
sketch.addPoint("B", hint: (400, 450))

// point C, draggable
sketch.addPoint("C", hint: (500, 250))

// triangle ABC
sketch.addTriangle("ABC")

// label adjustments
sketch.point("A", setNameLocation: .BottomLeft)
sketch.point("C", setNameLocation: .BottomRight)

// median BBm
sketch.addMedian("BBm", ofTriangle: "ABC")
sketch.point("Bm", setNameLocation: .BottomRight)

// altitude BBh
sketch.addAltitude("BBh", ofTriangle: "ABC")
sketch.point("Bh", setNameLocation: .BottomRight)

// bisector BBc
sketch.addBisector("BBc", ofTriangle: "ABC")
sketch.point("Bc", setNameLocation: .BottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
