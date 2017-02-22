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
sketch.point("A", setNameLocation: .BottomLeft)
sketch.point("C", setNameLocation: .BottomRight)

// circumcenter
sketch.addCircumcenter("O", ofTriangle: "ABC")
sketch.point("O", setNameLocation: .BottomRight)

// circumcircle
sketch.addCircumcircle("c", ofTriangle: "ABC", style: .emphasized)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)