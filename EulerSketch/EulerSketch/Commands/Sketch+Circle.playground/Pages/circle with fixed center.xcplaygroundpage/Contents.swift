//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// circle a with a fixed center, draggable
// (you can change the radius by dragging the circle)
sketch.addCircle("a", withCenter: (300, 300), hintRadius: 100)

// point A, draggable
sketch.addPoint("A", hint: (100, 500))

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
