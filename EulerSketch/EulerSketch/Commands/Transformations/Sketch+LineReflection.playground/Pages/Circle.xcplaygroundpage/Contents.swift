import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 300))

// point B, draggable
sketch.addPoint("B", hint: (400, 300))

// line AB
sketch.addLine("AB")

// point C, draggable
sketch.addPoint("C", hint: (275, 400))

// point D, draggable
sketch.addPoint("D", hint: (325, 450))

// circle c
sketch.addCircle("c", withCenter: "C", throughPoint: "D")

// circle c1
sketch.addReflectionCircle("c1", fromCircle: "c", withMirrorLine: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
