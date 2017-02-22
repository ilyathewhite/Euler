//
//  Sketch+Rotation.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   // Adds a rotation point from a given point with a given center and angle.
   @discardableResult public func addRotationPoint(_ toPointName: String, fromPoint fromPointName: String, withCenter centerName: String, degAngle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeRotation(centerName, degAngle: degAngle)
         return addTransformationPoint(toPointName, fromPoint: fromPointName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a rotation segment from a given segment with a given center and angle.
   @discardableResult public func addRotationSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, withCenter centerName: String, degAngle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeRotation(centerName, degAngle: degAngle)
         return addTransformationSegment(toSegmentName, fromSegment: fromSegmentName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a rotation line from a given line with a given center and angle.
   @discardableResult public func addRotationLine(_ toLineName: String, fromLine fromLineName: String, withCenter centerName: String, degAngle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeRotation(centerName, degAngle: degAngle)
         return addTransformationLine(toLineName, fromLine: fromLineName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a rotation ray from a given ray with a given center and angle.
   @discardableResult public func addRotationRay(_ toRayName: String, fromRay fromRayName: String, withCenter centerName: String, degAngle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeRotation(centerName, degAngle: degAngle)
         return addTransformationRay(toRayName, fromRay: fromRayName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   // Adds a rotation circle from a given cirlce with a given center and angle.
   @discardableResult public func addRotationCircle(_ toCircleName: String, fromCircle fromCircleName: String, withCenter centerName: String, degAngle: Double, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeRotation(centerName, degAngle: degAngle)
         return addTransformationCircle(toCircleName, fromCircle: fromCircleName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
}
