//
//  Line.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The line protocol. Describes the line in its canonical form.
protocol Line: Shape {
   /// Part of canonical line form: Ax + By + C = 0
   var A: Double { get }
   
   /// Part of canonical line form: Ax + By + C = 0
   var B: Double { get }
   
   /// Part of canonical line form: Ax + By + C = 0
   var C: Double { get }
   
   /// Changes the line.
   mutating func update(A: Double, B: Double, C: Double) -> Bool
}

/// Common operations on lines.
extension Line {
   /// Returns the line slope. Returns nil if the line is vertical and has infinite slope.
   var slope: Double? {
      if self.B == 0.0 {
         return nil
      }
      
      return  -self.A / self.B
   }
   
   /// Returns the `y` coordinate of the point where the line intersects the vertical axis 
   /// (so the point is `(0, constant)`). Put another way, if the line can be represented as
   /// `kx + b`, this is the `b` part.
   var constant: Double {
      if self.C == 0.0 {
         return 0.0
      }
      
      return -self.C / self.B
   }
   
   /// Whether the line contains `point`.
   func containsPoint(_ point: Point) -> Bool {
      return abs(A * point.x + B * point.y + C) < epsilon
   }
   
   /// Returns the intersection of this line with `line2` or `nil` if the lines are parallel or the same.
   func intersect(_ line2: Line) -> HSPoint? {
      let line1 = self
      
      if (line1.B == 0.0) && (line2.B == 0.0) {
         return nil
      }
      
      if line1.B == 0.0 {
         let resX = -line1.C / line1.A
         let resY = (-line2.C - line2.A * resX) / line2.B
         return HSPoint(resX, resY)
      }
      
      if (line2.B == 0.0) {
         return line2.intersect(line1)
      }
      
      let k1 = line1.slope!
      let k2 = line2.slope!
      
      if (k1 == k2) {
         return nil
      }
      
      let b1 = line1.constant
      let b2 = line2.constant
      
      let resX = (b2 - b1) / (k1 - k2)
      let resY = k1 * resX + b1
      
      return HSPoint(resX, resY)
   }
   
   /// Returs the intersections of the line with `circle`. The array can have 0, 1, or 2 points.
   func intersect(_ circle: Circle) -> [HSPoint] {
      let line = self
      let O = circle.center
      let P = line.footFromPoint(O)
      let distOP = O.distanceToPoint(P)
      if distOP > circle.radius {
         return []
      }
      else if distOP == circle.radius {
         return [P]
      }
      else {
         let height = sqrt(square(circle.radius) - square(distOP))
         let points = line.pointsAtDistance(height, fromPoint: P)
         if distOP == 0 {
            return points
         }
         let Q = points[0]
         let OP = HSSegment(vertex1: O, vertex2: P)!
         let OQ = HSSegment(vertex1: O, vertex2: Q)!
         let zVecOPxVecOQ = OP.vectorProductZaxis(OQ)
         return zVecOPxVecOQ > 0 ? points : points.reversed()
      }
   }
   
   /// Returns whether the line canonical form is valid.
   static func testABC(_ A: Double, _ B: Double, _ C: Double) -> Bool {
      return (A != 0) || (B != 0)
   }
   
   /// Returns a line constructed from form `kx + b` where `k` is `slope`, and `b` is `constant`.
   static func line(slope: Double, constant: Double) -> HSLine {
      return HSLine(A: slope, B: -1.0, C: constant)!
   }
   
   /// Returns the line going through `point` with a given `slope`.
   static func line(slope: Double, point: Point) -> HSLine {
      return line(slope: slope, constant: -slope * point.x + point.y)
   }
   
   /// Returns the line going through `point` that forms a given `angle` from the `x` axis.
   /// The `angle` is in radians.
   static func line(point: Point, angle: Double) -> HSLine {
      if (abs(cos(angle)) < epsilon) {
         return HSLine(A: 1.0, B: 0.0, C: -point.x)!
      }
      
      return line(slope: tan(angle), point: point)
   }

   /// Returns the line going through `point1` and `point2` or `nil` if the points are the same.
   static func line(point1: Point, point2: Point) -> HSLine? {
      guard point1 != point2 else {
         return nil
      }
      
      if point1.x == point2.x {
         return HSLine(A: 1.0, B: 0.0, C: -point1.x)
      }
      
      let slope = (point2.y - point1.y) / (point2.x - point1.x)
      return line(slope: slope, point: point1)
   }
   
   /// Returns the `y` coordinate of a point, given its `x` coordinate.
   func yFromX(_ x: Double) -> Double {
      return B != 0 ? (-C - A * x) / B : 0
   }
   
   /// Returns the line perpendicular to this line and going through `point`.
   func perpendicularLineFromPoint(_ point: Point) -> HSLine {
      if self.B == 0.0 {
         return Self.line(slope: 0, point: point)
      }
      
      if self.slope! != 0.0 {
         return Self.line(slope: -1.0 / self.slope!, point: point)
      }
      
      return HSLine(A: -1.0, B: 0.0, C: point.x)!
   }
   
   /// Returns the projection of `point` to this line.
   func footFromPoint(_ point: Point) -> HSPoint {
      let line2 = perpendicularLineFromPoint(point)
      var res = intersect(line2)!
      res.kind = .perpendicularLineFoot(point, self)
      return res
   }
   
   /// Returns the points on the line that are at a given `distance` from `point`.
   func pointsAtDistance(_ distance: Double, fromPoint point: Point) -> [HSPoint] {
      assert(distance >= 0, "Expected distance should be >= 0.")
      
      guard distance != 0 else {
         return [point.basicValue]
      }
      
      if (self.slope == nil) {
         return [ HSPoint(point.x, point.y - distance), HSPoint(point.x, point.y + distance) ]
      }
      
      let angle = atan(self.slope!)
      let dx = distance * cos(angle)
      let dy = distance * sin(angle)
      
      return [ HSPoint(point.x + dx, point.y + dy), HSPoint(point.x - dx, point.y - dy) ]
   }
   
   // Shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      let foot = footFromPoint(point)
      return (foot.distanceToPoint(point), foot)
   }
   
   mutating func translateInPlace(by vector: Vector) {
      _ = update(A: A, B: B, C: C - A * vector.dx - B * vector.dy)
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .line
   }
}

/// The most basic `Line` value that can be used for further calculations
/// or to construct a drawable line on the sketch.
struct HSLine: Line {
   var A = 0.0
   var B = 0.0
   var C = 0.0
   
   mutating func update(A: Double, B: Double, C: Double) -> Bool {
      guard HSLine.testABC(A, B, C) else { return false }
      self.A = A
      self.B = B
      self.C = C
      return true
   }
   
   init?(A: Double, B: Double, C: Double) {
      guard HSLine.testABC(A, B, C) else { return nil }
      self.A = A
      self.B = B
      self.C = C
   }
}
