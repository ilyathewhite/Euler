//
//  SketchViewControllerOSX.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 4/1/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

#if os(OSX)   
   import AppKit
   
   // The basic sketch controller
   open class SketchViewController: NSViewController, NSMenuItemValidation {
      public let sketch = Sketch()
      
      override open func viewDidLoad() {
         super.viewDidLoad()
         sketchView.sketch = sketch
      }
      
      @IBOutlet public var sketchView: SketchView!
      public var sketchAnimator: SketchAnimator?
      
      /// Starts the view animation.
      @IBAction open func startAnimation(_ sender: Any) {
         sketchAnimator?.startAnimation()
      }
      
      // MARK: - Action validation
      
      public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
         guard menuItem.action == #selector(SketchViewController.startAnimation(_:)) else {
            return true
         }
         return sketchAnimator != nil
      }
   }

   // The sketch animator
   open class SketchAnimator: NSObject, NSAnimationDelegate {
      weak var view: NSView?
      weak var sketch: Sketch?

      // the current view animation
      private var animation: ParametricCurveAnimation!
      
      private static let animationFrameRate = 24.0
      private static let timePerAnimationFrame = 1.0 / animationFrameRate      
      
      // The path the animaged gif. If `nil`, the animation is not recorded.
      public var animatedGifFilePath: String? = nil
      
      private var frames: [NSImage]! = nil
      private var lastFrameTime = Date.distantPast

      /// Creates an animator that drags a given point along a given curve for a given time.
      public init(view: NSView, sketch: Sketch, point pointName: String, along curve: @escaping Sketch.ParametricCurve, duration: TimeInterval) {
         super.init()

         self.view = view
         self.sketch = sketch
         
         let animation = ParametricCurveAnimation(
            curve: curve,
            progressAction: { [unowned self] (point) in
               guard let sketch = self.sketch else { return }
               guard let sketchView = self.view else { return }
               sketch.dragPoint(fullName: "point_\(pointName)", to: point.basicPoint)
               sketchView.display()
               self.addAnimationFrameIfNeeded()
            },
            duration: duration
         )
         animation.delegate = self
         self.animation = animation
         animation.animationBlockingMode = .nonblocking
      }
      
      public convenience init(controller: SketchViewController, point pointName: String, along curve: @escaping Sketch.ParametricCurve, duration: TimeInterval) {
         self.init(view: controller.view, sketch: controller.sketch, point: pointName, along: curve, duration: duration)
      }
      
      private func addAnimationFrameIfNeeded() {
         guard animatedGifFilePath != nil else { return }
         guard let sketchView = view else { return }
         guard Date().timeIntervalSince(lastFrameTime) >= SketchAnimator.timePerAnimationFrame else { return }
         let rep = sketchView.bitmapImageRepForCachingDisplay(in: sketchView.bounds)!
         sketchView.cacheDisplay(in: sketchView.bounds, to: rep)
         let frame = NSImage(size: sketchView.bounds.size)
         frame.addRepresentation(rep)
         frames.append(frame)
         lastFrameTime = Date()
      }
      
      /// Starts the animation.
      public func startAnimation() {
         animation.start()
      }

      /// Clears the state for the animation before it starts. Not meant to be called directly. 
      /// It's public due to the `NSAnimationDelegate` protocol requirement.
      public func animationShouldStart(_ animation: NSAnimation) -> Bool {
         if animatedGifFilePath != nil {
            frames = []
            lastFrameTime = Date.distantPast
         }
         return true
      }
      
      /// Records the animation to an animated gif if needed. Not meant to be called directly.
      /// It's public due to the `NSAnimationDelegate` protocol requirement.
      public func animationDidEnd(_ animation: NSAnimation) {
         guard let filePath = animatedGifFilePath else { return }
         let fileURL = URL(fileURLWithPath: filePath)
         
         let fileProperties = [
            kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]
         ]
         let frameProperties = [
            kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: SketchAnimator.timePerAnimationFrame]
         ]
         
         guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypeGIF, frames.count, nil) else {
            print("failed to create an image for url \(fileURL)")
            return
         }
         CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
         
         for frame in frames {
            if let cgImage = frame.cgImage(forProposedRect: nil, context: nil, hints: nil) {
               CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary?)
            }
            else {
               print("failed to create a CGImage from an animated frame")
            }
         }
         CGImageDestinationFinalize(destination)
      }
   }
   
   /// Animation for parametric curve.
   private class ParametricCurveAnimation: NSAnimation {
      /// the curve
      private let curve: (Double) -> HSPoint
      
      /// The callback for the location of the animated point
      private let progressAction: (HSPoint) -> ()
      
      /// Constructs the animation with a specific curve, animated point location callback, and duration.
      init(curve: @escaping Sketch.ParametricCurve, progressAction: @escaping (HSPoint) -> (), duration: TimeInterval) {
         self.curve = curve
         self.progressAction = progressAction
         super.init(duration: duration, animationCurve: .linear)
      }
      
      override var currentProgress: NSAnimation.Progress {
         didSet {
            progressAction(curve(Double(currentProgress)))
         }
      }
      
      required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }
   }
   
#endif
