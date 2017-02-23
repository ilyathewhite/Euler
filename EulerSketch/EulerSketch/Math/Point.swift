//
//  Point.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// Describes how a point is constructed so that it can be reflected in
/// the sketch.
public enum PointKind {
   /// A free (movable) point, or an intersection point. These points
   /// usually look like tiny circles with labels.
   case regular
   
   /// An intersection point of a line or a segment with a line.
   /// The tiny square that usually shows that 2 lines are perpendicular
   /// can be at any side of the intersection.
   case perpendicularLineFoot(Point, Line)
   
   /// The foot of a perpendicular segment to a line or a segment.
   /// The tiny square that usually shows that 2 lines are perpendicular
   /// should be on the half plane that has the segment.
   case perpendicularSegmentFoot(Point, Segment)
   
   /// A point that is used for dragging but was not specified by the user.
   /// For example the point on ray where the ray drawing ends. These points
   /// may not be styled at all.
   case handle
   
   var isRegular: Bool {
      switch self {
      case .regular: return true
      default: return false
      }
   }
   
   var isHandle: Bool {
      switch self {
      case .handle: return true
      default: return false
      }
   }
}

/// The point protocol. Describes the point coordinates and how the point was constructed.
public protocol Point: Shape, CustomStringConvertible {
   /// The `x` coordinate
   var x: Double { get }
   
   /// The `y` coordinate
   var y: Double { get }
   
   /// How the point was constructed. 
   ///
   /// - Remark
   /// While `kind` is not strictly necessary to define a point, this information is easily
   /// lost during calculations. Keeping it part of the protocol is the easiest way to preserve it
   /// because it's enforced by the compiler.
   var kind: PointKind { get }
   
   /// Changes the coordinates. Used for dragging.
   mutating func update(x: Double, y: Double)
}

extension Point {
   public var description: String {
      return "point (\(x),\(y))"
   }
}

public func vector(_ from: Point, _ to: Point) -> Vector {
   return (to.x - from.x, to.y - from.y)
}

public func vector(_ to: Point) -> Vector {
   return (dx: to.x, dy: to.y)
}

/// 2 poitns are equal if they have the same coordinates.
// How they were consttructed doesn't matter.
public func ==(p1: Point, p2: Point) -> Bool {
   return (p1.x == p2.x) && (p1.y == p2.y)
}

/// The negation of equality
public func !=(p1: Point, p2: Point) -> Bool {
   return !(p1 == p2)
}

/// Common operations on points
public extension Point {
   /// Returns a new point translating this point by `(dx, dy)`. 
   func translate(by vector: Vector) -> HSPoint {
      return HSPoint(x + vector.dx, y + vector.dy)
   }

   /// Returns a new point rotating this point by `angle` around the origin `(0, 0)`.
   func rotateAroundOrigin(_ angle: Double) -> HSPoint {
      return HSPoint(x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle))
   }
   
   /// Returns a new point rotating this point by `angle` around `origin`.
   func rotateAroundPoint(_ origin: Point, angle: Double) -> HSPoint {
      return translate(by: (dx: -origin.x, dy: -origin.y)).rotateAroundOrigin(angle).translate(by: (dx: origin.x, dy: origin.y))
   }
   
   /// Returns the distance from this point to `point`.
   func distanceToPoint(_ point: Point) -> Double {
      let dx = point.x - x
      let dy = point.y - y
      return sqrt(square(dx) + square(dy))
   }
   
   // Shape

   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      return (point.distanceToPoint(self), self)
   }
   
   mutating func translateInPlace(by vector: Vector) {
      update(x: x + vector.dx, y: y + vector.dy)
   }
   
   static func namePrefix() -> FigureNamePrefix {
      return .point
   }
   
   // Other
   
   /// The basic value that can be used for further calculations or to construct
   /// a drawable point on the sketch.
   var basicValue: HSPoint { return HSPoint(x, y, kind) }
}

/// The most basic `Point` value that can be used for further calculations
/// or to construct a drawable point on the sketch.
public struct HSPoint: Point {
   private(set) public var x: Double
   private(set) public var y: Double
   
   var basicValue: HSPoint { return self }
   
   public var kind: PointKind
   
   public init(_ value: BasicPoint) {
      self.init(value.x, value.y)
   }
   
   public init(_ x: Double, _ y: Double, _ kind: PointKind) {
      self.x = x
      self.y = y
      self.kind = kind
   }
   
   public init(_ x: Double, _ y: Double) {
      self.x = x
      self.y = y
      self.kind = .regular
   }
   
   public mutating func update(x: Double, y: Double) {
      self.x = x
      self.y = y
   }
}
