import AppKit
import XCPlayground
import EulerSketchOSX

let sketch = Sketch()
sketch.add(point: "A", hint: (300, 300))

XCPlaygroundPage.currentPage.liveView = sketch.quickView()
