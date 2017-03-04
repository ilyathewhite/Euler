//
//  Sketch+Point.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   /// Adds a draggable point from a hint for the initial position.
   @discardableResult public func addPoint(_ pointName: String, hint: BasicPoint, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let figure = PointFigure(name: pointName, value: HSPoint(hint))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a draggable point on a circle from a hint for the initial position. The hint position doesn't need to be on the circle.
   @discardableResult public func addPoint(_ pointName: String, onCircle circleName: String, hint: BasicPoint, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let circleFigure: CircleFigure = try getFigure(name: circleName)
         let figure = try PointFigure(name: pointName, circle: circleFigure, hint: HSPoint(hint))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a draggable point on a line from a hint for the initial position. The hint position doesn't need to be on the line.
   @discardableResult public func addPoint(_ pointName: String, onLine lineName: String, hint: BasicPoint, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let lineFigure: LineFigure = try getFigure(name: lineName)
         let figure = try PointFigure(name: pointName, line: lineFigure, hint: HSPoint(hint))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a draggable point on a ray from a hint for the initial position. The hint position doesn't need to be on the ray.
   @discardableResult public func addPoint(_ pointName: String, onRay rayName: String, hint: BasicPoint, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let rayFigure: RayFigure = try getFigure(name: rayName)
         let figure = try PointFigure(name: pointName, ray: rayFigure, hint: HSPoint(hint))
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a point on a ray at a given distance from the vertex.
   @discardableResult public func addPoint(_ pointName: String, onRay rayName: String, atDistanceFromVertex distance: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let rayFigure: RayFigure = try getFigure(name: rayName)         
         let figure = try PointFigure(name: pointName, usedFigures: FigureSet(rayFigure)) {
            return rayFigure.pointAtDistance(distance)
         }
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }

    /// Adds a point on a ray at a given computed distance from the vertex. The computed distance is specified by a callback. 
    // The figures used during computation need to be specified in the `usingFigures` parameter to ensure that when those figures
    /// change, the point is recomputed.
    @discardableResult public func addPoint(_ pointName: String, onRay rayName: String, atComputedDistanceFromVertex distance: @escaping () throws -> Double, usingFigures figureNames: [String], withStyle style: DrawingStyle? = nil) -> FigureResult {
        do {
            let rayFigure: RayFigure = try getFigure(name: rayName)
            var usedFigures = FigureSet(rayFigure)
            let otherUsedFigures = try figureNames.map { (fullName) -> FigureType in
                guard let res = findFigure(fullName: fullName) else { throw SketchError.figureFullNameNotFound(fullName: fullName) }
                return res
            }
            for figure in otherUsedFigures {
                usedFigures.add(figure)
            }

            let figure = try PointFigure(name: pointName, usedFigures: usedFigures) {
                guard let dist = try? distance() else { return nil }
                return rayFigure.pointAtDistance(dist)
            }
            return .success(try addFigure(figure, style: style))
        }
        catch {
            return .failure(error)
        }
    }

   /// Sets the location of the point name relative to the point, for example, top left.
   @discardableResult public func point(_ pointName: String, setNameLocation loc: PointLabelLocation) -> Result<Bool> {
      do {
         let pointFigure: PointFigure = try getFigure(name: pointName)
         pointFigure.labelLocation = loc
         return .success(true)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Simulates dragging a given point to a given location. The intent of this function is to
   /// set the best handle location. Handles for different figures need different full names to avoid
   /// name collisions, so a handle name cannot be deduced from its short name, which is why this function needs
   /// the point full name.
   /// The function is called `dragPoint` instead of `movePoint` because the actual end location may
   /// be different from `location`, which is used only as a hint, exactly as during dragging.
   @discardableResult public func dragPoint(fullName: String, to location: BasicPoint) -> Result<Bool> {
      guard let pointFigure: PointFigure = findFigure(fullName: fullName) as? PointFigure else {
         return .failure(SketchError.invalidValue(argName: fullName))
      }
      let vector = (dx: location.x - pointFigure.x, dy: location.y - pointFigure.y)
      pointFigure.dragUpdateFunc?(pointFigure, vector)
      eval()
      return .success(true)
   }
}
