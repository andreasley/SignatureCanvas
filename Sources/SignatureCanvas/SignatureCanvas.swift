import Foundation
import SwiftUI

public struct SignatureCanvas: View
{
    @ObservedObject var signature:Signature
    let lineWidth:Double
    let lineColor:Color
    
    public init(_ signature:Signature, lineColor:Color? = nil, lineWidth:Double? = nil) {
        self.signature = signature
        self.lineWidth = lineWidth ?? signature.lineWidth
        self.lineColor = lineColor ?? signature.lineColor
    }

    public var body: some View
    {
        Canvas { context, size in
            signature.size = size
            let strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0)
            for shape in signature.shapes {
                context.stroke(shape.path(in: .zero), with: .color(lineColor), style: strokeStyle)
            }
        }
        .gesture(signature.drawGesture)
    }
}

struct SignatureCanvas_Previews: PreviewProvider
{
    static var previews: some View {
        SignatureCanvas(Signature())
            .frame(width: 500, height: 200)
    }
}
