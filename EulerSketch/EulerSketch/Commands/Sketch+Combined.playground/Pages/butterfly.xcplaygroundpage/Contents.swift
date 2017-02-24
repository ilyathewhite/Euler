//: Playground - noun: a place where people can play

import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("O", hint: (300, 300))

sketch.addCircle("c", withCenter: "O", hintRadius: 200)
sketch.addPoint("A", onCircle: "c", hint: (120, 400))
sketch.addPoint("B", onCircle: "c", hint: (467, 400))
sketch.addSegment("AB")
sketch.addMidPoint("M", ofSegment: "AB")

sketch.addPoint("P", onCircle: "c", hint: (350, 500))
sketch.addPoint("Q", onCircle: "c", hint: (150, 500))

sketch.addIntersection("P1", ofRay: "PM", andCircle: "c", selector: bottomPoint)
sketch.addIntersection("Q1", ofRay: "QM", andCircle: "c", selector: bottomPoint)

sketch.addSegment("PP1")
sketch.addSegment("QQ1")
sketch.addSegment("QP1")
sketch.addSegment("PQ1")

sketch.addIntersection("Q2", ofSegment: "QP1", andSegment: "AB")
sketch.addIntersection("P2", ofSegment: "PQ1", andSegment: "AB")

sketch.addSegment("MQ2", style: .emphasized)
sketch.addSegment("MP2", style: .emphasized)

sketch.setMarkCount(1, forSegment: "MP2")
sketch.setMarkCount(1, forSegment: "MQ2")

sketch.assert("MQ2 == MP2") { [unowned sketch] in
   let MQ2 = try sketch.getSegment("MQ2")
   let MP2 = try sketch.getSegment("MP2")
   return same(MQ2.length, MP2.length)
}

sketch.eval()

// live view
PlaygroundPage.current.liveView = sketch.quickView()
