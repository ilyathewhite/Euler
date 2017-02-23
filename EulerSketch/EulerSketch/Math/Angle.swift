//
//  Angle.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The angle protocol. Describes a directed angle from one ray to another
/// where the 2 rays have a common vertex.
public protocol Angle: Shape {
   /// Ray 1
   var ray1: Ray { get }
   
   /// Ray 2
   var ray2: Ray { get }
}

/// Common operations on angles
public extension Angle {
   /// The angle vertex.
   var vertex: Point { return ray1.vertex }

   /// The angle value (in radians) from `ray1` to `ray2`.
   var angle: Double {
      let vDist = 1.0
      let O = vertex
      let P = ray1.pointAtDistance(vDist)
      let Q = ray2.pointAtDistance(vDist)
      let OP = HSSegment(vertex1: O, vertex2: P)!
      let OQ = HSSegment(vertex1: O, vertex2: Q)!
      return OP.angleToSegment(OQ)
   }
   
   /// The counterclockwise angle (in radians) from `ray1` to `ray2`. Can be greater then PI.
   var counterclockwiseAngle: Double {
      let vDist = 1.0
      let O = vertex
      let P = ray1.pointAtDistance(vDist)
      let Q = ray2.pointAtDistance(vDist)
      let OP = HSSegment(vertex1: O, vertex2: P)!
      let OQ = HSSegment(vertex1: O, vertex2: Q)!
      return OP.counterclockwiseAngleToSegment(OQ)
   }

   /// The angle bisector.
   var bisector: HSRay {
      let vDist = 1.0
      let O = vertex
      let P = ray1.pointAtDistance(vDist)
      let Q = ray2.pointAtDistance(vDist)
      let M = HSSegment(vertex1: P, vertex2: Q)!.midPoint
      let OM = HSSegment(vertex1: O, vertex2: M)!
      return HSRay(vertex: O, angle: OM.angleFromXAxis())
   }

   /// Returns the angle from ray `OA` to ray `OB`.
   static func angle(p1 A: Point, p2 O: Point, p3 B: Point) -> HSAngle? {
      guard (A != O) && (B != O) else { return nil }
      let OA = HSSegment(vertex1: O, vertex2: A)!
      let OB = HSSegment(vertex1: O, vertex2: B)!
      return HSAngle(ray1: OA.ray, ray2: OB.ray)
   }
   
   // Shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      return vertex.distanceFromPoint(point)
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .angle
   }
}

/// The most basic `Angle` value that can be used for further calculations
/// or to construct a drawable angle on the sketch.
public struct HSAngle : Angle {
   private(set) public var ray1: Ray
   private(set) public var ray2: Ray
   
   public mutating func translateInPlace(by vector: Vector) {
      ray1.translateInPlace(by: vector)
   }
}
