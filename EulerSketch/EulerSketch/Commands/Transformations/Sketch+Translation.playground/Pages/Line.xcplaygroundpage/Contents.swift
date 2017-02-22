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

// line AB
sketch.addLine("AB")

// line A1B1
sketch.addTranslationLine("A1B1", fromLine: "AB", byVector: (dx: 100.0, dy: 50.0))

// line BB2
sketch.addTranslationLine("BB2", fromLine: "AB", byVector: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
