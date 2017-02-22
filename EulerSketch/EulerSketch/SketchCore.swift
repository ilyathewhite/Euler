//
//  SketchCore.swift
//
//  Created by Ilya Belenkiy on 7/25/16.
//  Copyright © 2016 Ilya Belenkiy. All rights reserved.
//

#if os(iOS)
   import UIKit
#else
   import AppKit
#endif

public typealias ViewPoint = CGPoint

/// Possible errors when running sketch commands
public enum SketchError: Error, CustomStringConvertible {
   /// Couldn't find the style with a given name.
   case styleNotFound(name: String)
   
   /// Couldn't find a figure with a given name (for example, triangle ABC)
   case figureNotFound(name: String, kind: FigureKind)
   
   /// Tried to add the same figure twice.
   case figureAlreadyAdded(name: String, kind: FigureKind)
   
   /// Failed to create a figure. This can happen if the evaluation function
   /// fails to compute a value from other figures in the sketch. For example,
   /// if a figure is the intersection of 2 lines, and the 2 lines are parallel.
   case figureNotCreated(name: String, kind: FigureKind)
   
   /// The name fails to satisfy the common geometric conventions. For example,
   /// triangles are expected to be named by their 3 vertices.
   case invalidFigureName(name: String, kind: FigureKind)

   /// 2 rays that are expected to have the same vertex have different vertices.
   case invalidCommonVertex(ray1: String, ray2: String)
   
   /// Every kind of figure has its own prefix (for example, "line_"). The error
   /// means that the prefix couldn't be found.
   case invalidFigureNamePrefix(prefix: String)
   
   case invalidValue(argName: String)
   
   /// The context expected a different kind of figure. For example,
   /// if a command expected a triangle but got circle.
   case unexpectedFigureNamePrefix(prefix: String, expected: String)
   
   public var description: String {
      switch self {
      case let .styleNotFound(styleName):
         return "Style \(styleName) not found."
      case let .figureNotFound(name, kind):
         return "\(kind.rawValue) \(name) not found."
      case let .figureAlreadyAdded(name, kind):
         return "\(kind.rawValue) \(name) already added."
      case let .figureNotCreated(name, kind):
         return "\(kind.rawValue) \(name) not created."
      case let .invalidFigureName(name, kind):
         return "\(kind.rawValue) name \(name) is invalid."
      case let .invalidFigureNamePrefix(prefix):
         return "Figure name prefix \(prefix) is invalid."
      case let .invalidValue(argName):
         return "Invalid value for argument \(argName)"
      case let .unexpectedFigureNamePrefix(prefix, expected):
         return "Expected figure name prefix \(expected), got \(prefix)."
      case let .invalidCommonVertex(ray1, ray2):
         return "Expected rays \(ray1) and \(ray2) to have the same vertex."
      }
   }
}

/// The model of a complete geometric sketch.
open class Sketch {
   /// The origin of the model coordinate system in View coordinates.
   var origin: HSPoint = HSPoint(0, 0)
   
   /// All the figures in the sketch, in the order that they were added.
   fileprivate var figures: [FigureType] = []

   /// The figure lookup table. The key is the complete figure name,
   /// includig the figure prefix.
   fileprivate var figureDict = [String: FigureType]()
   
   /// The constructor that creates an empty sketch.
   public init() {}
   
   // MARK: Origin and Scale
   
   /// Converts point `viewPoint` from view to sketch coordinates.
   func sketchPointFromViewPoint(_ viewPoint: ViewPoint) -> HSPoint {
      return HSPoint(Double(viewPoint.x) - origin.x, Double(viewPoint.y) - origin.y)
   }
   
   /// Converts `point` from sketch to view coordinates.
   func viewPointFromSketchPoint(_ point: Point) -> (Double, Double) {
      return (origin.x + point.x, origin.y + point.y)
   }
   
   /// Drags figure named `figureName` from point `(fromX, fromY)` to point `(toX, toY)`.
   /// Both points are in the view coordinates.
   /// If `figureName` is nil, drags the sketch origin.
   ///
   /// This is an overload that translates view coordinates to sketch coordinates. See other
   /// functions for details.
   open func drag(_ figureName: String?, fromViewPoint fromPoint: ViewPoint, toViewPoint toPoint: ViewPoint) {
      let dx = Double(toPoint.x - fromPoint.x), dy = Double(toPoint.y - fromPoint.y)
      if let figureName = figureName {
         let fromSketchPoint = sketchPointFromViewPoint(fromPoint)
         drag(figureName, from: fromSketchPoint, by: (dx, dy))
         eval()
      }
      else {
         origin.x += dx
         origin.y += dy
      }
   }
   
   /// Scales all the free points in the sketch by `factor`.
   open func scale(_ factor: Double) {
      for figure in figures {
         if let point = figure as? PointFigure , point.free {
            var pnt = point.value
            pnt?.x *= factor
            pnt?.y *= factor
            point.value = pnt
         }
      }
      
      eval()
   }
   
   /// Translates all the free points in the sketch by `(dx, dy)`.
   open func translate(by vector: Vector) {
      for figure in figures {
         if let point = figure as? PointFigure , point.free {
            var pnt = point.value
            pnt?.x += vector.dx;
            pnt?.y += vector.dy;
            point.value = pnt
         }
      }
      
      eval()
   }
   
   // MARK: Find Figure
   
   /// Finds the figure with `name` by forming the full name with `prefix`.
   func findFigure(name: String, prefix: FigureNamePrefix) -> FigureType? {
      return figureDict[prefix.fullName(name)]
   }
   
   /// Finds the figure with a given full name.
   func findFigure(fullName name: String) -> FigureType? {
      return figureDict[name]
   }
   
   /// Returns the figure named `name` of a given type. The figure
   /// is expected to exist so the method throws an error if the figure is not found.
   ///
   /// The full name for the figure is formed from its name and type.
   func getFigure<T>(name: String) throws -> T where T: FigureType {
      if T.self == RayFigure.self {
         addRayIfNeeded(name)
      }
      else if T.self == LineFigure.self {
         addLineIfNeeded(name)
      }
      else if T.self == SegmentFigure.self {
         addSegmentIfNeeded(name)
      }
      
      let prefix = T.namePrefix()
      guard let res = findFigure(name: name, prefix: prefix) as? T else {
         throw SketchError.figureNotFound(name: name, kind: prefix.figureKind!)
      }
      
      return res
   }
   
   /// Adds `figure` to the lookup table.
   fileprivate func addToFigureDict(_ figure: FigureType) throws {
      guard figureDict[figure.fullName] == nil else {
         throw SketchError.figureAlreadyAdded(name: figure.fullName, kind: figure.fullNamePrefix.figureKind!)
      }
      
      figureDict[figure.fullName] = figure
   }
   
   /// Removes all figures starting from `index`. This method is useful when
   /// the user tries to add a complex figure that is constructed from smaller
   /// figures, and addition of the complex figure fails for some reason.
   /// In that case, this method can be used to rollback to a previous state.
   fileprivate func removeFigures(startIndex index: Int) {
      guard index < figures.count else { return }
      let range = index..<figures.count
      let removedFigures = figures[range]
      
      for figure in removedFigures {
         figureDict.removeValue(forKey: figure.fullName)
      }
      
      for figure in figures[0..<index] {
         removedFigures.forEach { figure.removeDependentFigure($0) }
      }
      
      figures.removeSubrange(range)
   }
   
   // MARK: Dragging
   
   /// Returns the closest draggable figure and its closest point from `point` at a distance no larger than `minDistance`.
   /// All points are in the sketch coordinates.
   func closestDraggableFigureFromPoint(_ point: Point, minDistance: Double) -> (FigureType?, Point?) {
      var candidates = Array(figureDict.values.filter { (figure: FigureType) in
         if !figure.draggable {
            return false
         }
         
         let (dist, _) = figure.distanceFromPoint(point)
         return dist < minDistance
         })
      
      if candidates.count == 0 {
         return (nil, nil)
      }
      else if candidates.count == 1 {
         let figure = candidates[0]
         let (_, closestPoint) = figure.distanceFromPoint(point)
         return (figure, closestPoint)
      }
      else {
         // closest point
         
         let pointFigures = candidates.filter { $0 is PointFigure }
         if pointFigures.count > 0 {
            typealias T = (pointFigure: PointFigure?, closestPoint: Point?, distance: Double)
            let initial: T = (nil, nil, 0)
            let res = pointFigures.reduce(initial, { (val: T, figure: FigureType) -> T in
               let pointFigure = figure as! PointFigure
               let (distance, closestPoint) = pointFigure.distanceFromPoint(point)
               return (val.pointFigure == nil) || (distance < val.distance) ? (pointFigure, closestPoint, distance) : val
            })
            
            return (res.pointFigure, res.closestPoint)
         }
         
         // closest figure
         
         typealias T = (figure: FigureType?, closestPoint: Point?, distance: Double)
         let initial: T = (nil, nil, 0)
         let res = candidates.reduce(initial, { (val: T, figure: FigureType) -> T in
            let (distance, closestPoint) = figure.distanceFromPoint(point)
            return (val.figure == nil) || (distance < val.distance) ? (figure, closestPoint, distance) : val
         })
         
         return (res.figure, res.closestPoint)
      }
   }
   
   /// Returns the closest draggable figure and its closest point from `point` at a distance no larger than `minDistance`.
   /// All points are in the view coordinates.
   open func closestDraggableFigureFromViewPoint(_ viewPoint: ViewPoint, minDistance: CGFloat) -> (String?, ViewPoint?) {
      let sketchPoint = sketchPointFromViewPoint(viewPoint)
      let (figure, closestSketchPoint) = closestDraggableFigureFromPoint(sketchPoint, minDistance: Double(minDistance))
      if let figure = figure, let closestSketchPoint = closestSketchPoint {
         let (x, y) = viewPointFromSketchPoint(closestSketchPoint)
         return (figure.fullName, ViewPoint(x: x, y: y))
      }
      else {
         return (nil, nil)
      }
   }
   
   /// Drags the figure with a given name from `point` moving some part of it
   /// (or by translating if it's free to move) by `vector`. Also updates
   /// all other figures already in the sketch as needed.
   func drag(_ name: String, from point: HSPoint, by vector: Vector) {
      guard let figure = findFigure(name: name, prefix: .None) else {
         assertionFailure("Figure \(name) not found.")
         return
      }
      
      figure.applyUpdateFunc(from: point, by: vector)
   }
   
   // MARK: Add Figure
   
   /// Adds `figure` with a given `style` for drawing.
   @discardableResult func addFigure(_ figure: FigureType, style: DrawingStyle?) throws -> FigureSummary {
      try addToFigureDict(figure)
      
      if !(figure is PointFigure) {
         figure.drawingStyle = style
      }
      
      figures.append(figure)
      
      // must be the last step to make sure that all dependencies are added last
      figure.sketch = self
      
      return figure.summary
   }

   /// Whether the sketch already contains a figure with the given name.
   func containsFigure(kind: FigureKind, name: String) -> Bool {
      return figureDict[kind.fullName(name)] != nil
   }
   
   /// Adds `figure` as an additional construction. Can be used directly or for implicitly created figures.
   @discardableResult func addExtraFigure(_ figure: FigureType, style: DrawingStyle? = .extra) throws -> FigureSummary {
      return try addFigure(figure, style: style)
   }
   
   // MARK: Eval
   
   /// Whether the sketch needs to go back to its previos state. This can happen if
   /// a figure cannot be constructed, for example, if there is a point specified as
   /// the intersection of 2 figures, and those 2 figures don't intersect.
   fileprivate var shouldRollback = false
   
   /// Sets the flag that the sketch needs to go back to its preious state.
   func setNeedsRollback() {
      shouldRollback = true
   }
   
   /// Evaluates all figures in the order that they were added and either changes
   /// all the figures to the new state or returns the sketch to its previous good state.
   open func eval() {
      // debugPrint("-------------------------")
      for figure in figures {
         // debugPrint(figure.fullName)
         figure.eval()
         if shouldRollback {
            break
         }
      }
      
      let finishEval: (_ figure: FigureType) -> () = shouldRollback ? { $0.rollback() } : { $0.commit() }
      for figure in figures {
         finishEval(figure)
      }
      shouldRollback = false
   }
   
   // draw
   
   /// Draws all figures via `renderer`.
   func draw(_ renderer: Renderer) {
      var points: [PointFigure] = []
      for figure in figures where !figure.hidden {
         if (figure is PointFigure) {
            points.append(figure as! PointFigure)
         }
         else {
            figure.draw(renderer)
         }
      }
      
      // points should be drawn last for style
      // draw regular points last to cover any extra drawing for special point types
      for point in points where !point.kind.isRegular {
         point.draw(renderer)
      }
      
      for point in points where point.kind.isRegular {
         point.draw(renderer)
      }
   }
   
   /// Draws all figures to a given graphics context.
   open func draw(_ context: CGContext) {
      let renderer = CGRenderer(context: context)
      draw(renderer)
   }
   
   // MARK: Top Level Helper Functions
   
   /// The content for `FigureResult`. Useful for displaying the result and quick look in playgrounds.
   public struct FigureSummary: CustomStringConvertible, CustomPlaygroundQuickLookable {
      /// The figure string summary.
      let string: String
      
      /// The sketch (useful for quick look).
      public let sketch: Sketch
      
      // CustomStringConvertible

      public var description: String {
         return string
      }
      
      // CustomPlaygroundQuickLookable
      
      public var customPlaygroundQuickLook: PlaygroundQuickLook {
         return sketch.customPlaygroundQuickLook
      }
   }
   
   /// The top level functions are really commands for adding figures. They are likely to be used
   /// in a playground while writing a script to create a sketch. In that context, using do / catch
   /// blocks and try statements is very verbouse. In playgrounds, `Result` shows errors on the side 
   /// without convoluting the script.
   public typealias FigureResult = Result<FigureSummary>
   
   /// Hides the figure named `fullName`.
   open func hide(figureNamed fullName: String) {
      guard let figure = findFigure(fullName: fullName) else { return }
      figure.hidden = true
   }   
   
   /// Returns the point names from `string`. `string` is expected to be a figure name that
   /// follows the universal geometric naming conventions (for example, triangle `ABC`).
   func scanPointNames(_ string: String, expected: FigureNamePrefix) throws -> [String] {
      func isUppercaseChar(_ idx: String.Index) -> Bool {
         return ("A"..."Z").contains(string[idx])
      }
      
      var idx = string.startIndex
      while (idx != string.endIndex) && (string[idx] != FigureNamePrefix.lastChar) {
         idx = string.index(after: idx)
      }
      
      if (idx != string.endIndex) {
         idx = string.index(after: idx)
      }
      
      let prefix = (idx == string.endIndex) ? "" : string.substring(to: idx)
      guard let prefixVal = FigureNamePrefix(rawValue: prefix) , (prefixVal == .None) || (prefixVal == expected) else {
         throw SketchError.invalidFigureNamePrefix(prefix: prefix)
      }
      
      if idx == string.endIndex {
         idx = string.startIndex
      }
      
      guard idx != string.endIndex else {
         return []
      }
      
      var names = [String]()
      var nameStartIdx = idx
      idx = string.index(after: nameStartIdx)
      while idx != string.endIndex {
         if isUppercaseChar(idx) {
            names.append(string.substring(with: nameStartIdx..<idx))
            nameStartIdx = idx
         }
         idx = string.index(after: idx)
      }
      if (nameStartIdx != string.endIndex) && isUppercaseChar(nameStartIdx) {
         names.append(string.substring(from: nameStartIdx))
      }
      
      return names
   }
   
   /// Returns the point figures used in `figureName`.
   func findVertices(_ figureName: String, expected: FigureNamePrefix) throws -> [PointFigure] {
      let vertexNames = try scanPointNames(figureName, expected: expected)
      
      var res = [PointFigure]()
      res.reserveCapacity(vertexNames.count)
      for vertexName in vertexNames {
         res.append(try self.getFigure(name: vertexName))
      }
      return res
   }
   
}

/// Extension for quick look in playgrounds.
extension Sketch: CustomPlaygroundQuickLookable {
   public func quickView() -> SketchView {
      let view = SketchView(frame: CGRect(origin: .zero, size: CGSize(width: 600, height: 600)))
      view.sketch = self
      return view
   }
   
   public var customPlaygroundQuickLook: PlaygroundQuickLook {
      return PlaygroundQuickLook(reflecting: quickView())
   }
}

/// Extension for dislpaying a figure short summary (useful in playgrounds and debugger).
extension FigureType {
   var summary: Sketch.FigureSummary {
      return Sketch.FigureSummary(string: summaryName, sketch: sketch!)
   }
}

/// Generic Result type
public enum Result<T>: CustomStringConvertible {
   case success(T)
   case failure(Error)
   
   public var description: String {
      switch self {
      case .success(let value):
         return "✓, \(value)"
         
      case .failure(let error):
         return "⨉, \(error)"
      }
   }
}