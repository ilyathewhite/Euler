//: Playground - noun: a place where people can play

import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("O", hint: (300, 250))

sketch.addCircle("c", withCenter: "O", hintRadius: 150)
sketch.addPoint("A", hint: (300, 500))

sketch.addTangent("AT1", toCircle: "c", selector: leftPoint)
sketch.addTangent("AT2", toCircle: "c", selector: rightPoint)
sketch.addSegment("T1T2")

sketch.addPoint("P", onCircle: "c", hint: (350, 500))
sketch.addIntersection("Q", ofRay: "AP", andCircle: "c") { [unowned sketch] points in
   let P = try! sketch.getPoint("P")
   return points.first { !same($0, P) }
}

sketch.addMidPoint("M", ofSegment: "PQ")

sketch.addSegment("MT1")
sketch.addSegment("MT2")
sketch.addSegment("AQ")

// result

sketch.addAngleMark(count: 1, fromRay: "MT2", toRay: "MP")
sketch.addAngleMark(count: 1, fromRay: "MP", toRay: "MT1")

sketch.assert("angle T2MP == angle PMT1") { [unowned sketch] in
   let MT2 = try sketch.getRay("MT2")
   let MP = try sketch.getRay("MP")
   let MT1 = try sketch.getRay("MT1")
   return same(HSAngle(ray1: MT2, ray2: MP).angle, HSAngle(ray1: MP, ray2: MT1).angle)
}

// hint
// sketch.addCircle("c1", throughPoints: "M", "T1", "T2", style: .extra)

sketch.eval()

// sketch adjustments

sketch.hide(figureNamed: "ray_MT1")
sketch.hide(figureNamed: "ray_MT2")

sketch.point("M", setNameLocation: .bottomLeft)
sketch.point("T1", setNameLocation: .topLeft)
sketch.point("T2", setNameLocation: .topRight)
sketch.point("Q", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()
