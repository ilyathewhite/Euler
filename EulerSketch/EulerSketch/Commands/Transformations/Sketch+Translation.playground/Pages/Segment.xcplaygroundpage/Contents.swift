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

// segment AB
sketch.addSegment("AB")

// segment A1B1
sketch.addTranslationSegment("A1B1", fromSegment: "AB", byVector: (dx: 100.0, dy: 50.0))

// segment BB2
sketch.addTranslationSegment("BB2", fromSegment: "AB", byVector: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
