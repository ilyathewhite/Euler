//
//  Sketch+Line.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

extension Sketch {
   internal func addLineIfNeeded(_ lineName: String) {
      do {
         guard !containsFigure(kind: .line, name: lineName) else { return }
         
         let pointNames = try scanPointNames(lineName, expected: .line)
         guard pointNames.count == 2 else { return }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])
         
         let figure = try SimpleLineFigure(name: lineName, point1: A, point2: B)
         let BAname = B.name + A.name
         if containsFigure(kind: .line, name: BAname) {
            try addExtraFigure(figure)
            figure.hidden = true
         }
         else {
            try addExtraFigure(figure)
         }
      }
      catch {}
   }
   
   /// Adds a line going through 2 exising points. The line name is expected to be 2 capital letters for the 2 points (already added).
   @discardableResult public func addLine(_ lineName: String, style: DrawingStyle? = nil) -> FigureResult {
      do {
         let pointNames = try scanPointNames(lineName, expected: .line)
         guard pointNames.count == 2 else {
            throw SketchError.invalidFigureName(name: lineName, kind: .line)
         }
         let A: PointFigure = try getFigure(name: pointNames[0])
         let B: PointFigure = try getFigure(name: pointNames[1])
         let figure = try SimpleLineFigure(name: lineName, point1: A, point2: B)
         return .success(try addFigure(figure, style: style))
      }
      catch {
         return .failure(error)
      }
   }
}
