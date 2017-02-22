//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (300, 400))

// point B, draggable
sketch.addPoint("B", hint: (350, 450))

// point O, draggable
sketch.addPoint("O", hint: (275, 300))

// circle c, draggable
sketch.addCircle("c", withCenter: "A", throughPoint: "B")

// segment A1B1
sketch.addRotationCircle("c1", fromCircle: "c", withCenter: "O", degAngle: -50)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
