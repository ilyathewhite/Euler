//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 300))

// point B, draggable
sketch.addPoint("B", hint: (400, 300))

// segment AB, draggable through A and B
sketch.addSegment("AB")

// point C, draggable
sketch.addPoint("C", hint: (250, 400))

// segment CCh, perpendicular to segment AB
sketch.addPerpendicular("CCh", toSegment: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
