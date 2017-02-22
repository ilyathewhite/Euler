import PlaygroundSupport
import EulerSketchOSX

extension Sketch {
   func addNinePointCircle() {
      addPoint("A", hint: (100, 200))
      addPoint("B", hint: (500, 200))
      addPoint("C", hint: (375, 450))
      
      addTriangle("ABC", style: .emphasized)
      
      addMedian("AAm", ofTriangle: "ABC", style: .extra)
      addMedian("BBm", ofTriangle: "ABC", style: .extra)
      addMedian("CCm", ofTriangle: "ABC", style: .extra)
      
      addAltitude("AAh", ofTriangle: "ABC", style: .extra)
      addAltitude("BBh", ofTriangle: "ABC", style: .extra)
      addAltitude("CCh", ofTriangle: "ABC", style: .extra)
      
      addCentroid("M", ofTriangle: "ABC")
      addOrthocenter("H", ofTriangle: "ABC")
      
      addSegment("AH", style: .extra)
      addSegment("BH", style: .extra)
      addSegment("CH", style: .extra)
      
      addMidPoint("A1", ofSegment: "AH")
      addMidPoint("B1", ofSegment: "BH")
      addMidPoint("C1", ofSegment: "CH")
      
      addCircle("ABC9", throughPoints: "Am", "Bm", "Cm", style: .emphasized)
      
      point("A", setNameLocation: .bottomLeft)
      point("B", setNameLocation: .bottomRight)
      point("M", setNameLocation: .bottomRight)
      point("Cm", setNameLocation: .bottomLeft)
      point("Ch", setNameLocation: .bottomRight)
      point("A1", setNameLocation: .topLeft)
      point("Bh", setNameLocation: .topLeft)
      point("Bm", setNameLocation: .topLeft)
   }
}

let sketch = Sketch()
sketch.addNinePointCircle()

PlaygroundPage.current.liveView = sketch.quickView()
