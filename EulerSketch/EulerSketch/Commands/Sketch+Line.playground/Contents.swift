import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 300))

// point B, draggable
sketch.addPoint("B", hint: (400, 300))

// line AB, draggable through A and B
sketch.addLine("AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
