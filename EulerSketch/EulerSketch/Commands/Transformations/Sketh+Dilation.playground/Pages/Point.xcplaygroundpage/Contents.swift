//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (250, 400))

// point A1
sketch.addDilationPoint("B1", fromPoint: "B", withCenter: "A", scale: 3.0)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
