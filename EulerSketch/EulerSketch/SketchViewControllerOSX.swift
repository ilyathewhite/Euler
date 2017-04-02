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
   open class SketchViewController: NSViewController {
      open let sketch = Sketch()
      
      override open func viewDidLoad() {
         super.viewDidLoad()
         sketchView.sketch = sketch
      }
      
      open var sketchView: SketchView { return view as! SketchView }
      
      // MARK:- Animation
      
      // the current view animation
      private var animation: ParametricCurveAnimation?
      
      /// Starts the view animation.
      @IBAction open func startAnimation(_ sender: Any) {
         animation?.start()
      }
      
      /// Animates how a free sketch point moves along the input parametric curve.
      open func dragPoint(_ pointName: String, along curve: @escaping Sketch.ParametricCurve, duration: TimeInterval) {
         setAnimation(point: pointName, along: curve, duration: duration)
         startAnimation(self)
      }
      
      /// Sets the view animation to how a free sketch point moves along the input parametric curve.
      open func setAnimation(point pointName: String, along curve: @escaping Sketch.ParametricCurve, duration: TimeInterval) {
         let animation = ParametricCurveAnimation(
            curve: curve,
            progressAction: { [unowned self] (point) in
               self.sketch.dragPoint(fullName: "point_\(pointName)", to: point.basicPoint)
               self.view.display()
            },
            duration: duration
         )
         self.animation = animation
         animation.animationBlockingMode = .nonblocking
      }
      
      // MARK: - Action validation
      
      override open func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
         guard menuItem.action == #selector(SketchViewController.startAnimation(_:)) else {
            return super.validateMenuItem(menuItem)
         }
         return animation != nil
      }
   }
   
   // MARK:-
   
   /// Animation for parametric curve.
   private class ParametricCurveAnimation: NSAnimation {
      typealias Curve = Sketch.ParametricCurve
      
      /// the curve
      private let curve: (Double) -> HSPoint
      
      /// The callback for the location of the animated point
      private let progressAction: (HSPoint) -> ()
      
      /// Constructs the animation with a specific curve, animated point location callback, and duration.
      init(curve: @escaping Curve, progressAction: @escaping (HSPoint) -> (), duration: TimeInterval) {
         self.curve = curve
         self.progressAction = progressAction
         super.init(duration: duration, animationCurve: .linear)
      }
      
      override var currentProgress: NSAnimationProgress {
         didSet {
            progressAction(curve(Double(currentProgress)))
         }
      }
      
      required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }
   }
   
#endif
