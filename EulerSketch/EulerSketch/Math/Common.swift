//
//  Common.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The vector type. The tuple representation is very convenient for scripts.
public typealias Vector = (dx: Double, dy: Double)

// A basic point for commands
public typealias BasicPoint = (x: Double, y: Double)

/// The larest possible error of computation at which 2 values are considered the same.
/// Used to for assertions in computations.
public let epsilon = 0.0000000001

/// Returns whether two values differ by less than `epsilon`, which is as close to == as we can get for `Double` values.
public func same(_ lhs: Double, _ rhs: Double) -> Bool {
   return abs(lhs - rhs) < epsilon
}

/// Returns whether a value differs from 0 by less than `epsilon` which is as close to zero as we can get for `Double` values.
public func isZero(_ value: Double) -> Bool {
   return same(value, 0)
}

/// Converts degrees to radians.
public func toRadians(_ degrees: Double) -> Double {
   return M_PI / 180.0 * degrees
}

/// Converts radians to degrees.
public func toDegrees(_ radians: Double) -> Double {
   return radians / M_PI * 180.0
}

/// Squares the argument.
public func square(_ x: Double) -> Double { return x * x }

/// Describes the basic APIs that every geometric shape should have.
public protocol Shape {
   /// Returns the shape's closed point and distance to that point from `point`.
   func distanceFromPoint(_ point: Point) -> (Double, Point)
   
   /// Translates the shape by `(dx, dy)`.
   mutating func translateInPlace(by vector: Vector)
   
   /// Returns the name prefix for the type of shape.
   static func namePrefix() -> FigureNamePrefix
}

public func rightPoint(_ points: [HSPoint]) -> HSPoint? {
   return points.max { $0.x < $1.x }
}

public func leftPoint(_ points: [HSPoint]) -> HSPoint? {
   return points.min { $0.x < $1.x }
}

public func topPoint(_ points: [HSPoint]) -> HSPoint? {
   return points.max { $0.y < $1.y }
}

public func bottomPoint(_ points: [HSPoint]) -> HSPoint? {
   return points.min { $0.y < $1.y }
}
