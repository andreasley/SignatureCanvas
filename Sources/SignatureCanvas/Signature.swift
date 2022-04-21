import SwiftUI

public class Signature: ObservableObject
{
    @Published var shapes: [Shape] = []
    
    var size: CGSize = .zero
    var shouldBeginNewShape = true

    lazy var drawGesture = DragGesture(coordinateSpace: .local)
        .onChanged(onDragOccured)
        .onEnded(onDragEnded)
                
    func onDragOccured(_ value: DragGesture.Value)
    {
        let point = value.location
        let bounds = CGRect(origin: .zero, size: size)
        
        guard bounds.contains(point) else {
            shouldBeginNewShape = true
            return
        }

        var shape = shouldBeginNewShape ? Shape() : shapes.removeLast()
        shape.drawTo(point)
        shapes.append(shape)
        
        shouldBeginNewShape = false
    }
    
    func onDragEnded(value: DragGesture.Value)
    {
        shouldBeginNewShape = true
    }

    struct Shape: SwiftUI.Shape
    {
        var points = [CGPoint]()
        
        func path(in rect: CGRect) -> Path
        {
            var path = Path()
            
            guard let firstPoint = points.first else {
                return path
            }

            path.move(to: firstPoint)
            
            for point in points {
                path.addLine(to: point)
            }
            
            return path
        }
        
        mutating func drawTo(_ point: CGPoint)
        {
            points.append(point)
        }
    }
}
