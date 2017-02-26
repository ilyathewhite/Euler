//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// point A, draggable
sketch.addPoint("A", hint: (100, 500))

// circle, draggable
sketch.addCircle("a", withCenter: "O", hintRadius: 100)

sketch.addTangent("AT1", toCircle: "a", selector: leftPoint)

sketch.addTangent("AT2", toCircle: "a", selector: rightPoint)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
