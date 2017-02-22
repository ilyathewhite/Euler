//
//  Renderer.swift
//  Euler
//
//  Created by Ilya Belenkiy on 7/1/15.
//  Copyright © 2015 Ilya Belenkiy. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

extension NSAttributedString {
   // This excludes the dependency of Point name description from UIKit / AppKit.
   static var subscriptAttributeName: String { return NSBaselineOffsetAttributeName }
}

#if os(iOS)
extension CGColorRef {
   static func clearColor() -> CGColorRef { return UIColor.clearColor().CGColor }
   static func blackColor() -> CGColorRef { return UIColor.blackColor().CGColor }
   static func whiteColor() -> CGColorRef { return UIColor.whiteColor().CGColor }
}
#else
extension CGColor {
   static func clearColor() -> CGColor { return NSColor.clear.cgColor }
   static func blackColor() -> CGColor { return NSColor.black.cgColor }
   static func whiteColor() -> CGColor { return NSColor.white.cgColor }
}
#endif


#if os(iOS)
typealias Font = UIFont
extension Font {
   static func defaultFontOfSize(pointSize: Double) -> Font {
      return Font.systemFontOfSize(CGFloat(pointSize))
   }
}
#else
typealias Font = NSFont
extension Font {
   static func defaultFontOfSize(_ pointSize: Double) -> Font {
      return Font.systemFont(ofSize: CGFloat(pointSize))
   }
}
#endif

/// The drawing style for a given figure. It's a class because it is
/// indented to be shared across many figures. Changes in the style need to
/// be applied to all figures that use it.
open class DrawingStyle {
   /// The style name.
   var name: String!
   
   var fillColor = CGColor.clearColor()
   var strokeColor = CGColor.blackColor()
   var strokeWidth = 1.0
   var useDash = false
   var font = Font.defaultFontOfSize(14)
   var subscriptFont = Font.defaultFontOfSize(10)
   
   /// The default style for all figures.
   open static let regular = DrawingStyle()

   /// The default style for points. It's different from `defaultStyle` because
   /// otherwise points on figures would not be visible. A typical rendering of
   /// a geometric point is a tiny circle.
   open static let pointRegular = DrawingStyle.makePointStyle()
   
   /// The emphasized style. Used to draw attention to a partciular part of the sketch.
   /// The most common represention is thick black paths.
   open static let emphasized = DrawingStyle.makeEmphasizedStyle()
   
   /// The extra style. Used to show additional constructions that are necessary to
   /// prove or illustrate the main result. The parts of the sketch that use this style
   /// are typically not necessary to describe the problem being solved. The most common
   /// represention is dashed gray paths.
   open static let extra = DrawingStyle.makeExtraStyle()
   
   fileprivate static func makePointStyle() -> DrawingStyle  {
      let res = DrawingStyle()
      res.name = "PointStyle"
      res.fillColor = CGColor.whiteColor()
      return res
   }
   
   fileprivate static func makeEmphasizedStyle() -> DrawingStyle {
      let res = DrawingStyle()
      res.name = "Emphasized"
      res.strokeWidth *= 2.0
      return res
   }

   fileprivate static func makeExtraStyle() -> DrawingStyle {
      let res = DrawingStyle()
      res.name = "Extra"
      res.useDash = true
      return res
   }
}

// Convenience functions that connect `Point` to CoreGraphics.

extension Point {
   var x_CG: CGFloat { return CGFloat(x) }
   var y_CG: CGFloat { return CGFloat(y) }
}

public extension CGPoint {
   internal init(_ point: Point) {
      x = CGFloat(point.x)
      y = CGFloat(point.y)
   }
   
   var X: Double { return Double(x) }
   var Y: Double { return Double(y) }
}

extension HSPoint {
   init(_ point: CGPoint, kind: PointKind = .regular) {
      x = Double(point.x)
      y = Double(point.y)
      self.kind = kind
   }
}

/// The renderer protocol that abstracts how the sketch is actually drawn.
protocol Renderer {
   /// The pixel to point scale.
   var nativeScale: Double { get set }
   
   /// Sets the style for all subsecuent drawing calls until its changed to another style.
   func setStyle(_ style: DrawingStyle?)
   
   /// Draws `point` using the current style.
   func drawPoint(_ point: Point)
   
   /// Draws the segment paths specified by `points` using the current style.
   /// `closed` specifies whether the path is closed or open.
   func drawSegmentPath(_ points: [Point], closed: Bool)
   
   /// Draws the segment from `point1` to `point2` using the current style.
   func drawSegment(point1: Point, point2: Point)
   
   /// Draws text specified by `str` at a given pointa s origin using the current style.
   func drawText(_ str: NSAttributedString, atPoint pnt: Point)
   
   /// Draws an arc with a given center, start point, and a counter-clockwise angle 
   /// using the current style.
   func drawArc(center: Point, startPoint: Point, angle: Double)

   /// Draws a full circle with a given center and radius.
   func fillCircle(center: Point, radius: Double)
}

extension Renderer {
   /// Draws the circle using the arc API.
   func drawCircle(center: Point, radius: Double) {
      drawArc(center: center, startPoint: HSPoint(center.x + radius, center.y), angle: M_PI * 2)
   }

   /// Draws the segment using the segment path API.
   func drawSegment(point1: Point, point2: Point) {
      drawSegmentPath([point1, point2], closed: false)
   }
}

/// The renderer implementation using CoreGraphics.
struct CGRenderer: Renderer {
   var context: CGContext
   var nativeScale: Double = 1.0
   
   init(context: CGContext) {
      self.context = context
      #if os(iOS)
      nativeScale = Double(UIScreen.mainScreen().nativeScale)
      #else
      nativeScale = Double(NSScreen.main()!.backingScaleFactor)
      #endif
   }

   func drawPoint(_ point: Point) {
      let radius = 3.0
      fillCircle(center: point, radius: radius)
      drawCircle(center: point, radius: radius)
   }
   
   func setStyle(_ drawingStyle: DrawingStyle?) {
      let style = drawingStyle ?? .regular
      
      context.setFillColor(style.fillColor)
      context.setStrokeColor(style.strokeColor)
      context.setLineWidth(CGFloat(style.strokeWidth / nativeScale))
      if (style.useDash) {
         context.setLineDash(phase: 0, lengths: [6 / CGFloat(nativeScale), 2 / CGFloat(nativeScale)])
      }
      else {
         context.setLineDash(phase: 0, lengths: [])
      }
   }
   
   func drawSegmentPath(_ points: [Point], closed: Bool) {
      guard points.count > 0 else { return }
      context.move(to: CGPoint(x: points[0].x_CG, y: points[0].y_CG))
      for ii in 1..<points.count {
         context.addLine(to: CGPoint(x: points[ii].x_CG, y: points[ii].y_CG))
      }
      if (closed) {
         context.closePath()
      }
      context.strokePath()
   }
   
   func drawText(_ str: NSAttributedString, atPoint pnt: Point) {
      let font = str.attribute(kCTFontAttributeName as String, at: 0, effectiveRange: nil) as! Font
      context.saveGState()
#if os(iOS)
      CGContextTranslateCTM(context, pnt.x_CG, pnt.y_CG + font.lineHeight)
      CGContextScaleCTM(context, 1.0, -1.0)
#else
      let maxHeight = abs(2 * font.descender) + font.ascender + font.leading
      context.translateBy(x: pnt.x_CG, y: pnt.y_CG + maxHeight - str.size().height)
#endif
      str.draw(at: CGPoint(x: 0, y: 0))
      context.restoreGState()
   }
   
   func drawArc(center: Point, startPoint: Point, angle: Double) {
      context.move(to: CGPoint(x: startPoint.x_CG, y: startPoint.y_CG))
      let dx = startPoint.x - center.x
      let dy = startPoint.y - center.y
      let radius = sqrt(dx * dx + dy * dy)
      let startAngle = (dy >= 0.0) ? acos(dx / radius) : 2 * M_PI - acos(dx / radius)
      context.addArc(center: CGPoint(center), radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(startAngle + angle), clockwise: false)
      context.strokePath()
   }
   
   func fillCircle(center: Point, radius: Double) {
      context.move(to: CGPoint(x: CGFloat(center.x + radius), y: CGFloat(center.y)))
      context.addArc(center: CGPoint(center), radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
      context.fillPath()
   }
}
