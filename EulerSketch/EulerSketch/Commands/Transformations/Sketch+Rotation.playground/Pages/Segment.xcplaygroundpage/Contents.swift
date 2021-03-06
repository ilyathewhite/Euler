//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (300, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// point O, draggable
sketch.addPoint("O", hint: (250, 300))

// segment AB, draggable
sketch.addSegment("AB")

// segment A1B1
sketch.addRotationSegment("A1B1", fromSegment: "AB", withCenter: "O", degAngle: -50)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
