//
//  Figure.swift
//  Euler
//
//  Created by Ilya Belenkiy on 7/1/15.
//  Copyright © 2015 Ilya Belenkiy. All rights reserved.
//

/// The top level scripting APIs refer to figures by name, using geometry naming conventions.
/// The figure name prefix ensures that these names are unique in the figure lookup dictionary.
public enum FigureNamePrefix: String {
   case point = "point_"
   case segment = "segment_"
   case line = "line_"
   case ray = "ray_"
   case angle = "angle_"
   case circle = "circle_"
   case triangle = "triangle_"
   
   /// the prefix for a point where the figure drawing stops even though the drawing could be extended.
   /// For example, a ray needs one handle to tell where the ray drawing should stop. Handles
   /// help create line and ray drawings of the right length.
   case Handle = "handle_"
   
   /// the prefix for a figure that is part of another figure. For example, there are 2 ray parts in an angle.
   case Part = "part_"
   
   case None = ""
   
   /// Returns the full name from the geometric name. For example, triangle_ABC.
   func fullName(_ name: String) -> String { return rawValue + name }
   
   /// Returns the kind of figure for the name prefix.
   var figureKind: FigureKind? {
      switch self {
      case .point: return .point
      case .segment: return .segment
      case .line: return .line
      case .ray: return .ray
      case .angle: return .angle
      case .circle: return .circle
      case .triangle: return .triangle
      default: return nil
      }
   }
   
   /// The separator between the name prefix and the rest of the name. The separator is part of the prefix.
   static let lastChar: Character = "_"
   
   var nameWithoutLastChar: String {
      let str = rawValue
      let lastIdx = str.characters.index(str.endIndex, offsetBy: -1)
      return str.substring(to: lastIdx)
   }
}

// The types of figures supported by Euler.
public enum FigureKind: String {
   case point
   case segment
   case line
   case ray
   case angle
   case circle
   case triangle
   case vector
   
   /// Returns the name prefix for the kind of figure.
   var figureNamePrefix: FigureNamePrefix {
      switch self {
      case .point: return .point
      case .segment: return .segment
      case .line: return .line
      case .ray: return .ray
      case .angle: return .angle
      case .circle: return .circle
      case .triangle: return .triangle
      default: return .None
      }
   }

   /// Returns the full name from the given short name.
   func fullName(_ name: String) -> String {
      return figureNamePrefix.fullName(name)
   }
}

/// The type of function that updates a figure while dragging from `point` by `vector`.
/// The point can be `nil` when the drag propagates to another figure due to dependencies.
typealias DragUpdateFunc = (_ from: Point?, _ by: Vector) -> ()

/// The protocol that describes how to draw a figure.
protocol Drawable: class {
   /// Whether the figure is hidden.
   var hidden: Bool { get set }
   
   /// The drawing style (for example, this may affect line thickness or color).
   var drawingStyle: DrawingStyle? { get set }
   
   /// Draws the figure via `renderer` by decomposing the drawing into primitives
   /// that `renderer` can draw directly.
   func draw(_ renderer: Renderer)
}

/// The protocol for dragging.
protocol Draggable: class {
   /// The drag update function. `nil` if the figure is not draggable
   var dragUpdateFunc: DragUpdateFunc? { get set }
   
   /// Applies the drag update function. The implementation may need to do more than
   /// simply calling `dragUpdateFunc`. It also has to ensure that the function is not called
   /// more than onace per update (this could happen if dragging means updating other figures
   /// as well.
   func applyUpdateFunc(from point: Point?, by: Vector)
}

extension Draggable {
   /// Whether the specific instance of `Draggable` can be dragged. For example, points are
   /// draggable, but if a point is an intersection of 2 figures, it may not be draggable.
   var draggable: Bool { return dragUpdateFunc != nil }
}

/// The protocol for evaluating figures. The protocol assumes that the evaluation is expensive and
/// allows to skip the computation if it's not neccesary. It also assumes that the evaluation may
/// fail and provides an API to roll back to an earlier good state.
protocol Evaluable: class {
   /// Whether the evaluation is necessary.
   var needsEval: Bool { get set }
   
   /// Evaluate the figure.
   func eval()
   
   /// Commit the result of evaluation.
   func commit()
   
   /// Rollback to the state before the last evaluation.
   func rollback()
}

/// The protocol that describes a figure. A figure must be a class because
/// figures form a dependency graph, and many figures may need to reference
/// the same figure and react to changes in that figure. 
protocol FigureType: class, Shape, Drawable, Draggable, Evaluable {
   /// The sketch that owns the figure.
   weak var sketch: Sketch? { get set }

   /// Adds `figure` as a dependent figure. This means that any changes in
   /// this figure trigger reevaluation of `figure`.
   func addDependentFigure(_ figure: FigureType)
   
   /// Removes `figure` as a dependent figure. This is necessary when deleting `figure`.
   func removeDependentFigure(_ figure: FigureType)

   /// The geometric name (for example `ABC` for a triangle).
   var name: String { get }
   
   // /The unique geometric name (for example, triangle_ABC).
   var fullNamePrefix: FigureNamePrefix { get }
}

extension FigureType {
   /// A name that uniquely identifies a figure. Used for figure lookup table.
   var fullName: String { return fullNamePrefix.fullName(name) }

   /// A short figure summary. Useful for playgrounds and quick look.
   var summaryName: String { return fullNamePrefix.nameWithoutLastChar + " \(name)" }
}

/// A box to work around a SWift compiler error. The compiler accepts an array of
/// different types of `FigureType` implementations as an array of `FigureType` objects,
/// but accessing the array creates a crash at runtime.
struct FigureSet {
   fileprivate var figures: [FigureType] = []
   
   /// Adds `figure` to the set.
   mutating func add(_ figure: FigureType) {
      figures.append(figure)
   }
   
   /// Removes `figure` from the set.
   mutating func remove(_ figure: FigureType) {
      guard let index = figures.index(where: { $0 === figure }) else { return }
      figures.remove(at: index)
   }

   /// Returns an array of all figures in the set.
   var all: [FigureType] { return figures }
   
   init() {}
   
   init(_ figure: FigureType) {
      self.figures = [figure]
   }
   
   init(_ figures: [FigureType]) {
      self.figures = figures
   }
   
   init<T: FigureType>(_ figures: [T]) {
      self.figures = figures.map { $0 as FigureType }
   }
}

/// Describes the possible update states to ensure that a figure is
/// updated exactly once.
private enum FigureUpdateState {
   case ready, started, done
}

// The generic implementation of `FigureType` based on its shape.
class Figure<F: Shape>: FigureType {
   weak var sketch: Sketch?
   
   var name: String
   var fullNamePrefix: FigureNamePrefix { return F.namePrefix() }
   
   // dependent figures
   
   fileprivate var dependentFigures = FigureSet()
   
   func addDependentFigure(_ figure: FigureType) {
      dependentFigures.add(figure)
   }
   
   func removeDependentFigure(_ figure: FigureType) {
      dependentFigures.remove(figure)
   }
   
   func notifyFigureDidChange() {
      for figure in dependentFigures.all {
         figure.needsEval = true
      }
   }
   
   // drag
   
   var dragUpdateFunc: DragUpdateFunc?
   fileprivate var updateState: FigureUpdateState = .ready
   
   func applyUpdateFunc(from point: Point?, by vector: Vector) {
      guard let dragUpdateFunc = dragUpdateFunc , (updateState  == .ready) else { return }
      
      updateState  = .started
      dragUpdateFunc(point, vector)
      updateState = .done
   }
   
   fileprivate static func defaultUpdateFunc(_ usedFigures: [FigureType]) -> DragUpdateFunc? {
      guard usedFigures.count == 1 else { return nil }
      let usedFigure = usedFigures.first!
      return { (point, vector) in
         usedFigure.applyUpdateFunc(from: point, by: vector)
      }
   }
   
   // shape
   
   func distanceFromPoint(_ point: Point) -> (Double, Point) {
      return value.distanceFromPoint(point)
   }
   
   func translateInPlace(by vector: Vector) {
      value.translateInPlace(by: vector)
   }
   
   func translateToPoint(_ point: Point) {
      let (_, closestPoint) = distanceFromPoint(point)
      translateInPlace(by: vector(closestPoint, point))
   }
   
   // eval
   
   var needsEval = true
   fileprivate var freeVal = true
   
   var value: F! {
      didSet {
         self.notifyFigureDidChange()
      }
   }
   
   fileprivate var savedValue: F!
   
   class func namePrefix() -> FigureNamePrefix {
      return F.namePrefix()
   }
   
   typealias EvalFunc = () -> F?
   var evalFunc: EvalFunc? {
      didSet {
         needsEval = true
      }
   }
   
   var free: Bool { return freeVal && (evalFunc == nil) }
   
   func eval() {
      updateState = .ready
      
      if (!needsEval) {
         return
      }
      
      needsEval = false
      if let f = evalFunc {
         if let newValue = f() {
            value = newValue
         }
         else {
            sketch?.setNeedsRollback()
         }
      }
   }
   
   func commit() {
      savedValue = value
   }
   
   func rollback() {
      value = savedValue
   }
   
   // draw
   
   var hidden = false
   var drawingStyle: DrawingStyle?
   func draw(_ renderer: Renderer) {
      guard !hidden else { return }
      renderer.setStyle(drawingStyle)
   }
   
   // init
   
   /// Whether the figure is draggable.
   var draggable: Bool {
      return free || (dragUpdateFunc != nil)
   }
   
   /// Constructs a figure with a given name and value.
   init(name: String, value: F) {
      self.name = name
      self.value = value
      dragUpdateFunc = { [unowned self] (point, vector) in self.translateInPlace(by: vector) }
   }
   
   /// Constructs a figure with a given name from `evalFunc`, and for each figure in `usedFigures`,
   // adds the new figure as a dependent figure.
   init(name: String, usedFigures: FigureSet, evalFunc: @escaping EvalFunc) throws {
      self.name = name
      freeVal = (usedFigures.all.count == 0)
      
      for figure in usedFigures.all {
         figure.addDependentFigure(self)
      }
      
      let translateFunc: DragUpdateFunc = { [unowned self] (point, vector) in self.translateInPlace(by: vector) }
      
      dragUpdateFunc = usedFigures.all.count > 0 ?  Figure.defaultUpdateFunc(usedFigures.all) : translateFunc
      
      guard let value = evalFunc() else {
         throw SketchError.figureNotCreated(name:  name, kind: F.namePrefix().figureKind!)
      }
      self.value = value
      self.evalFunc = evalFunc
   }
}
