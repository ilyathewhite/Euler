//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 200))
sketch.point("A", setNameLocation: .BottomLeft)

// point B, draggable
sketch.addPoint("B", hint: (400, 200))
sketch.point("B", setNameLocation: .BottomRight)

// point C, draggable
sketch.addPoint("C", hint: (400, 400))
sketch.point("C", setNameLocation: .TopRight)

// point D, draggable
sketch.addPoint("D", hint: (200, 400))
sketch.point("D", setNameLocation: .TopLeft)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
