import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 400))

// point A1
sketch.addTranslationPoint("A1", fromPoint: "A", byVector: (dx: 100.0, dy: 50.0))

// point A2
sketch.addTranslationPoint("A2", fromPoint: "A1", byVector: "AB")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
