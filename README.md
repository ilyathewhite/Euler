# Euler

Euler is a framework for researchers and teachers of classical geometry. Users can quickly describe a geometric sketch in a Swift based micro DSL that resembles how a geometer would describe it. The user can drag any free element of the sketch and see how the sketch would change. The user can also add assertions as part of the sketch, and the assertions get reevaluated whenever the sketch changes, which is very useful for research. Euler created PDFs are ideal for publication. Euler is optimized for Xcode playgrounds.

Here is an example of a script describing Simson's line:

```swift
import Cocoa

import PlaygroundSupport
import EulerSketchOSX

let sketch = Sketch()

sketch.addPoint("A", hint: (145, 230))
sketch.addPoint("B", hint: (445, 230))
sketch.addPoint("C", hint: (393, 454))

sketch.addTriangle("ABC")
sketch.addCircumcircle("o", ofTriangle: "ABC")

sketch.addPoint("P", onCircle: "o", hint: (340, 150))
sketch.addPerpendicular("PA1", toSegment: "BC")
sketch.addPerpendicular("PB1", toSegment: "AC")
sketch.addPerpendicular("PC1", toSegment: "AB")
sketch.addSegment("C1A1", style: .emphasized)
sketch.addSegment("C1B1", style: .emphasized)

// result

sketch.assert("A1, B1, C1 are collinear") { [unowned sketch] in
   let p1 = try sketch.getPoint("A1")
   let p2 = try sketch.getPoint("B1")
   let p3 = try sketch.getPoint("C1")
   return collinear(points: [p1, p2, p3])
}

sketch.eval()

// sketch adjustments

sketch.point("A", setNameLocation: .bottomLeft)
sketch.point("B", setNameLocation: .bottomRight)
sketch.point("B1", setNameLocation: .topLeft)
sketch.point("A1", setNameLocation: .bottomRight)

// live view
PlaygroundPage.current.liveView = sketch.quickView()

```

After this script executes in a playground, you can drag points A, B, C, P, and confirm that points A1, B1, C1 are collinear both visually and computationally (the assertion is reevaluated on any change in the sketch).

The project contains many simple playgrounds that describe the framework building blocks. It also contains a playground that provides a few examples of real geometric sketches (two of these sketches are for results that were discovered with this tool and submitted for publication).
