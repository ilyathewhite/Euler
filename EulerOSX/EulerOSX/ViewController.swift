//
//  ViewController.swift
//  EulerOSX
//
//  Created by Ilya Belenkiy on 7/2/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Cocoa
import EulerSketchOSX

class ViewController: NSViewController {
   let sketch = Sketch()

   override func viewDidLoad() {
      super.viewDidLoad()

      try! ninePointCircle(sketch)
      // try! radicalAxis(sketch)
      sketchView.sketch = sketch
   }
   
   var sketchView: SketchView { return view as! SketchView }

   func ninePointCircle(_ s: Sketch) throws {
      s.addPoint("A", hint: (150, 150))
      s.addPoint("B", hint: (550, 150))
      s.addPoint("C", hint: (425, 400))
      
      s.addTriangle("ABC", style: .emphasized)
      
      s.addMedian("AAm", ofTriangle: "ABC", style: .extra)
      s.addMedian("BBm", ofTriangle: "ABC", style: .extra)
      s.addMedian("CCm", ofTriangle: "ABC", style: .extra)
      
      s.addAltitude("AAh", ofTriangle: "ABC", style: .extra)
      s.addAltitude("BBh", ofTriangle: "ABC", style: .extra)
      s.addAltitude("CCh", ofTriangle: "ABC", style: .extra)
      
      s.addCentroid("M", ofTriangle: "ABC")
      s.addOrthocenter("H", ofTriangle: "ABC")
      
      s.addSegment("AH", style: .extra)
      s.addSegment("BH", style: .extra)
      s.addSegment("CH", style: .extra)
      
      s.addMidPoint("A1", ofSegment: "AH")
      s.addMidPoint("B1", ofSegment: "BH")
      s.addMidPoint("C1", ofSegment: "CH")
      
      s.addCircle("ABC9", throughPoints: "Am", "Bm", "Cm", style: .emphasized)
      
      s.point("A", setNameLocation: .bottomLeft)
      s.point("B", setNameLocation: .bottomRight)
      s.point("M", setNameLocation: .bottomRight)
      s.point("Cm", setNameLocation: .bottomLeft)
      s.point("Ch", setNameLocation: .bottomRight)
      s.point("A1", setNameLocation: .topLeft)
      s.point("Bh", setNameLocation: .topLeft)
      s.point("Bm", setNameLocation: .topLeft)
      
      view.needsDisplay = true
   }
   
   func circlePointProjections(_ s: Sketch) throws {
      s.addPoint("A", hint: (190, 105))
      s.addPoint("B", hint: (440, 105))
      s.addPoint("C", hint: (350, 215))
      
      s.addTriangle("ABC")
      s.addCircle("ABC", throughPoints: "A", "B", "C")
      s.addPoint("P", onCircle: "ABC", hint: (350, 35))
      
      s.addPerpendicular("PA1", toSegment: "BC")
      s.addPerpendicular("PB1", toSegment: "AC")
      s.addPerpendicular("PC1", toSegment: "AB")
      
      s.addSegment("A1B1", style: .emphasized)
      s.addSegment("B1C1", style: .emphasized)
      
      s.point("A", setNameLocation: .bottomLeft)
      s.point("B", setNameLocation: .bottomRight)
      s.point("A1", setNameLocation: .bottomRight)
      s.point("P", setNameLocation: .bottomRight)
      s.point("B1", setNameLocation: .topLeft)
      
      view.needsDisplay = true
   }
   
   func radicalAxis(_ s: Sketch) throws {
      // point O1, draggable
      s.addPoint("O1", hint: (300, 300))
      
      // circle, draggable
      s.addCircle("a", withCenter: "O1", hintRadius: 75)
      
      // point O2, draggable
      s.addPoint("O2", hint: (400, 300))
      
      // circle, draggable
      s.addCircle("b", withCenter: "O2", hintRadius: 50)
      
      s.addRadicalAxis("c", ofCircles: "a", "b")      
   }
}

