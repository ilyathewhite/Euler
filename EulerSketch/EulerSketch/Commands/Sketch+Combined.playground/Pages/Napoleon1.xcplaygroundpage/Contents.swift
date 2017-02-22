import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("A", hint: (150, 280))
sketch.addPoint("B", hint: (400, 280))
sketch.addPoint("C", hint: (344, 438))

sketch.addTriangle("ABC")

func addTriangle(onSideVertex1 p1: String, sideVertex2 p2: String, oppositeVertex p3: String, sideAngle angle: Double) {
   sketch.addRay("\(p3)1", fromPoint: p1, withAngle: angle, fromRay: "\(p1)\(p2)")
   sketch.addRay("\(p3)2", fromPoint: p2, withAngle: -angle, fromRay: "\(p2)\(p1)")
   sketch.addIntersection("\(p3)1", ofRay: "\(p3)1", andRay: "\(p3)2")
   
   sketch.hide(figureNamed: "ray_\(p3)1")
   sketch.hide(figureNamed: "ray_\(p3)2")
   sketch.hide(figureNamed: "ray_\(p1)\(p2)")
   sketch.hide(figureNamed: "ray_\(p2)\(p1)")
   
   sketch.addTriangle("\(p1)\(p2)\(p3)1")
   sketch.addCircumcenter("\(p3)2", ofTriangle: "\(p1)\(p2)\(p3)1")
}

addTriangle(onSideVertex1: "A", sideVertex2: "C", oppositeVertex: "B", sideAngle: 60)
addTriangle(onSideVertex1: "B", sideVertex2: "C", oppositeVertex: "A", sideAngle: -60)
addTriangle(onSideVertex1: "A", sideVertex2: "B", oppositeVertex: "C", sideAngle: -60)

sketch.addLine("AA2")
sketch.addLine("BB2")
sketch.addLine("CC2")

sketch.addIntersection("O1", ofLine: "AA2", andLine: "BB2")

sketch.addTriangle("A1B1C1", style: .extra)

sketch.addMidPoint("A3", ofSegment: "B1C1", style: .extra)
sketch.addMidPoint("B3", ofSegment: "A1C1", style: .extra)
sketch.addMidPoint("C3", ofSegment: "A1B1", style: .extra)
sketch.addCircumcircle("c", ofTriangle: "A3B3C3", style: .extra)

sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("B", setNameLocation: .bottomRight)
sketch.point("C1", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
