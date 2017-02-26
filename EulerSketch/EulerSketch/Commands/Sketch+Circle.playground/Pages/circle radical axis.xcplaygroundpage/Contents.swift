//: [Previous](@previous)

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point O1, draggable
sketch.addPoint("O1", hint: (300, 300))

// circle a, draggable
sketch.addCircle("a", withCenter: "O1", hintRadius: 75)

// point O2, draggable
sketch.addPoint("O2", hint: (400, 300))

// circle b, draggable
sketch.addCircle("b", withCenter: "O2", hintRadius: 50)

// point O3, draggable
sketch.addPoint("O3", hint: (370, 375))

// circle c, draggable
sketch.addCircle("c", withCenter: "O3", hintRadius: 60)

sketch.addRadicalAxis("c1", ofCircles: "a", "b")

sketch.addRadicalAxis("b1", ofCircles: "a", "c")

sketch.addRadicalAxis("a1", ofCircles: "b", "c")

// live view
PlaygroundPage.current.liveView = sketch.quickView()

//: [Next](@next)
