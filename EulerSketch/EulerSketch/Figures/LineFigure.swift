//
//  LineFigure.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// A common superclass for any line fiture that implements the Line protocol
/// based on `Figure<HSLine>`.
class LineFigure: Figure<HSLine>, Line {
   static func line(A: Double, B: Double, C: Double) -> Line? { return nil }
   
   var A: Double { return value.A }
   var B: Double { return value.B }
   var C: Double { return value.C }
   
   func update(A: Double, B: Double, C: Double) -> Bool {
      guard value.update(A: A, B: B, C: C) else { return false }
      notifyFigureDidChange()
      return true
   }
   
   // the default distance from the point(s) used to construct the line to handles.
   static let defaultHandleDistance = 20.0
   
   // A workaround for the Swift compipler. This constructor should be automaticaly
   // available from LineFigure: Figure<HSLine>, but subclasses of LineFigure don't
   // get it if it's not explicitly defined here. Most likely it's a bug in generics.
   override init(name: String, usedFigures: FigureSet, evalFunc: @escaping EvalFunc) throws {
      try super.init(name: name, usedFigures: usedFigures, evalFunc: evalFunc)
   }
}

/// A line figure that is constructed from 2 point figures.
class SimpleLineFigure: LineFigure {
   /// The first handle
   var handle1: PointFigure!
   
   /// The second handle
   var handle2: PointFigure!
   
   // draw
   
   override func draw(_ renderer: Renderer) {
      super.draw(renderer)
      renderer.drawSegment(point1: handle1, point2: handle2)
   }
   
   // init

   /// Returns a function that constructs a handle at a given distance from `point2`
   /// (`point2` is between `point1` and the handle).
   func makeHandle(point1: PointFigure, point2: PointFigure) -> PointFigure {
      func makeHandleEvalFunc(_ distance: Double) -> () -> HSPoint? {
         return {
            let ray = HSSegment(vertex1: point1, vertex2: point2)!.ray
            return ray.pointAtDistance(point1.distanceToPoint(point2) + distance)
         }
      }
      
      let handleName = "\(FigureNamePrefix.Handle.rawValue)for_\(fullName)_at_\(point2.fullName)"
      let handle = try! PointFigure(name: handleName, usedFigures: FigureSet([point1, point2]), evalFunc: makeHandleEvalFunc(LineFigure.defaultHandleDistance))
      handle.updateKind(.handle)
      handle.dragUpdateFunc = { [unowned handle] (point, vector) in
         let ray = HSSegment(vertex1: point1, vertex2: point2)!.ray
         let foot = ray.line.footFromPoint((point ?? handle).translate(by: vector))
         guard ray.containsLinePoint(foot) else { return }
         let dist = point1.distanceToPoint(foot) - point1.distanceToPoint(point2)
         guard (dist > LineFigure.defaultHandleDistance) else { return }
         handle.evalFunc = makeHandleEvalFunc(dist)
      }
      
      return handle
   }

   /// When the line figure becomes part of a sketch, the line handles are added to the sketch as well.
   override weak var sketch: Sketch? {
      didSet {
         guard let sketch = sketch else { return }
         try! sketch.addExtraFigure(handle1, style: nil)
         try! sketch.addExtraFigure(handle2, style: nil)
      }
   }
   
   /// Creates a line from 2 points.
   convenience init(name: String, point1: PointFigure, point2: PointFigure) throws {
      try self.init(name: name, usedFigures: FigureSet([point1, point2])) { HSLine.line(point1: point1, point2: point2) }
      handle1 = makeHandle(point1: point1, point2: point2)
      handle2 = makeHandle(point1: point2, point2: point1)
   }
}

/// A line figure that is constructed from a point and the counterclockwise angle that the line forms with the `X` axis.
/// To ensure that the line can be dragged from either side of the point on the line, the implementation uses 2 rays that
/// form the line. Each ray has a dragging handle.
class CompoundLineFigure: LineFigure {
   // ray 1 from the construction point to handle 1
   var ray1: RayFigure!
   
   // ray 2 from the construction point to handle 2
   var ray2: RayFigure!

   /// When the line figure becomes part of a sketch, the rays are added to the sketch as well.
   override weak var sketch: Sketch? {
      didSet {
         guard let sketch = sketch else { return }
         try! sketch.addExtraFigure(ray1, style: drawingStyle)
         try! sketch.addExtraFigure(ray2, style: drawingStyle)
      }
   }
   
   override var dragEndMessage: String  {
      return "finished dragging \(fullName), angle from X axis = \(toDegrees(ray1.angle))"
   }
   
   // init
   
   /// The eval function for a specific vertex and angle.
   static func makeEvalFunc(vertex: PointFigure, angle: Double) -> EvalFunc {
      return { HSLine.line(point: vertex, angle: angle) }
   }

   /// The eval function for a specific vertex and a function that returns the angle.
   static func makeEvalFunc(vertex: PointFigure, angleFunc: @escaping () -> Double?) -> EvalFunc {
      return {
         guard let angle = angleFunc() else { return nil }
         return HSLine.line(point: vertex, angle: angle)
      }
   }

   // The prefix for the names of the rays that form the line.
   var rayNamePrefix: String { return FigureNamePrefix.Part.rawValue + fullName }
   
   /// Creates a line from a given point and the counterclockwise angle that the line forms from the `X` axis.
   init(name: String, vertex: PointFigure, hintAngle angle: Double) throws {
      try super.init(name: name, usedFigures: FigureSet(vertex), evalFunc: CompoundLineFigure.makeEvalFunc(vertex: vertex, angle: angle))
      
      ray1 = try! RayFigure(name: rayNamePrefix + "_1", vertex: vertex, hintAngle: angle)
      ray1.dragUpdateFunc = nil
      ray2 = try! RayFigure(name: rayNamePrefix + "_2", vertex: vertex, hintAngle: angle + M_PI)
      ray2.dragUpdateFunc = nil
   }
   
   /// Creates a line from a given point and the counterclockwise angle function that the line forms from the `X` axis.
   init(name: String, vertex: PointFigure, usedFigures: FigureSet, angleFunc: @escaping () -> Double?) throws {
      try super.init(
         name: name,
         usedFigures: FigureSet([vertex] + usedFigures.all),
         evalFunc: CompoundLineFigure.makeEvalFunc(vertex: vertex, angleFunc: angleFunc)
      )

      ray1 = try RayFigure(name: rayNamePrefix + "_1" , usedFigures: usedFigures) {
         guard let angle = angleFunc() else { return nil }
         return HSRay(vertex: vertex, angle: angle)
      }

      ray2 = try RayFigure(name: rayNamePrefix + "_2" , usedFigures: usedFigures) {
         guard let angle = angleFunc() else { return nil }
         return HSRay(vertex: vertex, angle: angle + M_PI)
      }
   }
   
   /// Updates the line with a given vertex and angle.
   func update(_ vertex: Point, angle: Double) {
      ray1.update(vertex, angle: angle)
      let angle2 = angle + M_PI
      ray2.update(vertex, angle: angle2 < 2 * M_PI ? angle2 : angle2 - 2 * M_PI)
      notifyFigureDidChange()
   }
}
