//
//  Sketch+Segment.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   internal func addSegmentIfNeeded(_ segmentName: String) {
      do {
         guard !containsFigure(kind: .segment, name: segmentName) else { return }
         
         let pointNames = try scanPointNames(segmentName, expected: .segment)
         guard pointNames.count == 2 else { return }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])

         let figure = try SegmentFigure(name: segmentName, point1: A, point2: B)
         let BAname = B.name + A.name
         if containsFigure(kind: .segment, name: BAname) {
            try addExtraFigure(figure)
            figure.hidden = true
         }
         else {
            try addExtraFigure(figure)
         }
      }
      catch {}
   }
   
   /// Adds a segment. The segment vertices are derived from the segment name. For example, AB is a segment from point A to point B. The 2 vertices must be already added.
   @discardableResult public func addSegment(_ segmentName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let pointNames = try scanPointNames(segmentName, expected: .segment)
         guard pointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: segmentName, kind: .segment)
         }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])
         let figure = try SegmentFigure(name: segmentName, point1: A, point2: B)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a midpoint for a segment.
   @discardableResult public func addMidPoint(_ midPointName: String, ofSegment segmentName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let vertices = try findVertices(segmentName, expected: .segment)
         guard vertices.count == 2 else {
            throw SketchError.invalidFigureName(name: midPointName, kind: .segment)
         }
         let figure = try PointFigure(name: midPointName, usedFigures: FigureSet(vertices)) {
            guard let segment = HSSegment(vertex1: vertices[0], vertex2: vertices[1]) else { return nil }
            return segment.midPoint
         }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a bisector for a segment (the perpendicular line through the midpoint of the segment). The bisector name is expected to be a lowercase letter.
   @discardableResult public func addBisector(_ bisectorName: String, ofSegment segmentName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         guard let segmentFigure = findFigure(name: segmentName, prefix: .segment) as? SegmentFigure else {
            throw SketchError.invalidFigureName(name: segmentName, kind: .segment)
         }
         
         let vertices = try findVertices(segmentName, expected: .segment)
         guard vertices.count == 2 else {
            throw SketchError.invalidFigureName(name: segmentName, kind: .segment)
         }

         let midPointName = FigureNamePrefix.Part.rawValue + "midpoint_" + segmentName
         let midPointFigure = try PointFigure(name: midPointName, usedFigures: FigureSet(vertices)) {
            HSSegment(vertex1: vertices[0], vertex2: vertices[1])?.midPoint
         }
         midPointFigure.updateKind(.perpendicularSegmentFoot(midPointFigure, segmentFigure))
         try addExtraFigure(midPointFigure)
         
         let figure = try CompoundLineFigure(name: bisectorName, vertex: midPointFigure, usedFigures: FigureSet(vertices)) {
            return HSSegment(vertex1: vertices[0], vertex2: vertices[1])!.angleFromXAxis() + M_PI_2
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a perpendicular from a given point to a segment. The name is expected to be 2 capital letters. 
   /// The first letter is for the point from which to construct the perpendicular, and the second letter is for the foot of the perpendicular.
   @discardableResult public func addPerpendicular(_ perpendicularName: String, toSegment segmentName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let perpendicularPointNames = try scanPointNames(perpendicularName, expected: .segment)
         guard perpendicularPointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: perpendicularName, kind: .segment)
         }
         let vertexName = perpendicularPointNames[0]
         let footName = perpendicularPointNames[1]
         
         let vertexFigure: PointFigure = try getFigure(name: vertexName)
         let segmentFigure: SegmentFigure = try getFigure(name: segmentName)
         
         let footFigure = try PointFigure(name: footName, usedFigures: FigureSet([vertexFigure, segmentFigure])) {
            segmentFigure.footFromPoint(vertexFigure)
         }
         try addExtraFigure(footFigure, style: style)
         
         let figure = try SegmentFigure(name: perpendicularName, point1: vertexFigure, point2: footFigure)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a given mark count for a given segment.
   public func setMarkCount(_ count: Int, forSegment segmentName: String) -> Result<Bool> {
      do {
         let segmentFigure: SegmentFigure = try getFigure(name: segmentName)
         segmentFigure.markCount = count
         return .success(true)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Changes a given segment drawing to contain only equality marks, if any.
   public func drawMarksOnly(forSegment segmentName: String) -> Result<Bool> {
      do {
         let segmentFigure: SegmentFigure = try getFigure(name: segmentName)
         segmentFigure.drawMarksOnly = true
         return .success(true)
      }
      catch {
         return .failure(error)
      }
   }
   
}
