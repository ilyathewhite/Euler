import Cocoa

import PlaygroundSupport
import EulerSketchOSX

// theorem source http://mathworld.wolfram.com/SimsonLine.html

let sketch = Sketch()

// the triangle

sketch.addPoint("A", hint: (50, 215))
sketch.addPoint("B", hint: (520, 215))
sketch.addPoint("C", hint: (450, 486))

sketch.addTriangle("ABC")
sketch.addCircumcircle("o", ofTriangle: "ABC")

// Simpson Line
sketch.addPoint("P", onCircle: "o", hint: (340, 150))
sketch.addPerpendicular("PA1", toSegment: "BC", style: .extra)
sketch.addPerpendicular("PB1", toSegment: "AC", style: .extra)
sketch.addPerpendicular("PC1", toSegment: "AB", style: .extra)
sketch.addSegment("C1A1")
sketch.addSegment("C1B1")

// orthocenter and altitudes
sketch.addOrthocenter("H", ofTriangle: "ABC")
sketch.addPerpendicular("AAh", toSegment: "BC", style: .extra)
sketch.addPerpendicular("BBh", toSegment: "AC", style: .extra)
sketch.addPerpendicular("CCh", toSegment: "AB", style: .extra)
sketch.addCircumcircle("h", ofTriangle: "AhBhCh", style: .extra)

// the theorem
sketch.addSegment("HP", style: .emphasized)
sketch.addMidPoint("Z", ofSegment: "HP")
sketch.setMarkCount(1, forSegment: "HZ")
sketch.setMarkCount(1, forSegment: "ZP")

// point adjustments
sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("B", setNameLocation: .bottomRight)
sketch.point("B1", setNameLocation: .topLeft)
sketch.point("A1", setNameLocation: .bottomRight)
sketch.point("P", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
