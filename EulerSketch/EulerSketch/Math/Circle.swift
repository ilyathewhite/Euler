//
//  Circle.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The Circle protocol. Describes a circle by its center and radius.
public protocol Circle: Shape {
   /// The center.
   var center: Point { get }
   
   /// The radius.
   var radius: Double { get }
}

/// Common operations on circles.
public extension Circle {
   /// Returns the circle going through `point1`, `point2`, and `point3`.
   static func circle(point1 A: Point, point2 B: Point, point3 C: Point) -> HSCircle? {
      guard (A != B) && (B != C) && (A != C) else { return nil }
      
      let AB = HSSegment(vertex1: A, vertex2: B)!
      let bisectorAB = AB.bisector
      
      let BC = HSSegment(vertex1: B, vertex2: C)!
      let bisectorBC = BC.bisector
      
      if let center = bisectorAB.intersect(bisectorBC) {
         let radius =  center.distanceToPoint(A)
         guard same(center.distanceToPoint(A), radius) else { return nil }
         guard same(center.distanceToPoint(B), radius) else { return nil }
         guard same(center.distanceToPoint(C), radius) else { return nil }
         return HSCircle(center: center, radius: radius)
      }
      else {
         return nil
      }
   }
   
   /// Returns the circle with a given `center` that goes through `point`.
   static func circle(center O: Point, point: Point) -> HSCircle {
      return HSCircle(center: O, radius: O.distanceToPoint(point))
   }
   
   /// Whether `point` is on the circle.
   func containsPoint(_ point: Point) -> Bool {
      return same(center.distanceToPoint(point), radius)
   }

   /// Whether the circle is tangent to a given circle.
   func isTangentTo(circle: Circle) -> Bool {
      return same(radius + circle.radius, center.distanceToPoint(circle.center))
   }
   
   /// Returns the points at wchih tangent lines from `point` touch the circle.
   func tangentPointsFromPoint(point P: Point) -> [HSPoint] {
      let O = center
      let distOP = O.distanceToPoint(P)
      if distOP < radius {
         return []
      }
      else if distOP == radius {
         return [ P.basicValue ]
      }
      else {
         let cos = radius / distOP
         let lineOP = HSLine.line(point1: O, point2: P)!
         let pointsQ = lineOP.pointsAtDistance(radius * cos, fromPoint:O)
         let Q = HSSegment(vertex1: O, vertex2: P)!.containsLinePoint(pointsQ[0]) ? pointsQ[0] : pointsQ[1]
         return lineOP.perpendicularLineFromPoint(Q).intersect(self)
      }
   }
   
   /// Returns the intersection of the radical axis of the 2 given circles with the line formed by the centers of these circles, 
   /// and the angle of the radical axis from the X axis
   static func radicalAxis(circle1: Circle, circle2: Circle) -> (point: HSPoint, angleFromXAxis: Double)? {
      // from Wikipedia on radical axis:
      let d = circle1.center.distanceToPoint(circle2.center)
      guard !isZero(d) else { return nil }
      let x1 = (d + (square(circle1.radius) - square(circle2.radius)) / d) / 2.0

      if x1 > 0 {
         let centersSegment = HSSegment(vertex1: circle1.center, vertex2: circle2.center)!
         let point = centersSegment.ray.pointAtDistance(x1)
         let angle = centersSegment.angleFromXAxis() + .pi / 2
         return (point, angle)
      }
      else {
         let centersSegment = HSSegment(vertex1: circle2.center, vertex2: circle1.center)!
         let point = centersSegment.ray.pointAtDistance(d - x1)
         let angle = centersSegment.angleFromXAxis() + .pi / 2
         return (point, angle)
      }
   }
   
   /// Returns the points of intersection of this circle with `circle`.
   func intersect(_ circle: Circle) -> [HSPoint] {
      let O1 = center
      let r1 = radius
      let O2 = circle.center
      let r2 = circle.radius
      guard O1 != O2 else { return [] }
      let O1O2 = HSSegment(vertex1: O1, vertex2: O2)!
      let d = O1O2.length
      
      if d > r1 + r2 {
         return []
      }
      
      if (d == r1 + r2) {
         return [O1O2.ray.pointAtDistance(r1)]
      }
      
      let cosVal = (square(r1) + square(d) - square(r2)) / (2 * d * r1)
      let x = abs(r1 * cosVal)
      let P = (cosVal >= 0) ?  O1O2.ray.pointAtDistance(x) : HSRay(vertex: O1, angle: O1O2.ray.angle + .pi).pointAtDistance(x)
      return O1O2.line.perpendicularLineFromPoint(P).intersect(self)
   }
   
   // Shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      if point == center {
         return (radius, center.translate(by: (dx: radius, dy: 0))) // any point on the circle is equally likely a good match
      }
      
      let line = HSLine.line(point1: center, point2: point)!
      let xPoints = line.intersect(self)
      assert(xPoints.count == 2, "Expected 2 intersection points between a cricle and a line through the circle center.")
      
      if point.distanceToPoint(xPoints[0]) < point.distanceToPoint(xPoints[1]) {
         return xPoints[0].distanceFromPoint(point)
      }
      else {
         return xPoints[1].distanceFromPoint(point)
      }
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .circle
   }
}

/// The most basic `Circle` value that can be used for further calculations
/// or to construct a drawable circle on the sketch.
public struct HSCircle : Circle {
   private(set) public var center: Point
   private(set) public var radius: Double
   
   public mutating func translateInPlace(by vector: Vector) {
      center.translateInPlace(by: vector)
   }
}
