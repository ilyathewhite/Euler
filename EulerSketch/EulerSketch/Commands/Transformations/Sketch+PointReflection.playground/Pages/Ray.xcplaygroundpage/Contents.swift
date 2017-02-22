import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

// point A, draggable
sketch.addPoint("A", hint: (200, 400))

// point B, draggable
sketch.addPoint("B", hint: (400, 500))

// point O, draggable
sketch.addPoint("O", hint: (300, 300))

// ray AB
sketch.addRay("AB")

// ray A1B1
sketch.addReflectionRay("A1B1", fromRay: "AB", withCenter: "O")

// live view
PlaygroundPage.current.liveView = sketch.quickView()
