//
//  Sketch+Dilation.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   // Adds a dilation point from a given point with a given center and scale.
   @discardableResult public func addDilationPoint(_ toPointName: String, fromPoint fromPointName: String, withCenter centerName: String, scale: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeDilation(centerName, scale: scale)
         return addTransformationPoint(toPointName, fromPoint: fromPointName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a dilation segment from a given segment with a given center and scale.
   @discardableResult public func addDilationSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, withCenter centerName: String, scale: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeDilation(centerName, scale: scale)
         return addTransformationSegment(toSegmentName, fromSegment: fromSegmentName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a dilation line from a given line with a given center and scale.
   @discardableResult public func addDilationLine(_ toLineName: String, fromLine fromLineName: String, withCenter centerName: String, scale: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeDilation(centerName, scale: scale)
         return addTransformationLine(toLineName, fromLine: fromLineName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a dilation ray from a given ray with a given center and scale.
   @discardableResult public func addDilationRay(_ toRayName: String, fromRay fromRayName: String, withCenter centerName: String, scale: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeDilation(centerName, scale: scale)
         return addTransformationRay(toRayName, fromRay: fromRayName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a dilation circle from a given circle with a given center and scale.
   @discardableResult public func addDilationCircle(_ toCircleName: String, fromCircle fromCircleName: String, withCenter centerName: String, scale: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeDilation(centerName, scale: scale)
         return addTransformationCircle(toCircleName, fromCircle: fromCircleName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
}
