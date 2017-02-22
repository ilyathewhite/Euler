//
//  SegmentFigure.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// A specific segment figure. Overrides the generic `draw` method and provides convenience methods.
class SegmentFigure: Figure<HSSegment>, Segment {
   var vertex1: Point { return value.vertex1 }
   var vertex2: Point { return value.vertex2 }
   var markCount = 0
   var drawMarksOnly = false
   
   // draw
   
   private let markHalfLength = 5.0
   private let distanceBetweenMarks = 4.0
   
   override func draw(_ renderer: Renderer) {
      super.draw(renderer)
      if !drawMarksOnly {
         renderer.drawSegment(point1: vertex1, point2: vertex2)
      }
      guard markCount > 0 else { return }
      
      func drawMark(atPoint point: HSPoint) {
         let perpendicularLine = line.perpendicularLineFromPoint(point)
         let points = perpendicularLine.pointsAtDistance(markHalfLength, fromPoint: point)
         renderer.drawSegment(point1: points[0], point2: points[1])
      }
      
      let distanceToFirstMark = (length - distanceBetweenMarks * Double(markCount - 1)) / 2.0
      for idx in 0..<markCount {
         drawMark(atPoint: ray.pointAtDistance(distanceToFirstMark + distanceBetweenMarks * Double(idx)))
      }
   }
   
   // init

   /// Creates a segment from 2 points (the order is important).
   init(name: String, point1: PointFigure, point2: PointFigure) throws {
      try super.init(name: name, usedFigures: FigureSet([point1, point2])) { HSSegment(vertex1: point1, vertex2: point2) }
   }
   
   // extra

   /// Creates a midpoint figure.
   func midPoint(_ name: String) throws -> PointFigure {
      let res = try PointFigure(name: name, usedFigures: FigureSet(self)) { self.midPoint }
      res.dragUpdateFunc = self.dragUpdateFunc
      return res
   }
}
