//
//  PointFigure.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// The location of the point label. Useful for positioning point labels so that
/// they don't obscure parts of the sketch.
public enum PointLabelLocation: String {
   case topRight, topLeft, bottomRight, bottomLeft, none = "None"
   static var defaultLocation: PointLabelLocation = .topRight
}

/// A specific point figure. Overrides the generic `draw` method and provides convenience constructors.
class PointFigure: Figure<HSPoint>, Point {
   // Point protocol
   
   var x: Double { return value.x }
   var y: Double { return value.y }
   var kind: PointKind {
      if let kindOverride = kindOverride {
         return kindOverride
      }
      else {
         return value.kind
      }
   }
   
   fileprivate var kindOverride: PointKind?
   
   func updateKind(_ val: PointKind) {
      kindOverride = val
   }
   
   var labelLocation: PointLabelLocation = PointLabelLocation.defaultLocation
   
   struct AngleMark {
      let ray1: RayFigure
      let ray2: RayFigure
      let markCount: Int

      let distanceToFirstMark = 12.0
      let distanceBetweenMarks = 3.0
      
      func draw(renderer: Renderer) {
         for idx in 0..<markCount {
            let angle = ray2.angle > ray1.angle ? ray2.angle - ray1.angle : M_PI * 2 - (ray1.angle - ray2.angle)
            renderer.drawArc(
               center: ray1.value.vertex,
               startPoint: ray1.pointAtDistance(distanceToFirstMark + distanceBetweenMarks * Double(idx)),
               angle: angle
            )
         }
      }
   }
   
   private var angleMarks = [AngleMark]()
   
   func addAngleMark(ray1: RayFigure, ray2: RayFigure, count: Int) {
      angleMarks.append(AngleMark(ray1: ray1, ray2: ray2, markCount: count))
   }
   
   fileprivate let perpendicularMarkLength = 8.0
   fileprivate let nameOffsetX = 4.0
   fileprivate let nameOffsetY = 0.0
   
   func update(x: Double, y: Double) {
      guard draggable else { return }
      value.update(x: x, y: y)
      notifyFigureDidChange()
   }
   
   // draw
   
   var shouldDrawName: Bool {
      let prefixes: [FigureNamePrefix] = [.Handle, .Part]
      return prefixes.index { name.hasPrefix($0.rawValue) } == nil
   }
   
   override func draw(_ renderer: Renderer) {
      guard let style = drawingStyle else { return }

      angleMarks.forEach { $0.draw(renderer: renderer) }      
      
      if shouldDrawName {
         let str = NSMutableAttributedString(string: name)
         str.addAttribute(kCTFontAttributeName as String, value: style.font, range:NSRange(location: 0, length: name.characters.count))
         
         if name.characters.count > 1 {
            let subscriptRange = NSRange(location: 1, length: name.characters.count - 1)
            str.addAttribute(NSAttributedString.subscriptAttributeName, value: -2.0, range: subscriptRange)
            str.addAttribute(kCTFontAttributeName as String, value: style.subscriptFont, range: subscriptRange)
         }
         
         let strSize = (labelLocation == .topRight) ? CGSize() : str.size()
         let txtPoint: Point?
         switch labelLocation {
         case .topRight:
            txtPoint = self.translate(by: (dx: nameOffsetX, dy: nameOffsetY))
         case .topLeft:
            txtPoint = self.translate(by: (dx: -nameOffsetX - Double(strSize.width), dy: nameOffsetY))
         case .bottomRight:
            txtPoint = self.translate(by: (dx: nameOffsetX, dy: -nameOffsetY - Double(strSize.height)))
         case .bottomLeft:
            txtPoint = self.translate(by: (dx: -nameOffsetX - Double(strSize.width), dy: -nameOffsetY - Double(strSize.height)))
         case .none:
            txtPoint = nil
         }
         if let txtPoint = txtPoint {
            renderer.drawText(str, atPoint: txtPoint)
         }
      }
      
      func perpendicularMarkPoint1(_ point: Point, _ line: Line) -> HSPoint {
         let perpendicularLine = line.perpendicularLineFromPoint(point)
         let points = perpendicularLine.pointsAtDistance(perpendicularMarkLength, fromPoint: self)
         if let perpendicular = HSSegment(vertex1: self, vertex2: point) {
            for point in points {
               if perpendicular.ray.containsLinePoint(point) {
                  return point
               }
            }
         }
         
         return points[0]
      }
      
      func drawPependicularMark(markPoint1 p1: Point, markPoint2 p2: Point) {
         let p3 = p1.translate(by: vector(self, p2))
         renderer.setStyle(.regular)
         renderer.drawSegmentPath([p1, p3, p2], closed: false)
      }
      
      defer {
         if !kind.isHandle {
            renderer.setStyle(drawingStyle ?? style)
            renderer.drawPoint(value)
         }
      }
      
      switch kind {
      case let .perpendicularLineFoot(point, line):
         let p1 = perpendicularMarkPoint1(point, line)
         let markAngle = M_PI_2
         let p2 = p1.rotateAroundPoint(self, angle: markAngle)
         
         drawPependicularMark(markPoint1: p1, markPoint2: p2)
         
      case let .perpendicularSegmentFoot(point, segment):
         let p1 = perpendicularMarkPoint1(point, segment.line)
         let points = [ p1.rotateAroundPoint(self, angle: M_PI_2), p1.rotateAroundPoint(self, angle: -M_PI_2) ]
         
         if let seg = HSSegment(vertex1: self, vertex2: segment.vertex2) , seg.containsLinePoint(segment.vertex1) {
            renderer.setStyle(.extra)
            renderer.drawSegment(point1: self, point2: segment.vertex1)
            for p2 in points {
               if let seg2 = HSSegment(vertex1: p2, vertex2: segment.vertex1) , !seg2.containsLinePoint(self) {
                  drawPependicularMark(markPoint1: p1, markPoint2: p2)
                  return
               }
            }
         }
         else if let seg = HSSegment(vertex1: self, vertex2: segment.vertex1) , seg.containsLinePoint(segment.vertex2) {
            renderer.setStyle(.extra)
            renderer.drawSegment(point1: self, point2: segment.vertex2)
            for p2 in points {
               if let seg2 = HSSegment(vertex1: p2, vertex2: segment.vertex2) , !seg2.containsLinePoint(self) {
                  drawPependicularMark(markPoint1: p1, markPoint2: p2)
                  return
               }
            }
         }
         else {
            drawPependicularMark(markPoint1: p1, markPoint2: points[0])
         }
         
      default:
         return
      }
   }
   
   // init
   
   /// Creates an instance with a specific `name` and `value`.
   override init(name: String, value: HSPoint) {
      super.init(name: name, value: value)
      dragUpdateFunc = { [unowned self] (point, vector) in
         if let point = point {
            self.value = point.basicValue.translate(by: vector)
         }
         else {
            self.translateInPlace(by: vector)
         }
      }
      drawingStyle = .pointRegular
   }
   
   /// Creates a point with the default drawing style for points.
   override init(name: String, usedFigures: FigureSet, evalFunc: @escaping EvalFunc) throws {
      try super.init(name: name, usedFigures: usedFigures, evalFunc: evalFunc)
      drawingStyle = .pointRegular
   }
   
   /// Constructs the eval function from a specific point. For example, if the point is on a circle,
   /// a hint could be any point, and the eval function would be the intersection of the circle with
   // the ray from the center of the circle that contains the hint point.
   typealias HintToEvalFunc = (_ hint: Point) -> EvalFunc
   
   /// Creates an instance with a specific hint and a hint to eval function.
   convenience init(name: String, usedFigures: FigureSet, hint: Point, makeEvalFunc: @escaping HintToEvalFunc) throws {
      try self.init(name: name, usedFigures: usedFigures, evalFunc: makeEvalFunc(hint))
      
      dragUpdateFunc = { [unowned self] (point, vector) in
         let hint = (point ?? self.value).translate(by: vector)
         self.evalFunc = makeEvalFunc(hint)
      }
   }
   
   /// Creates a point on a circle.
   convenience init(name: String, circle: CircleFigure, hint: Point) throws {
      try self.init(name: name, usedFigures: FigureSet(circle), hint: hint) { hint in
         func fixHint(_ hint: Point) -> HSPoint {
            return circle.center != hint ? hint.basicValue : hint.translate(by: (dx: 0, dy: 1.0))
         }
         
         let hint = fixHint(hint)
         let angle = HSSegment(vertex1:circle.center, vertex2: hint)!.angleFromXAxis()
         return {
            let ray = HSRay(vertex: circle.center, angle: angle)
            let intersection = ray.intersect(circle)
            guard intersection.count > 0 else { return nil }
            let res = intersection[0]
            guard circle.containsPoint(res) else { return nil }
            return res
         }
      }
   }
   
   /// Creates a point on a line.
   convenience init(name: String, line: LineFigure, hint: Point) throws {
      try self.init(name: name, usedFigures: FigureSet(line), hint: hint) { hint in
         return {
            var res = line.footFromPoint(hint)
            guard line.containsPoint(res) else { return nil }
            res.kind = .regular
            return res
         }
      }
   }
   
   /// Creates a point on a ray.
   convenience init(name: String, ray: RayFigure, hint: Point) throws {
      try self.init(name: name, usedFigures: FigureSet(ray), hint: hint) { hint in
         let point = ray.line.footFromPoint(hint)
         guard ray.line.containsPoint(point) else { return { nil } }
         guard ray.containsLinePoint(point) else { return { nil } }
         let dist = ray.vertex.distanceToPoint(point)
         return { ray.pointAtDistance(dist) }
      }
   }

   /// Creates a point that is the translation of `point` by `vector`.
   convenience init(name: String, point: PointFigure, translatedBy vector: Vector) throws {
      try self.init(name: name, usedFigures: FigureSet(point), hint: point.translate(by: vector)) { hint in
         let dx = hint.x - point.x
         let dy = hint.y - point.y
         return { point.translate(by: (dx: dx, dy: dy)) }
      }
   }

   /// Creates a point that is the trasnlation of `point` by the vector defined by translating point `vectorP1` to point `vectorP2`.
   convenience init(name: String, point: PointFigure, vectorP1 A: PointFigure, vectorP2 B: PointFigure) throws {
      try self.init(name: name, usedFigures: FigureSet([point, A, B])) {
         return point.translate(by: vector(A, B))
      }
      
      dragUpdateFunc = nil
   }
}
