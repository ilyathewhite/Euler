//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// line AB, draggable through A and B
sketch.addLine("AB")

// point C, on line AB, draggable
sketch.addPoint("C", onLine: "AB", hint: (350, 300))

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
