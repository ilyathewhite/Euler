//
//  RayFigure.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// A specific ray figure. Overrides the generic `draw` method, adds a dragging handle, and provides convenience constructors.
class RayFigure: Figure<HSRay>, Ray {
   // The vertex
   var vertexFigure: PointFigure!
   
   // The point used for dragging.
   var handle: PointFigure!
   
   // The default distance from the vertex to handle.
   static let defaultHandleDistance = 50.0
   
   override var dragEndMessage: String  {
      return "finished dragging \(fullName), angle from X axis = \(toDegrees(angle))"
   }
   
   // Ray protocol
   
   var vertex: Point { return value.vertex }
   var angle: Double { return value.angle }
   
   // draw
   
   override func draw(_ renderer: Renderer) {
      super.draw(renderer)
      renderer.drawSegment(point1: vertex, point2: handle)
   }
   
   func update(_ vertex: Point, angle: Double) {
      value.update(vertex, angle: angle)
      notifyFigureDidChange()
   }   
   
   // init
   
   override weak var sketch: Sketch? {
      didSet {
         guard let sketch = sketch else { return }
         try! sketch.addExtraFigure(handle, style: nil)
      }
   }
   
   /// Returns the eval function that ensures that the ray goes through `vertex` and has a given angle
   /// from the `X` axis.
   static func makeAngleEvalFunc(vertex: PointFigure, angle: Double) -> EvalFunc {
      return { HSRay(vertex: vertex, angle: angle) }
   }

   /// The drag update function. Changes the angle of the ray to match the dragged point.
   func angleUpdateFunc(_ point: Point?, vector: Vector) {
      let point = (point ?? handle).translate(by: vector)
      if let segment = HSSegment(vertex1:vertex, vertex2: point.translate(by: vector)) {
         evalFunc = RayFigure.makeAngleEvalFunc(vertex: self.vertex as! PointFigure, angle: segment.angleFromXAxis())
      }
   }
   
   /// Creates the dragging handle.
   func makeHandle(point: Point, distance: Double) -> PointFigure {
      func makeHandleEvalFunc(_ distance: Double) -> () -> HSPoint? {
         return { [unowned self] in self.pointAtDistance(self.vertex.distanceToPoint(point) + distance) }
      }
      
      let handleName = "\(FigureNamePrefix.Handle.rawValue)for_\(fullName)"
      let handle = try! PointFigure(name: handleName, usedFigures: FigureSet(self), evalFunc: makeHandleEvalFunc(distance))
      handle.updateKind(.handle)
      handle.dragUpdateFunc = { [unowned self, unowned handle] (dragPoint, vector) in
         let pnt = (dragPoint ?? handle).translate(by: vector)
         let foot = self.line.footFromPoint(pnt)
         guard self.containsLinePoint(foot) else { return }
         let dist = self.vertex.distanceToPoint(foot)
         guard dist > self.vertex.distanceToPoint(point) + RayFigure.defaultHandleDistance else { return }
         handle.evalFunc = makeHandleEvalFunc(dist - self.vertex.distanceToPoint(point))
      }
      
      return handle
   }
   
   override init(name: String, usedFigures: FigureSet, evalFunc: @escaping EvalFunc) throws {
      try super.init(name: name, usedFigures: usedFigures, evalFunc: evalFunc)
      handle = makeHandle(point:vertex, distance: RayFigure.defaultHandleDistance)
   }

   /// Creates a ray with a given vertex and angle.
   init(name: String, vertex: PointFigure, hintAngle angle: Double) throws {
      vertexFigure = vertex
      try super.init(name: name, usedFigures: FigureSet(vertex), evalFunc: RayFigure.makeAngleEvalFunc(vertex: vertex, angle: angle))
      dragUpdateFunc = angleUpdateFunc
      handle = makeHandle(point:vertex, distance: RayFigure.defaultHandleDistance)
   }

   /// Creates a ray with a given vertex that goes through a given point.
   init(name: String, vertex: PointFigure, point: PointFigure) throws {
      vertexFigure = vertex
      try super.init(name: name, usedFigures: FigureSet([vertex, point])) { HSSegment(vertex1: vertex, vertex2: point)?.ray }
      handle = makeHandle(point: point, distance: RayFigure.defaultHandleDistance)
   }
}
