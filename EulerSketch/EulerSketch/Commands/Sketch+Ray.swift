//
//  Sketch+Ray.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   internal func addRayIfNeeded(_ rayName: String) {
      do {
         guard !containsFigure(kind: .ray, name: rayName) else { return }
         
         let pointNames = try scanPointNames(rayName, expected: .ray)
         guard pointNames.count == 2 else { return }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])
         
         try addExtraFigure(RayFigure(name: rayName, vertex: A, point: B))
      }
      catch {}
   }
   
   /// Adds a ray from one existing point to another. The ray name is expected to be 2 capital letters for the 2 points (already added).
   @discardableResult public func addRay(_ rayName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let pointNames = try scanPointNames(rayName, expected: .ray)
         guard pointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: rayName, kind: .ray)
         }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])
         let figure = try RayFigure(name: rayName, vertex: A, point: B)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a ray from an existing point so that the ray forms a given counterclockwise angle (in degrees) with the X axis. The ray name is expected to have 1 lowercase letter.
   @discardableResult public func addRay(_ rayName: String, fromPoint pointName: String, withHintAngleFromXaxis angle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let A: PointFigure = try getFigure(name: pointName)
         let figure = try RayFigure(name: rayName, vertex: A, angle: toRadians(angle))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a ray from an existing point so that the ray forms a given counterclockwise angle (in degrees) from a given ray. The ray name is expected to have 1 lowercase letter.
   @discardableResult public func addRay(_ rayName: String, fromPoint pointName: String, withAngle angle: Double, fromRay fromRayName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let A: PointFigure = try getFigure(name: pointName)
         let fromRay: RayFigure = try getFigure(name: fromRayName)
         let figure = try RayFigure(name: rayName, usedFigures: FigureSet([A, fromRay])) {
            HSRay(vertex: A, angle: fromRay.angle + toRadians(angle))
         }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds an angle mark to an angle formed by 2 rays with a common vertex.
   @discardableResult public func addAngleMark(count: Int, fromRay ray1Name: String, toRay ray2Name: String) -> Result<Bool> {
      do {
         let ray1: RayFigure = try getFigure(name: ray1Name)
         let ray2: RayFigure = try getFigure(name: ray2Name)         
         guard ray1.vertexFigure == ray2.vertexFigure else {
            throw SketchError.invalidCommonVertex(ray1: ray1Name, ray2: ray2Name)
         }
         
         ray1.vertexFigure.addAngleMark(ray1: ray1, ray2: ray2, count: count)
         
         return .success(true)
      }
      catch {
         return .failure(error)
      }
   }
   
}
