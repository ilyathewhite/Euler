//
//  CircleFigure.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// A specific circle figure. Overrides the generic `draw` method, and provides convenience constructors.
class CircleFigure: Figure<HSCircle>, Circle {
   // Circle protocol
   
   var center: Point { return value.center }
   var radius: Double { return value.radius }
   
   // draw
   
   override func draw(_ renderer: Renderer) {
      super.draw(renderer)
      renderer.drawCircle(center: center, radius: radius)
   }
   
   override var dragEndMessage: String  {
      return "finished dragging \(fullName), radius = \(radius)"
   }
   
   // init
   
   /// Creates an eval function that returns a circle with a given center and radius.
   static func makeEvalFunc(_ center: Point, radius: Double) -> EvalFunc {
      return { HSCircle(center: center, radius: radius) }
   }

   /// The drag update function. Changes the radius of the circle to match the dragged point.
   func radiusUpdateFunc(from point: Point?, by vector: Vector) {
      if let point = point {
         let radius = self.center.distanceToPoint(point.translate(by: vector))
         evalFunc = CircleFigure.makeEvalFunc(self.center, radius: radius)
      }
   }
   
   override init(name: String, usedFigures: FigureSet, evalFunc: @escaping EvalFunc) throws {
      try super.init(name: name, usedFigures: usedFigures, evalFunc: evalFunc)
   }
   
   /// Creates a circle that goes through 3 points.
   init(name: String, point1 A: PointFigure, point2 B: PointFigure, point3 C: PointFigure) throws {
      try super.init(name: name, usedFigures: FigureSet([A, B, C])) { HSCircle.circle(point1: A, point2: B, point3: C) }
   }

   /// Creates a circle with a given center and a radius.
   init(name: String, center O: PointFigure, hintRadius radius: Double) throws {
      try super.init(name: name, usedFigures: FigureSet(O)) { HSCircle(center: O, radius: radius) }
      dragUpdateFunc = radiusUpdateFunc
   }

   /// Creates a circle with a given center that goes through a given point.
   init(name: String, center O: PointFigure, throughPoint A: PointFigure) throws {
      try super.init(name: name, usedFigures: FigureSet([O, A])) { HSCircle(center: O, radius: O.distanceToPoint(A)) }
   }
   
   /// Creates a circle with given center coordinates and a given radius.
   init(name: String, _ centerX: Double, _ centerY: Double, hintRadius radius: Double) {
      super.init(name: name, value: HSCircle(center: HSPoint(centerX, centerY), radius: radius))
      dragUpdateFunc = radiusUpdateFunc
   }
}
