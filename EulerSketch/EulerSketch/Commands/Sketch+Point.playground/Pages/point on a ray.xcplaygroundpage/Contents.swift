//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// ray AB, draggable through A and B
sketch.addRay("AB")

// point C, on ray AB, draggable
sketch.addPoint("C", onRay: "AB", hint: (350, 300))

// point D, on ray AB, fixed
sketch.addPoint("D", onRay: "AB", atDistanceFromVertex: 90)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
