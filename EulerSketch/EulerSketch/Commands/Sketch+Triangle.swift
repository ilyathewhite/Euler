//
//  Sketch+Triangle.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   fileprivate func getTriangleInfo(_ triangleName: String) throws -> ([PointFigure], [String]) {
      let vertexNames = try scanPointNames(triangleName, expected: .triangle)
      guard vertexNames.count == 3 else {
         throw SketchError.invalidFigureName(name: triangleName, kind: .triangle)
      }
      let vertices = try findVertices(triangleName, expected: .triangle)
      guard vertices.count == 3 else {
         throw SketchError.invalidFigureName(name: triangleName, kind: .triangle)
      }
      guard let _ = HSTriangle(vertices[0], vertices[1], vertices[2]) else {
         throw SketchError.figureNotCreated(name: triangleName, kind: .triangle)
      }
      
      return (vertices, vertexNames)
   }
   
   typealias TrianglePointEvalFunc = (_ p1: Point, _ p2: Point, _ p3: Point) -> HSPoint?
   
   func addTriangleSegment(_ segmentName: String, inTriangle triangleName: String, withStyle style: DrawingStyle? = nil, evalFuncName: String, evalFunc: @escaping TrianglePointEvalFunc) -> FigureResult {
      do {
         let segmentPointNames = try scanPointNames( segmentName, expected: .segment)
         guard segmentPointNames.count == 2 else {
            throw SketchError.invalidFigureName(name:  segmentName, kind: .segment)
         }
         let vertexName = segmentPointNames[0]
         let pointName = segmentPointNames[1]
         
         let (vertices, vertexNames) = try getTriangleInfo(triangleName)
         let vertex: PointFigure = try getFigure(name: vertexName)
         
         func addSegment(_ idx1: Int, _ idx2: Int, _ idx3: Int) throws -> SegmentFigure {
            let point = try PointFigure(name: pointName, usedFigures: FigureSet(vertices)) {
               evalFunc(vertex, vertices[idx2], vertices[idx3])
            }
            try addExtraFigure(point, style: style)
            
            let figure = try SegmentFigure(name:  segmentName, point1: vertices[idx1], point2: point)
            try addFigure(figure, style: style)
            
            return figure
         }
         
         let segment: SegmentFigure
         if vertexName == vertexNames[0] {
            segment = try addSegment(0, 1, 2)
         }
         else if vertexName == vertexNames[1] {
            segment = try addSegment(1, 0, 2)
         }
         else {
            segment = try addSegment(2, 0, 1)
         }
         
         return .success(segment.summary)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a triangle center with a given eval function to a given triangle
   func addTriangleCenter(_ centerName: String, inTriangle triangleName: String, style: DrawingStyle? = nil, evalFuncName: String, evalFunc: @escaping TrianglePointEvalFunc) -> FigureResult {
      do {
         let (vertices, _) = try getTriangleInfo(triangleName)
         
         let figure = try PointFigure(name: centerName, usedFigures: FigureSet(vertices)) {
            evalFunc(vertices[0], vertices[1], vertices[2])
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
}

extension Sketch {
   @discardableResult public func addTriangle(_ triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let (vertices, vertexNames) = try getTriangleInfo(triangleName)
         
         func addSegment(_ idx1: Int, _ idx2: Int) throws {
            let A: PointFigure = vertices[idx1]
            let B: PointFigure = vertices[idx2]
            
            let segmentName = vertexNames[idx1] + vertexNames[idx2]
            let segmentFigure = try SegmentFigure(name: segmentName, point1: A, point2: B)
            try addFigure(segmentFigure, style: style)
         }
         
         try? addSegment(0, 1)
         try? addSegment(1, 2)
         try? addSegment(0, 2)
         
         return .success(FigureSummary(string: "triangle \(triangleName)", sketch: self))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a median (as segment) of a given triangle.
   @discardableResult public func addMedian(_ medianName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleSegment(medianName, inTriangle: triangleName, withStyle: style, evalFuncName: "median") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.median(0).vertex2.basicValue
      }
   }
   
   /// Adds an altitude (as segment) of a given triangle.
   @discardableResult public func addAltitude(_ altitudeName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleSegment(altitudeName, inTriangle: triangleName, withStyle: style, evalFuncName: "altitude") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.altitude(0).vertex2.basicValue
      }
   }
   
   /// Adds a bisector of a given triangle
   @discardableResult public func addBisector(_ bisectorName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleSegment(bisectorName, inTriangle: triangleName, withStyle: style, evalFuncName: "bisector") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.bisector(0).vertex2.basicValue
      }
   }
   
   /// Adds the centroid of a given triangle
   @discardableResult public func addCentroid(_ centroidName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleCenter(centroidName, inTriangle: triangleName, style: style, evalFuncName: "centroid") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.centroid()
      }
   }
   
   /// Adds the orthocenter of a given triangle
   @discardableResult public func addOrthocenter(_ orthocenterName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleCenter(orthocenterName, inTriangle: triangleName, style: style, evalFuncName: "orthocenter") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.orthocenter()
      }
   }

   /// Adds the incenter of a given triangle
   @discardableResult public func addIncenter(_ incenterName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleCenter(incenterName, inTriangle: triangleName, style: style, evalFuncName: "incenter") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.incenter()
      }
   }
   
   /// Adds the excenter of a given triangle opposite a given vertex
   @discardableResult public func addExcenter(_ excenterName: String, ofTriangle triangleName: String, opposite vertexName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let (vertices, _) = try getTriangleInfo(triangleName)
         guard let vertexIndex = vertices.index(where: { $0.name == vertexName }) else {
            return .failure(SketchError.invalidValue(argName: vertexName))
         }
         
         return addTriangleCenter(excenterName, inTriangle: triangleName, style: style, evalFuncName: "excenter") {
            guard let triangle = HSTriangle($0, $1, $2) else { return nil }
            return triangle.excenter(vertexIndex)
         }
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds the circumcenter of a given triangle
   @discardableResult public func addCircumcenter(_ circumcenterName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      return addTriangleCenter(circumcenterName, inTriangle: triangleName, style: style, evalFuncName: "circumcenter") {
         guard let triangle = HSTriangle($0, $1, $2) else { return nil }
         return triangle.circumcenter()
      }
   }

   /// Adds the incircle of a given triangle
   @discardableResult public func addIncircle(_ incircleName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let (vertices, _) = try getTriangleInfo(triangleName)
         
         let figure = try CircleFigure(name: incircleName, usedFigures: FigureSet(vertices)) {
            guard let I = HSTriangle(vertices[0], vertices[1], vertices[2])?.incenter() else { return nil }
            guard let P = HSSegment(vertex1: vertices[0], vertex2: vertices[1])?.footFromPoint(I) else { return nil }
            return HSCircle(center: I, radius: I.distanceToPoint(P))
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds the excircle of a given triangle opposite a given vertex
   @discardableResult public func addExcircle(_ excircleName: String, ofTriangle triangleName: String, opposite vertexName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let (vertices, _) = try getTriangleInfo(triangleName)
         guard let vertexIndex = vertices.index(where: { $0.name == vertexName }) else {
            return .failure(SketchError.invalidValue(argName: vertexName))
         }
         
         let figure = try CircleFigure(name: excircleName, usedFigures: FigureSet(vertices)) {
            guard let I = HSTriangle(vertices[0], vertices[1], vertices[2])?.excenter(vertexIndex) else { return nil }
            guard let P = HSSegment(vertex1: vertices[(vertexIndex + 1) % 3], vertex2: vertices[(vertexIndex + 2) % 3])?.footFromPoint(I) else { return nil }
            return HSCircle(center: I, radius: I.distanceToPoint(P))
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds the circumcircle of a given triangle
   @discardableResult public func addCircumcircle(_ circumcircleName: String, ofTriangle triangleName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let (_, vertexNames) = try getTriangleInfo(triangleName)
         return addCircle(circumcircleName, throughPoints: vertexNames[0], vertexNames[1], vertexNames[2], style: style)
      }
      catch {
         return .failure(error)
      }
   }
}
