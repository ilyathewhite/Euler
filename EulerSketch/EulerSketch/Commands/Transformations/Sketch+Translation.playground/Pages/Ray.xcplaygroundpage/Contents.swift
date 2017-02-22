//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// point C, draggable
sketch.addPoint("C", hint: (100, 100))

// ray AB
sketch.addRay("AB")

// ray A1B1
sketch.addTranslationRay("A1B1", fromRay: "AB", byVector: (dx: 100.0, dy: 50.0))

// ray BB2
sketch.addTranslationRay("BB2", fromRay: "AB", byVector: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
