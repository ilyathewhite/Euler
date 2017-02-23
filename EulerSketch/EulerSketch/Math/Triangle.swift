//
//  Triangle.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The Triangle protocol. Describes the triangle by its vertices.
public protocol Triangle {
   /// The triangle vertices.
   var vertices: [Point] { get }
}

/// Common operations on triangles.
public extension Triangle {
   /// The opposite side for a given vertex.
   func oppositeSide(_ vertexIndex: Int) -> HSSegment {
      return HSSegment(vertex1: vertices[(vertexIndex + 1) % 3], vertex2: vertices[(vertexIndex + 2) % 3])!
   }
   
   /// The median from a given vertex.
   func median(_ vertexIndex: Int) -> HSSegment {
      let side = oppositeSide(vertexIndex)
      return HSSegment(vertex1: vertices[vertexIndex], vertex2: side.midPoint)!
   }

   /// The altitude from a given vertex.
   func altitude(_ vertexIndex: Int) -> HSSegment {
      let foot = oppositeSide(vertexIndex).footFromPoint(vertices[vertexIndex])
      return HSSegment(vertex1: vertices[vertexIndex], vertex2: foot)!
   }

   /// The angle bisector from a given vertex.
   func bisector(_ vertexIndex: Int) -> HSSegment {
      let side = oppositeSide(vertexIndex)
      let angle = HSAngle.angle(p1: vertices[(vertexIndex + 1) % 3], p2: vertices[vertexIndex], p3: vertices[(vertexIndex + 2) % 3])!
      let bisectorRay = angle.bisector
      let P = bisectorRay.line.intersect(side.line)!
      return HSSegment(vertex1: vertices[vertexIndex], vertex2: P)!
   }
   
   /// The side bisector (the perpendicular line going through the side midpoint).
   func sideBisector(_ vertexIndex1: Int, vertexIndex2: Int) -> HSLine {
      let side = HSSegment(vertex1: vertices[vertexIndex1], vertex2: vertices[vertexIndex2])!
      return side.bisector
   }

   /// The triangle centroid (the intersection of triangle medians).
   func centroid() -> HSPoint {
      return median(0).intersect(median(1))!
   }

   /// The triangle orthocenter (the intersection of triangle altitudes).
   func orthocenter() -> HSPoint {
      return altitude(0).line.intersect(altitude(1).line)!
   }
   
   /// The triangle incenter (the center of inscribed circle).
   func incenter() -> HSPoint {
      return bisector(0).line.intersect(bisector(1).line)!
   }
   
   /// The triangle circumcenter (the center of the circumscribed circle).
   func circumcenter() -> HSPoint {
      return sideBisector(0, vertexIndex2: 1).intersect(sideBisector(1, vertexIndex2: 2))!
   }
}

/// The most basic `Triangle` value that can be used for further calculations
/// or to construct a drawable triangle on the sketch.
public struct HSTriangle : Triangle {
   private(set) public var vertices: [Point]
   
   public init?(_ p1: Point, _ p2: Point, _ p3: Point) {
      guard (p1 != p2) && (p2 != p3) && (p1 != p3) else { return nil }
      guard let (distance, _) = HSLine.line(point1: p1, point2: p2)?.distanceFromPoint(p3) , distance > 0 else {
         return nil
      }
      vertices = [ p1.basicValue, p2.basicValue, p3.basicValue ]
   }
}
