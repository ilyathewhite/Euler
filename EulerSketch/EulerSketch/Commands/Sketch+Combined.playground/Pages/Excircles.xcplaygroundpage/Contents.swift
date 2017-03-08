//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (106, 300))

// point B, draggable
sketch.addPoint("B", hint: (451, 435))

// point C, draggable
sketch.addPoint("C", hint: (342, 300))

// triangle ABC
sketch.addTriangle("ABC")

sketch.addRay("BA")
sketch.addRay("BC")

sketch.addExcircle("b", ofTriangle: "ABC", opposite: "B")
sketch.addExcenter("B1", ofTriangle: "ABC", opposite: "B")

sketch.addAltitude("AA2", ofTriangle: "ABC", style: .extra)
sketch.addAltitude("BB2", ofTriangle: "ABC", style: .extra)
sketch.addAltitude("CC2", ofTriangle: "ABC", style: .extra)

sketch.addCircumcircle("c9", ofTriangle: "A2B2C2")

sketch.addRadicalAxis("x", ofCircles: "c9", "b")

// results, Feuerbach's Theorem

sketch.assert("circle c9 is tangent to circle b") { [unowned sketch] in
   let c9 = try sketch.getCircle("c9")
   let b = try sketch.getCircle("b")
   return c9.isTangentTo(circle: b)
}

sketch.eval()

// sketch adjustments
sketch.point("A", setNameLocation: .topLeft)
sketch.point("C", setNameLocation: .bottomRight)
sketch.point("C2", setNameLocation: .topLeft)
sketch.dragPoint(fullName: "point_handle_for_ray_BC", to: (160.0,87.0))

// live view
PlaygroundPage.current.liveView = sketch.quickView()
