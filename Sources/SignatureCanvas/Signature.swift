import SwiftUI

public class Signature: ObservableObject
{
    enum Error:Swift.Error {
        case exportError
    }
    
    @Published var shapes: [Shape] = []
    @Published public var hasDrawing = false

    var size: CGSize = .zero
    var bounds: CGRect { CGRect(origin: .zero, size: size) }
    var shouldBeginNewShape = true
    let lineWidth:Double
    let lineColor:Color

    var min = CGPoint(x: 100_000, y: 100_000)
    var max = CGPoint.zero

    lazy var drawGesture = DragGesture(coordinateSpace: .local)
        .onChanged(onDragOccured)
        .onEnded(onDragEnded)
                
    public init(lineColor:Color = .black, lineWidth:Double = 2.0)
    {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
    public func clear()
    {
        self.shapes.removeAll()
        self.hasDrawing = false
        self.min = CGPoint(x: 100_000, y: 100_000)
        self.max = CGPoint.zero
    }

    func onDragOccured(_ value: DragGesture.Value)
    {
        let point = value.location
        
        guard bounds.contains(point) else {
            shouldBeginNewShape = true
            return
        }
        
        var shape = shouldBeginNewShape ? Shape() : shapes.removeLast()
        shape.drawTo(point)
        shapes.append(shape)
        
        if point.x < min.x {
            min.x = point.x
        }

        if point.y < min.y {
            min.y = point.y
        }

        if point.x > max.x {
            max.x = point.x
        }

        if point.y > max.y {
            max.y = point.y
        }

        hasDrawing = true
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
