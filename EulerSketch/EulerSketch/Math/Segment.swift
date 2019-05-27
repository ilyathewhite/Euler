//
//  Segment.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The segment protocol. Describes the segment vertices.
public protocol Segment: Shape {
   /// Vertex 1.
   var vertex1: Point { get }
   
   /// Vertex 2.
   var vertex2: Point { get }
}

/// Common operations on segments.
public extension Segment {
   /// The segment midpoint.
   var midPoint: HSPoint {
      return HSPoint((vertex1.x + vertex2.x) / 2.0, (vertex1.y + vertex2.y) / 2.0)
   }

   /// Returns whether this segment contains `point`. The point must be on the line going through this segment.
   func containsLinePoint(_ point: Point) -> Bool {
      let minX = min(vertex1.x, vertex2.x)
      let maxX = max(vertex1.x, vertex2.x)
      let minY = min(vertex1.y, vertex2.y)
      let maxY = max(vertex1.y, vertex2.y)
      return (minX <= point.x) && (point.x <= maxX) && (minY <= point.y) && (point.y <= maxY)
   }
   
   /// Returns the intersection of this segment with `segment2`. If the 2 segments don't intersect, returns `nil`.
   func intersect(_ segment2: Segment) -> HSPoint? {
      let segment1 = self
      let intersection = segment1.line.intersect(segment2.line)
      if let point = intersection {
         return segment1.containsLinePoint(point) && segment2.containsLinePoint(point) ? point : nil
      }
      
      return nil
   }
   
   /// Returns the projection of `point` on the line going through this segment.
   func footFromPoint(_ point: Point) -> HSPoint {
      let line2 = line.perpendicularLineFromPoint(point)
      var res = line.intersect(line2)!
      res.kind = .perpendicularSegmentFoot(point, self)
      return res
   }
   
   /// The line going through this segment.
   var line: HSLine { return HSLine.line(point1: vertex1, point2: vertex2)! }
   
   /// The ray going through this segment with vertex `vertex1`.
   var ray: HSRay { return HSRay(vertex: vertex1, angle: angleFromXAxis()) }
   
   /// The bisector (the perpendicular line going through the segment midpoint).
   var bisector: HSLine { return line.perpendicularLineFromPoint(self.midPoint) }

   /// The angle from vector `(1, 0)` to vector from `vertex1` to `vertex2`.
   func angleFromXAxis() -> Double {
      let dx = vertex2.x - vertex1.x
      let dy = vertex2.y - vertex1.y
      let dist = vertex1.distanceToPoint(vertex2)
      
      if (dy >= 0) {
         return acos(dx / dist)
      }
      else {
         return .pi * 2 - acos(dx / dist)
      }
   }
   
   // as vector
   
   // The first scalar component for vector from `vertex1` to `vertex2`.
   var vectorX: Double { return vertex2.x - vertex1.x }

   // The second scalar component for vector from `vertex1` to `vertex2`.
   var vectorY: Double { return vertex2.y - vertex1.y }
   
   // The scalar components for vector from `vertex1` to `vertex2`.
   var vector: [Double] { return [vectorX, vectorY] }
   
   // The segment length.
   var length: Double { return vertex1.distanceToPoint(vertex2) }

   /// The third component for the vector product of the vector from this segment
   /// and the vector from `segment`.
   func vectorProductZaxis(_ segment: Segment) -> Double {
      let u = vector
      let v = segment.vector
      return u[0]*v[1] - u[1]*v[0]
   }
   
   /// The dot product of the vector from this segment and the vector from `segment`.
   func dotProduct(_ segment: Segment) -> Double {
      let u = vector
      let v = segment.vector
      return u[0] * v[0] + u[1] * v[1]
   }
   
   /// The angle (in radians) from the vector from this segment to the vector from `segment`.
   func angleToSegment(_ segment: Segment) -> Double {
      let sign = vectorProductZaxis(segment) > 0 ? 1.0 : -1.0;
      return sign * acos(dotProduct(segment) / (length * segment.length))
   }
   
   ///  The counterclockwise angle (in radians) from the vector from this segment to the vector from `segment`. Can be greater than PI.
   func counterclockwiseAngleToSegment(_ segment: Segment) -> Double {
      let angle = angleToSegment(segment)
      return angle > 0 ? angle : 2 * .pi - angle
   }
   
   // Shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      let foot = footFromPoint(point)
      return (foot.distanceToPoint(point), foot)
   }
   
   func translate(by vector: Vector) {
      _ = vertex1.translate(by: vector)
      _ = vertex2.translate(by: vector)
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .segment
   }
}

public func same(_ s1: Segment, _ s2: Segment) -> Bool {
   return same(s1.vertex1, s2.vertex1) && same(s1.vertex2, s2.vertex2)
}

/// The most basic `Segment` value that can be used for further calculations
/// or to construct a drawable segment on the sketch.
public struct HSSegment: Segment {
   private(set) public var vertex1: Point
   private(set) public var vertex2: Point
   
   public mutating func translateInPlace(by vector: Vector) {
      vertex1.translateInPlace(by: vector)
      vertex2.translateInPlace(by: vector)
   }
   
   public init?(vertex1: Point, vertex2: Point) {
      guard vertex1 != vertex2 else {
         return nil
      }
      
      self.vertex1 = vertex1
      self.vertex2 = vertex2
   }
}
