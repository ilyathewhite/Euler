import PlaygroundSupport
import EulerSketchOSX
import Foundation

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 300))

// point B, draggable
sketch.addPoint("B", hint: (400, 300))

sketch.point("A", setNameLocation: .bottomLeft)

// ray AB, draggable through A and B
sketch.addRay("AB")

// ray a, draggable through A
sketch.addRay("a", fromPoint: "A", withHintAngleFromXaxis: 120 )

sketch.addAngleMark(count: 1, fromRay: "AB", toRay: "a")

sketch.addRay("b", fromPoint: "A", withAngle: 30, fromRay: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
