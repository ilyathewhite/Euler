//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// point A, draggable
sketch.addPoint("A", hint: (400, 400))

// circle, draggable
sketch.addCircle("a", withCenter: "O", throughPoint: "A")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
