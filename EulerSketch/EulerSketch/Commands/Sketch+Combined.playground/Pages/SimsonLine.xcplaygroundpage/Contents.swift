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

// result

sketch.assert("A1, B1, C1 are collinear") { [unowned sketch] in
   let p1 = try sketch.getPoint("A1")
   let p2 = try sketch.getPoint("B1")
   let p3 = try sketch.getPoint("C1")
   return collinear(points: [p1, p2, p3])
}

sketch.eval()

// sketch adjustments

sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("B", setNameLocation: .bottomRight)
sketch.point("B1", setNameLocation: .topLeft)
sketch.point("A1", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
