import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("A", hint: (145, 230))
sketch.addPoint("B", hint: (445, 230))
sketch.addPoint("C", hint: (393, 454))

sketch.addTriangle("ABC")

sketch.addBisector("a", ofSegment: "BC", style: .extra)
sketch.addBisector("b", ofSegment: "AC", style: .extra)
sketch.addBisector("c", ofSegment: "AB", style: .extra)

sketch.addPoint("A1", onLine: "a", hint: (462, 342))
sketch.addPoint("B1", onLine: "b", hint: (230, 400))
sketch.addPoint("C1", onLine: "c", hint: (300, 145))

sketch.addTriangle("A1B1C1")

sketch.addMidPoint("A2", ofSegment: "BC")
sketch.addMidPoint("B2", ofSegment: "AC")
sketch.addMidPoint("C2", ofSegment: "AB")

sketch.addPerpendicular("A2A3", toSegment: "B1C1", style: .emphasized)
sketch.addPerpendicular("B2B3", toSegment: "A1C1", style: .emphasized)
sketch.addPerpendicular("C2C3", toSegment: "A1B1", style: .emphasized)

sketch.addIntersection("X", ofLine: "A2A3", andLine: "B2B3")

sketch.point("A2", setNameLocation: .bottomLeft)
sketch.point("A3", setNameLocation: .bottomLeft)
sketch.point("C1", setNameLocation: .bottomRight)

// result

sketch.assert("Lines A2A3, B2B3, C2C3 are concurrent") { [unowned sketch] in
   let A2A3 = try sketch.getLine("A2A3")
   let B2B3 = try sketch.getLine("B2B3")
   let C2C3 = try sketch.getLine("C2C3")
   return concurrent(lines: [A2A3, B2B3, C2C3])
}

sketch.eval()

// live view
PlaygroundPage.current.liveView = sketch.quickView()
