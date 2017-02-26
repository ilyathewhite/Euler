//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (100, 250))

// point B, draggable
sketch.addPoint("B", hint: (400, 500))

// point C, draggable
sketch.addPoint("C", hint: (500, 250))

// triangle ABC
sketch.addTriangle("ABC")

// label adjustments
sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("C", setNameLocation: .bottomRight)

// altitude BBm
sketch.addAltitude("BBm", ofTriangle: "ABC", style: .extra)
sketch.point("Bm", setNameLocation: .bottomRight)

// altitude CCm
sketch.addAltitude("CCm", ofTriangle: "ABC", style: .extra)
sketch.point("Cm", setNameLocation: .topLeft)

// altitude AAm
sketch.addAltitude("AAm", ofTriangle: "ABC", style: .extra)
sketch.point("Bm", setNameLocation: .bottomRight)

// orthocenter
sketch.addOrthocenter("H", ofTriangle: "ABC")
sketch.point("H", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@nex
