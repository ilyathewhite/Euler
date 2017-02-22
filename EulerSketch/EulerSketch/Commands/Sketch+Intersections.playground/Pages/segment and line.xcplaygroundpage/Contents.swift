//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (100, 250))

// point B, draggable
sketch.addPoint("B", hint: (400, 450))

// point C, draggable
sketch.addPoint("C", hint: (500, 250))

// point D, draggable
sketch.addPoint("D", hint: (300, 150))

// line AC
sketch.addLine("AC")

// segment BD
sketch.addSegment("BD")

// intersection of segment BD and line AC
sketch.addIntersection("X", ofSegment: "BD", andLine: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
