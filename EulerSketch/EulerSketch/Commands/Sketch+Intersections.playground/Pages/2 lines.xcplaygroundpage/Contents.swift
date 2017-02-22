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

// line BD
sketch.addLine("BD")

// intersection of lines AC and BD
sketch.addIntersection("X", ofLine: "AC", andLine: "BD")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
