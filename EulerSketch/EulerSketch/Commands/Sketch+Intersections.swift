//
//  Sketch+Intersections.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   /// Adds the intersection point between 2 given lines.
   @discardableResult public func addIntersection(_ pointName: String, ofLine line1Name: String, andLine line2Name: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let line1: LineFigure = try getFigure(name: line1Name)
         let line2: LineFigure = try getFigure(name: line2Name)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([line1, line2])) {
            line1.intersect(line2)
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds the intersection point between 2 given segments.
   @discardableResult public func addIntersection(_ pointName: String, ofSegment segment1Name: String, andSegment segment2Name: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let segment1: SegmentFigure = try getFigure(name: segment1Name)
         let segment2: SegmentFigure = try getFigure(name: segment2Name)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([segment1, segment2])) {
            guard let point = segment1.intersect(segment2) else { return nil }
            return point
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds the intersection point between a given line and segment.
   @discardableResult public func addIntersection(_ pointName: String, ofSegment segmentName: String, andLine lineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let segment: SegmentFigure = try getFigure(name: segmentName)
         let line: LineFigure = try getFigure(name: lineName)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([segment, line])) {
            guard let point = segment.line.intersect(line) else { return nil }
            guard segment.containsLinePoint(point) else { return nil }
            return point
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds the intersection point between a given ray and line.
   @discardableResult public func addIntersection(_ pointName: String, ofRay rayName: String, andLine lineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let ray: RayFigure = try getFigure(name: rayName)
         let line: LineFigure = try getFigure(name: lineName)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([ray, line])) {
            guard let point = ray.line.intersect(line) else { return nil }
            guard ray.containsLinePoint(point) else { return nil }
            return point
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds the intersection point between 2 given rays.
   @discardableResult public func addIntersection(_ pointName: String, ofRay ray1Name: String, andRay ray2Name: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let ray1: RayFigure = try getFigure(name: ray1Name)
         let ray2: RayFigure = try getFigure(name: ray2Name)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([ray1, ray2])) {
            guard let point = ray1.line.intersect(ray2.line) else { return nil }
            guard ray1.containsLinePoint(point) else { return nil }
            guard ray2.containsLinePoint(point) else { return nil }
            return point
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds one of the intersection points between a given ray and circle. The `selector` parameter selects a specific intersection point from the available intersection points.
   @discardableResult public func addIntersection(_ pointName: String, ofRay rayName: String, andCircle circleName: String, style: DrawingStyle? = nil, selector: @escaping ([HSPoint]) -> HSPoint?) -> FigureResult {
      do {
         let ray: RayFigure = try getFigure(name: rayName)
         let circle: CircleFigure = try getFigure(name: circleName)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([ray, circle])) { selector(ray.intersect(circle)) }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds one of the intersection points between a given line and circle. The `selector` parameter selects a specific intersection point from the available intersection points.
   @discardableResult public func addIntersection(_ pointName: String, ofLine lineName: String, andCircle circleName: String, style: DrawingStyle? = nil, selector: @escaping ([HSPoint]) -> HSPoint?) -> FigureResult {
      do {
         let line: LineFigure = try getFigure(name: lineName)
         let circle: CircleFigure = try getFigure(name: circleName)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([line, circle])) { selector(line.intersect(circle)) }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds one of the intersection points between two given circles. If there is more than one point,
   /// the function orders the intersection points in a given way and adds the one specified by `index`, which could be 0 or 1.
   @discardableResult public func addIntersection(_ pointName: String, ofCircle circle1Name: String, andCircle circle2Name: String, style: DrawingStyle? = nil, selector: @escaping ([HSPoint]) -> HSPoint?) -> FigureResult {
      do {
         let circle1: CircleFigure = try getFigure(name: circle1Name)
         let circle2: CircleFigure = try getFigure(name: circle2Name)
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet([circle1, circle2])) { selector(circle1.intersect(circle2)) }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
}
