//
//  Ray.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The ray protocol. Describes the ray via its vertex and the angle with the x axis.
public protocol Ray: Shape {
   /// The vertex.
   var vertex: Point { get }
   
   /// The angle (in radians) from the x axis.
   var angle: Double { get }
   
   /// Changes the ray.
   mutating func update(_ vertex: Point, angle: Double)
}

/// Common operations on rays.
public extension Ray {
   /// The line containing the ray.
   var line: HSLine { return HSLine.line(point: vertex, angle: angle) }

   /// Whether the ray contains `point` from the line containing the ray.
   func containsLinePoint(_ point: Point) -> Bool {
      if vertex == point {
         return true
      }
      
      let cos1Val = cos(angle)
      let cos2Val = cos(HSSegment(vertex1: vertex, vertex2: point)!.angleFromXAxis())
      return ((cos1Val > 0) && (cos2Val > 0)) || ((cos1Val < 0) && (cos2Val < 0))
   }
   
   /// Returns the point at a given distance from the vertex.
   func pointAtDistance(_ dist: Double) -> HSPoint {
      for point in line.pointsAtDistance(dist, fromPoint: vertex) {
         if containsLinePoint(point) {
            return point
         }
      }
      
      assertionFailure()
      return HSPoint(0, 0)
   }
   
   /// Returns the intersection points of this ray with `circle`.
   func intersect(_ circle: Circle) -> [HSPoint] {
      return line.intersect(circle).filter { containsLinePoint($0) }.sorted {
         vertex.distanceToPoint($0) < vertex.distanceToPoint($1)
      }
   }
   
   // Shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      return line.distanceFromPoint(point) // not quite right, but correct for Euler
   }
   
   mutating func translateInPlace(by vector: Vector) {
      update(vertex.translate(by: vector), angle: angle)
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .ray
   }
}

/// The most basic `Ray` value that can be used for further calculations
/// or to construct a drawable ray on the sketch.
public struct HSRay: Ray {
   private(set) public var vertex: Point
   private(set) public var angle: Double
   
   public mutating func update(_ vertex: Point, angle: Double) {
      self.vertex = vertex
      self.angle = angle
   }
}
