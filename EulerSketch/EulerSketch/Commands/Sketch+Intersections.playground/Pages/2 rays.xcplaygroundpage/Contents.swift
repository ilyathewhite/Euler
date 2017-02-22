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

// ray AC
sketch.addRay("AC")

// segment BD
sketch.addRay("BD")

// intersection of ray BD and ray AC
sketch.addIntersection("X", ofRay: "BD", andRay: "AC")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
