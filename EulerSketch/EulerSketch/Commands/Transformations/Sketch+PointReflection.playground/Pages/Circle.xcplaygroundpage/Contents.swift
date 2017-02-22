import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (300, 450))

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// circle c
sketch.addCircle("c", withCenter: "A", throughPoint: "B")

// circle c1
sketch.addReflectionCircle("c1", fromCircle: "c", withCenter: "O")

// point B1
sketch.addReflectionPoint("B1", fromPoint: "B", withCenter: "O")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
