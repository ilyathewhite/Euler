//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 250))

// point B, draggable
sketch.addPoint("B", hint: (400, 450))

// point C, draggable
sketch.addPoint("C", hint: (500, 250))

// point D, draggable
sketch.addPoint("D", hint: (200, 550))

// point E, draggable
sketch.addPoint("E", hint: (300, 100))

// circle through poings A, B, and C
sketch.addCircle("c", throughPoints: "A", "B", "C")

// ray DE
sketch.addLine("DE")

// intersection of ray DE  and circle c
sketch.addIntersection("X1", ofLine: "DE", andCircle: "c", selector: leftPoint)

// intersection of ray DE  and circle c
sketch.addIntersection("X2", ofLine: "DE", andCircle:"c", selector: rightPoint)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
