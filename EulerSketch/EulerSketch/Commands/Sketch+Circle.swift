//
//  Sketch+Circle.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   /// Adds a tangent segment to a circle from a given point. The tangent name is formed by the point from which the tangent is constructed
   /// (an existing point) and the point of tangency (a new point). The `selector` parameter selects a specific tangent point from the available tangent points.
   @discardableResult public func addTangent(_ tangentName: String, toCircle circleName: String, style: DrawingStyle? = nil, selector: @escaping ([HSPoint]) -> HSPoint?) -> FigureResult {
      do {
         let tangentPointNames = try scanPointNames(tangentName, expected: .segment)
         guard tangentPointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: tangentName, kind: .segment)
         }
         
         let point1: PointFigure = try getFigure(name: tangentPointNames[0])
         let circle: CircleFigure = try getFigure(name: circleName)
         let point2 = try PointFigure(name: tangentPointNames[1], usedFigures: FigureSet([point1, circle])) {
            let tangentPoints = circle.tangentPointsFromPoint(point: point1)
            return selector(tangentPoints)
         }
         try addExtraFigure(point2, style: style)
         
         return addSegment(tangentName, style: style)
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a circle with a given center (specified by its coordinates) and radius.
   /// The circle center is fixed, but the radius may be changed by dragging the circle.
   @discardableResult public func addCircle(_ circleName: String, withCenter center: BasicPoint, hintRadius radius: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let figure = CircleFigure(name: circleName, center.x, center.y, hintRadius: radius)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a circle with a given center (specified by the point name) and a radius.
   /// The radius can be changed by dragging the circle, and the center can be change as well if the point is draggable.
   @discardableResult public func addCircle(_ circleName: String, withCenter centerName: String, hintRadius radius: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let O: PointFigure = try getFigure(name: centerName)
         let figure = try CircleFigure(name: circleName, center: O, hintRadius: radius)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a circle with a given center (specified by the point name) that goes through a given point.
   @discardableResult public func addCircle(_ circleName: String, withCenter centerName: String, throughPoint pointName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let O: PointFigure = try getFigure(name: centerName)
         let A: PointFigure = try getFigure(name: pointName)
         let figure = try CircleFigure(name: circleName, center: O, throughPoint: A)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a circle going through 3 points (if those points form a triangle).
   @discardableResult public func addCircle(_ circleName: String, throughPoints p1: String, _ p2: String, _ p3: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         func f(_ pointName: String) throws -> PointFigure {
            return try getFigure(name: pointName)
         }
         
         let figure = try CircleFigure(name: circleName, point1: try f(p1), point2: try f(p2), point3: try f(p3))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
}

extension Sketch {
   /// Adds a radical axis for 2 circles. The bisector name is expected to be a lowercase letter.
   @discardableResult public func addRadicalAxis(_ radicalAxisName: String, ofCircles circle1Name: String, _ circle2Name: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         guard let circle1Figure = findFigure(name: circle1Name, prefix: .circle) as? CircleFigure else {
            throw SketchError.invalidFigureName(name: circle1Name, kind: .segment)
         }

         guard let circle2Figure = findFigure(name: circle2Name, prefix: .circle) as? CircleFigure else {
            throw SketchError.invalidFigureName(name: circle2Name, kind: .segment)
         }
         
         let circles = FigureSet([circle1Figure, circle2Figure])
         
         let pointName = FigureNamePrefix.Part.rawValue + "radicalAxisPoint_" + radicalAxisName
         let pointFigure = try PointFigure(name: pointName, usedFigures: circles) {
            guard let (point, _) = HSCircle.radicalAxis(circle1: circle1Figure, circle2: circle2Figure) else { return nil }
            return point
         }
         pointFigure.hidden = true
         
         try addExtraFigure(pointFigure)
         
         let figure = try CompoundLineFigure(name: radicalAxisName, vertex: pointFigure, usedFigures: circles) {
            guard let (_, angle) = HSCircle.radicalAxis(circle1: circle1Figure, circle2: circle2Figure) else { return 0 }
            return angle
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
}
