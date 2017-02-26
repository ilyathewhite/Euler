//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// circle a, draggable
sketch.addCircle("a", withCenter: (300, 300), hintRadius: 100)

// point A, on a circle, draggable
sketch.addPoint("A", onCircle: "a", hint: (400, 400))

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
