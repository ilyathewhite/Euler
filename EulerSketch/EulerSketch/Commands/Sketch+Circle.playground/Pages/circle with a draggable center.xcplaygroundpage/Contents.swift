//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// circle, draggable
sketch.addCircle("a", withCenter: "O", hintRadius: 100)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
