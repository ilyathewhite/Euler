//
//  SketchView.swift
//  EulerOSX
//
//  Created by Ilya Belenkiy on 7/24/15.
//  Copyright © 2015 Ilya Belenkiy. All rights reserved.
//

#if os(OSX)
   import AppKit
   
   protocol SketchViewDelegate: class {
      func didDrag(_ figureName: String?, fromPoint: ViewPoint, toPoint: ViewPoint)
   }
   
   /// The sketch canvas using `NSView`.
   open class SketchView: NSView {
      open weak var sketch: Sketch?
      weak var delegate: SketchViewDelegate?
      
      /// The name of the figure being dragged.
      fileprivate var dragFigureName: String?
      
      /// The previous drag location
      fileprivate var prevDragLocation: ViewPoint?
      
      /// The location where the drag started.
      fileprivate var dragStartLocation: ViewPoint!
      
      /// The sketch origin in the view coordinates.
      var origin: ViewPoint {
         guard let sketch = sketch else { return .zero }
         let origin = sketch.origin
         return ViewPoint(x: origin.x, y: origin.y)
      }
      
      override open func draw(_ dirtyRect: NSRect) {
         guard let sketch = sketch else { return }
         
         let context = NSGraphicsContext.current()!.cgContext
         
         NSColor.white.setFill()
         context.fill(bounds)
         
         context.translateBy(x: origin.x, y: origin.y)
         
         sketch.draw(context)
      }
      
      /// Returns the event point in the view coordinates.
      func viewPointFromEvent(_ theEvent: NSEvent) -> ViewPoint {
         var res = convert(theEvent.locationInWindow, from: nil)
         res.x = round(res.x)
         res.y = round(res.y)
         return res
      }
      
      /// Returns the event point in the sketch coordinates.
      func sketchPointFromEvent(_ theEvent: NSEvent) -> HSPoint {
         return sketchPointFromViewPoint(viewPointFromEvent(theEvent))
      }
      
      /// Converts a point from the view coordinates to sketch coordinates.
      func sketchPointFromViewPoint(_ viewPoint: ViewPoint) -> HSPoint {
         return HSPoint(Double(viewPoint.x - origin.x), Double(viewPoint.y - origin.y))
      }
      
      /// Converts a point from the sketch coordinates to view coordinates.
      func viewPointFromSketchPoint(_ sketchPoint: HSPoint) -> ViewPoint {
         return ViewPoint(x: CGFloat(sketchPoint.x) + origin.x, y: CGFloat(sketchPoint.y) + origin.y)
      }
      
      override open func mouseDown(with theEvent: NSEvent) {
         guard let sketch = sketch else { return }
         
         prevDragLocation = viewPointFromEvent(theEvent)
         dragStartLocation = prevDragLocation
         (dragFigureName, _) = sketch.closestDraggableFigureFromViewPoint(prevDragLocation!, minDistance: 10.0)
      }
      
      override open func mouseDragged(with theEvent: NSEvent) {
         guard let sketch = sketch else { return }

         let loc = viewPointFromEvent(theEvent)
         sketch.drag(dragFigureName, fromViewPoint: prevDragLocation!, toViewPoint: loc)
         needsDisplay = true
         prevDragLocation = loc
      }
      
      override open func mouseUp(with theEvent: NSEvent) {
         let dragEndLocation = viewPointFromEvent(theEvent)
         delegate?.didDrag(dragFigureName, fromPoint: dragStartLocation, toPoint: dragEndLocation)
         Swift.print(sketchPointFromViewPoint(dragEndLocation).description)
         if let figureName = dragFigureName, let message = sketch?.dragEndMessage(figureFullName: figureName) {
            Swift.print(message)
         }
         prevDragLocation = nil
         dragFigureName = nil
      }
   }
   
#endif
