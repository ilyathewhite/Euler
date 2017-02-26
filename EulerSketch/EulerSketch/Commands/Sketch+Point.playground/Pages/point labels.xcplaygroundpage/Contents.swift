//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 200))
sketch.point("A", setNameLocation: .bottomLeft)

// point B, draggable
sketch.addPoint("B", hint: (400, 200))
sketch.point("B", setNameLocation: .bottomRight)

// point C, draggable
sketch.addPoint("C", hint: (400, 400))
sketch.point("C", setNameLocation: .topRight)

// point D, draggable
sketch.addPoint("D", hint: (200, 400))
sketch.point("D", setNameLocation: .topLeft)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
