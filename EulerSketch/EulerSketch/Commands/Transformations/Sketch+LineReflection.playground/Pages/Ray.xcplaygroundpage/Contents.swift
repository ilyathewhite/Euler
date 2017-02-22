import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// line AB
sketch.addLine("AB")

// point C, draggable
sketch.addPoint("C", hint: (250, 500))

// point D, draggable
sketch.addPoint("D", hint: (350, 525))

// ray CD
sketch.addRay("CD")

// ray C1D1
sketch.addReflectionRay("C1D1", fromRay: "CD", withMirrorLine: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
