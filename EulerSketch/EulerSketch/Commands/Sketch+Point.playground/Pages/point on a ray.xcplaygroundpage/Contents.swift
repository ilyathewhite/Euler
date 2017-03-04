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

sketch.addPoint(
    "E",
    onRay: "AB",
    atComputedDistanceFromVertex: { [unowned sketch] in
        let A = try sketch.getPoint("A")
        let C = try sketch.getPoint("C")
        return HSSegment(vertex1: A, vertex2: C)!.length * 2.0
    },
    usingFigures: ["point_A", "point_C"]
)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
