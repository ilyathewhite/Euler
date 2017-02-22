import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 500))

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// line AB
sketch.addLine("AB")

// line A1B1
sketch.addReflectionLine("A1B1", fromLine: "AB", withCenter: "O")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
