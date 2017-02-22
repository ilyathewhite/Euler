//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 300))

// point B, draggable
sketch.addPoint("B", hint: (400, 350))

// segment AB, draggable through A and B
sketch.addSegment("AB")

// line l, bisector of segment AB
sketch.addBisector("l", ofSegment: "AB")

// point M
sketch.addMidPoint("M", ofSegment: "AB")

sketch.addSegment("AM")
sketch.drawMarksOnly(forSegment: "AM")
sketch.addSegment("MB")
sketch.drawMarksOnly(forSegment: "MB")

sketch.setMarkCount(1, forSegment: "AM")
sketch.setMarkCount(1, forSegment: "MB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
