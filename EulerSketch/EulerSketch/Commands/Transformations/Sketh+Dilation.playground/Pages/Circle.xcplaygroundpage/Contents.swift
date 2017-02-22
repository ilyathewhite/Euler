//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (280, 300))

// point B, draggable
sketch.addPoint("B", hint: (350, 300))

// point O, draggable
sketch.addPoint("O", hint: (200, 200))

// circle c, draggable
sketch.addCircle("c", withCenter: "A", throughPoint: "B")

// segment A1B1
sketch.addDilationCircle("c1", fromCircle: "c", withCenter: "O", scale: 1.5)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
