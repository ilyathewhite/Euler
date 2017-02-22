//
//  Sketch+LineReflection.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   // Adds a reflection point from a given point with a given mirror line.
   @discardableResult public func addReflectionPoint(_ toPointName: String, fromPoint fromPointName: String, withMirrorLine mirrorLineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeReflection(mirrorLineName)
         return addTransformationPoint(toPointName, fromPoint: fromPointName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a reflection segment from a given segment with a given mirror line.
   @discardableResult public func addReflectionSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, withMirrorLine mirrorLineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeReflection(mirrorLineName)
         return addTransformationSegment(toSegmentName, fromSegment: fromSegmentName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a reflection line from a given line with a given mirror line.
   @discardableResult public func addReflectionLine(_ toLineName: String, fromLine fromLineName: String, withMirrorLine mirrorLineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeReflection(mirrorLineName)
         return addTransformationLine(toLineName, fromLine: fromLineName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a reflection ray from a given ray with a given mirror line.
   @discardableResult public func addReflectionRay(_ toRayName: String, fromRay fromRayName: String, withMirrorLine mirrorLineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeReflection(mirrorLineName)
         return addTransformationRay(toRayName, fromRay: fromRayName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a reflection circle from a given circle with a given mirror line.
   @discardableResult public func addReflectionCircle(_ toCircleName: String, fromCircle fromCircleName: String, withMirrorLine mirrorLineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeReflection(mirrorLineName)
         return addTransformationCircle(toCircleName, fromCircle: fromCircleName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
}
