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
sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("C", setNameLocation: .bottomRight)

// median BBm
sketch.addMedian("BBm", ofTriangle: "ABC", style: .extra)
sketch.point("Bm", setNameLocation: .bottomRight)

// median CCm
sketch.addMedian("CCm", ofTriangle: "ABC", style: .extra)
sketch.point("Cm", setNameLocation: .topLeft)

// median AAm
sketch.addMedian("AAm", ofTriangle: "ABC", style: .extra)
sketch.point("Bm", setNameLocation: .bottomRight)

// centroid
sketch.addCentroid("M", ofTriangle: "ABC")
sketch.point("M", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@nex
