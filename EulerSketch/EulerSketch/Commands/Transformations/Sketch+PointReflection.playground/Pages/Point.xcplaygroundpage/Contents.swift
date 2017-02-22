import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// point A1
sketch.addReflectionPoint("A1", fromPoint: "A", withCenter: "O")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
