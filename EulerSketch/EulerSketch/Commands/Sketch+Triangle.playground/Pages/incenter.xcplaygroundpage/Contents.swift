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

// bisector BBi
sketch.addBisector("BBi", ofTriangle: "ABC", style: .extra)
sketch.point("Bi", setNameLocation: .bottomRight)

// bisector CCi
sketch.addBisector("CCi", ofTriangle: "ABC", style: .extra)
sketch.point("Ci", setNameLocation: .topLeft)

// bisector AAi
sketch.addBisector("AAi", ofTriangle: "ABC", style: .extra)
sketch.point("Ai", setNameLocation: .topRight)

// incenter
sketch.addIncenter("I", ofTriangle: "ABC")
sketch.point("I", setNameLocation: .bottomRight)

// incircle
sketch.addIncircle("c", ofTriangle: "ABC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@nex
