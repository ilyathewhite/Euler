//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 200))

// point B, draggable
sketch.addPoint("B", hint: (400, 300))

// point C, draggable
sketch.addPoint("C", hint: (250, 400))

// circle through points A, B, C
sketch.addCircle("a", throughPoints: "A", "B", "C")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
