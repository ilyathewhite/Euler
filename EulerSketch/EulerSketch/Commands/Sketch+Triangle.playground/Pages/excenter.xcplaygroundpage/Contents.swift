//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (250, 300))

// point B, draggable
sketch.addPoint("B", hint: (340, 380))

// point C, draggable
sketch.addPoint("C", hint: (375, 300))

// triangle ABC
sketch.addTriangle("ABC")

sketch.addLine("AB")
sketch.addLine("BC")
sketch.addLine("AC")

sketch.addExcircle("b", ofTriangle: "ABC", opposite: "B")
sketch.addExcenter("B1", ofTriangle: "ABC", opposite: "B")

sketch.addExcircle("c", ofTriangle: "ABC", opposite: "C")
sketch.addExcenter("C1", ofTriangle: "ABC", opposite: "C")

sketch.addExcircle("a", ofTriangle: "ABC", opposite: "A")
sketch.addExcenter("A1", ofTriangle: "ABC", opposite: "A")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
