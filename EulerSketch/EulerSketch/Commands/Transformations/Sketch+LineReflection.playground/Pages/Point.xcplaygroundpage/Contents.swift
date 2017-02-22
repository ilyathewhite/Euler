import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// line AB
sketch.addLine("AB")

// point C
sketch.addPoint("C", hint: (250, 500))

// point C1
sketch.addReflectionPoint("C1", fromPoint: "C", withMirrorLine: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
