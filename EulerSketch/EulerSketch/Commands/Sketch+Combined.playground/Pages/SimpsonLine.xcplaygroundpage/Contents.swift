import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("A", hint: (145, 230))
sketch.addPoint("B", hint: (445, 230))
sketch.addPoint("C", hint: (393, 454))

sketch.addTriangle("ABC")
sketch.addCircumcircle("o", ofTriangle: "ABC")

sketch.addPoint("P", onCircle: "o", hint: (340, 150))
sketch.addPerpendicular("PA1", toSegment: "BC")
sketch.addPerpendicular("PB1", toSegment: "AC")
sketch.addPerpendicular("PC1", toSegment: "AB")
sketch.addSegment("C1A1", style: .emphasized)
sketch.addSegment("C1B1", style: .emphasized)

sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("B", setNameLocation: .bottomRight)
sketch.point("B1", setNameLocation: .topLeft)
sketch.point("A1", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
