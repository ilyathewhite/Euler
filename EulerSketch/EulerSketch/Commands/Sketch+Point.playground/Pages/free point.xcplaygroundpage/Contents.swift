//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (300, 300))

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
