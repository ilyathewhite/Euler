//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// point C, draggable
sketch.addPoint("C", hint: (300, 300))

// circle c
sketch.addCircle("c", throughPoints: "A", "B", "C")

// circle c1
sketch.addTranslationCircle("c1", fromCircle: "c", byVector: (dx: 50.0, dy: 50.0))

// circle c2
sketch.addTranslationCircle("c2", fromCircle: "c", byVector: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
