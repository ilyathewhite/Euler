//
//  Sketch+Translation.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   
   /// Adds a translation point from a given point and vector.
   @discardableResult public func addTranslationPoint(_ toPointName: String, fromPoint fromPointName: String, byVector vectorName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeTranslation(vectorName)
         return addTransformationPoint(toPointName, fromPoint: fromPointName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a translation segment from a given segment and vector.
   @discardableResult public func addTranslationSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, byVector vectorName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeTranslation(vectorName)
         return addTransformationSegment(toSegmentName, fromSegment: fromSegmentName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a translation line from a given line and vector.
   @discardableResult public func addTranslationLine(_ toLineName: String, fromLine fromLineName: String, byVector vectorName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeTranslation(vectorName)
         return addTransformationLine(toLineName, fromLine: fromLineName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a translation ray from a given ray and vector.
   @discardableResult public func addTranslationRay(_ toRayName: String, fromRay fromRayName: String, byVector vectorName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeTranslation(vectorName)
         return addTransformationRay(toRayName, fromRay: fromRayName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }

   /// Adds a translation circle from a given circle and vector.
   @discardableResult public func addTranslationCircle(_ toCircleName: String, fromCircle fromCircleName: String, byVector vectorName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let transformationInfo = try makeTranslation(vectorName)
         return addTransformationCircle(toCircleName, fromCircle: fromCircleName, transformInfo: transformationInfo, style: style)
      }
      catch {
         return .failure(error)
      }
   }
   
   /// Adds a translation point from a given point and vector.
   @discardableResult public func addTranslationPoint(_ toPointName: String, fromPoint fromPointName: String, byVector vector: Vector, style: DrawingStyle? = nil) -> FigureResult {
      let transformationInfo = makeTranslation(vector)
      return addTransformationPoint(toPointName, fromPoint: fromPointName, transformInfo: transformationInfo, style: style)
   }
   
   /// Adds a translation segment from a given segment and vector.
   @discardableResult public func addTranslationSegment(_ toSegmentName: String, fromSegment fromSegmentName: String, byVector vector: Vector, style: DrawingStyle? = nil) -> FigureResult {
      let transformationInfo = makeTranslation(vector)
      return addTransformationSegment(toSegmentName, fromSegment: fromSegmentName, transformInfo: transformationInfo, style: style)
   }
   
   /// Adds a translation line from a given line and vector.
   @discardableResult public func addTranslationLine(_ toLineName: String, fromLine fromLineName: String, byVector vector: Vector, style: DrawingStyle? = nil) -> FigureResult {
      let transformationInfo = makeTranslation(vector)
      return addTransformationLine(toLineName, fromLine: fromLineName, transformInfo: transformationInfo, style: style)
   }
   
   /// Adds a translation ray from a given ray and vector.
   @discardableResult public func addTranslationRay(_ toRayName: String, fromRay fromRayName: String, byVector vector: Vector, style: DrawingStyle? = nil) -> FigureResult {
      let transformationInfo = makeTranslation(vector)
      return addTransformationRay(toRayName, fromRay: fromRayName, transformInfo: transformationInfo, style: style)
   }
   
   /// Adds a translation circle from a given circle and vector.
   @discardableResult public func addTranslationCircle(_ toCircleName: String, fromCircle fromCircleName: String, byVector vector: Vector, style: DrawingStyle? = nil) -> FigureResult {
      let transformationInfo = makeTranslation(vector)
      return addTransformationCircle(toCircleName, fromCircle: fromCircleName, transformInfo: transformationInfo, style: style)
   }
}
