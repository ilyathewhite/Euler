//
//  Sketch+Transformations.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   struct TransformationInfo {
      var name: String
      var f: (Point) -> HSPoint
      var usedFigures: [FigureType]
   }
   
   /// Adds a point that is transformed from another point. If the given point changes, the tranformed point is changed by reapplying the transform.
   @discardableResult func addTransformationPoint(_ toPointName: String, fromPoint fromPointName: String, transformInfo: TransformationInfo, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let point: PointFigure = try getFigure(name: fromPointName)
         let figure = try PointFigure(name: toPointName, usedFigures: FigureSet(transformInfo.usedFigures + [point])) {
            return transformInfo.f(point)
         }
         
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a segment that is transformed from another segment. If the given segment changes, the tranformed segment is changed by reapplying the transform.
   @discardableResult func addTransformationSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, transformInfo: TransformationInfo, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let segment: SegmentFigure = try getFigure(name: fromSegmentName)
         let pointNames = try scanPointNames(toSegmentName, expected: .segment)
         guard pointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: toSegmentName, kind: .segment)
         }
         
         addTransformationPoint(pointNames[0], fromPoint: (segment.vertex1 as! PointFigure).name, transformInfo: transformInfo)
         let A: PointFigure = try getFigure(name: pointNames[0])
         
         addTransformationPoint(pointNames[1], fromPoint: (segment.vertex2 as! PointFigure).name, transformInfo: transformInfo)
         let B: PointFigure = try getFigure(name: pointNames[1])
         
         let figure = try SegmentFigure(name: toSegmentName, point1: A, point2: B)
         try addFigure(figure, style: style)
         figure.dragUpdateFunc = nil
         return .success(figure.summary)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a line that is transformed from another line. If the given line changes, the tranformed line is changed by reapplying the transform.
   @discardableResult func addTransformationLine(_ toLineName: String, fromLine fromLineName: String, transformInfo: TransformationInfo, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let pointNames = try scanPointNames(fromLineName, expected: .line)
         let resPointNames = try scanPointNames(toLineName, expected: .line)
         
         let figure = try { () throws -> SimpleLineFigure in
            if resPointNames.count == 2 {
               guard pointNames.count == 2 else {
                  throw SketchError.figureNotCreated(name: toLineName, kind: .line)
               }
               
               addTransformationPoint(resPointNames[0], fromPoint: pointNames[0], transformInfo: transformInfo)
               let A: PointFigure = try getFigure(name: resPointNames[0])
               addTransformationPoint(resPointNames[1], fromPoint: pointNames[1], transformInfo: transformInfo)
               let B: PointFigure = try getFigure(name: resPointNames[1])
               
               return try SimpleLineFigure(name: toLineName, point1: A, point2: B)
            }
            else {
               throw SketchError.figureNotCreated(name: toLineName, kind: .line)
            }
         }()
         
         try addFigure(figure, style: style)
         figure.dragUpdateFunc = nil
         return .success(figure.summary)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a ray that is transformed from another ray. If the given ray changes, the tranformed ray is changed by reapplying the transform.
   @discardableResult func addTransformationRay(_ toRayName: String, fromRay fromRayName: String, transformInfo: TransformationInfo, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let ray: RayFigure = try getFigure(name: fromRayName)
         let pointNames = try scanPointNames(fromRayName, expected: .ray)
         let resPointNames = try scanPointNames(toRayName, expected: .ray)
         
         let figure = try { () throws -> RayFigure in
            if resPointNames.count == 2 {
               guard pointNames.count == 2 else {
                  throw SketchError.figureNotCreated(name: toRayName, kind: .ray)
               }
               
               addTransformationPoint(resPointNames[0], fromPoint: pointNames[0], transformInfo: transformInfo)
               let A: PointFigure = try getFigure(name: resPointNames[0])
               addTransformationPoint(resPointNames[1], fromPoint: pointNames[1], transformInfo: transformInfo)
               let B: PointFigure = try getFigure(name: resPointNames[1])
               
               return try RayFigure(name: toRayName, vertex: A, point: B)
            }
            else {
               return try RayFigure(name: toRayName, usedFigures: FigureSet(transformInfo.usedFigures + [ray])) {
                  let vertex = transformInfo.f(ray.vertex)
                  let handle = transformInfo.f(ray.handle)
                  return HSSegment(vertex1: vertex, vertex2: handle)?.ray
               }
            }
         }()
         
         try addFigure(figure, style: style)
         figure.dragUpdateFunc = nil
         return .success(figure.summary)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a cirlce that is transformed from another circle. If the given cirlce changes, the tranformed circle is changed by reapplying the transform.
   @discardableResult func addTransformationCircle(_ toCircleName: String, fromCircle fromCircleName: String, transformInfo: TransformationInfo, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let circle: CircleFigure = try getFigure(name: fromCircleName)
         
         let figure = try CircleFigure(name: toCircleName, usedFigures: FigureSet(transformInfo.usedFigures + [circle])) {
            let center = transformInfo.f(circle.center)
            let handle = transformInfo.f(HSPoint(circle.center.x + circle.radius, circle.center.y))
            let radius = center.distanceToPoint(handle)
            return HSCircle(center: center, radius: radius)
         }
         
         try addFigure(figure, style: style)
         figure.dragUpdateFunc = nil
         return .success(figure.summary)
      }
      catch {
         return .failure(error)
      }
   }
}

extension Sketch {
   /// Creates a translation tranformation from a given vector that is specified by the two points in the vector name.
   func makeTranslation(_ vectorName: String) throws -> TransformationInfo {
      let pointNames = try scanPointNames(vectorName, expected: .segment)
      guard pointNames.count == 2 else {
         throw SketchError.invalidFigureName(name: vectorName, kind: .vector)
      }
      let A: PointFigure = try getFigure(name: pointNames[0])
      let B: PointFigure = try getFigure(name: pointNames[1])
      
      return TransformationInfo(name: "translation", f: { $0.translate(by: vector(A, B)) }, usedFigures: [A, B] )
   }
   
   /// Creates a translation transformation from a given vector.
   func makeTranslation(_ vector: Vector) -> TransformationInfo {
      return TransformationInfo(name: "translation", f: { $0.translate(by: vector) }, usedFigures: [] )
   }

   /// Creates a rotation transformation from a given point and angle.
   func makeRotation(_ centerName: String, degAngle: Double) throws -> TransformationInfo {
      let angle = toRadians(degAngle)
      let O: PointFigure = try getFigure(name: centerName)
      return TransformationInfo(name: "rotation", f: { $0.rotateAroundPoint(O, angle: angle) }, usedFigures: [O])
   }

   /// Creates a dilation transformation with a given center and scale.
   func makeDilation(_ centerName: String, scale: Double) throws -> TransformationInfo {
      let O: PointFigure = try getFigure(name: centerName)
      func dilation(_ point: Point) -> HSPoint {
         guard let segment = HSSegment(vertex1: O, vertex2: point) else { return O.value }
         let angle = scale > 0 ? segment.ray.angle : segment.ray.angle + M_PI
         return HSRay(vertex: O, angle: angle).pointAtDistance(O.distanceToPoint(point) * abs(scale))
      }
      return TransformationInfo(name: "dilation", f: dilation, usedFigures: [O])
   }
   
   // Creates a reflection transformation from a given line as the mirror.
   func makeReflection(_ mirrorLineName: String) throws -> TransformationInfo {
      let line: LineFigure = try getFigure(name: mirrorLineName)
      
      func reflection(_ point: Point) -> HSPoint {
         let foot = line.footFromPoint(point)
         guard let ray = HSSegment(vertex1: point, vertex2: foot)?.ray else { return foot }
         return ray.pointAtDistance(2 * point.distanceToPoint(foot))
      }
      return TransformationInfo(name: "reflection", f: reflection, usedFigures: [line])
   }

   // Creates a reflection transformation from a given as the center.
   func makePointReflection(_ centerName: String) throws -> TransformationInfo {
      let O: PointFigure = try getFigure(name: centerName)
      func reflection(_ point: Point) -> HSPoint {
         guard let ray = HSSegment(vertex1: point, vertex2: O)?.ray else { return O.basicValue }
         return ray.pointAtDistance(2 * point.distanceToPoint(O))
      }
      return TransformationInfo(name: "reflection", f: reflection, usedFigures: [O])
   }
}
