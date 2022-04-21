import Foundation
import SwiftUI

public struct SignatureCanvas: View
{
    @ObservedObject public var signature = Signature()
    
    public init() {}
    
    public var body: some View
    {
        Canvas { context, size in
            signature.size = size
            for shape in signature.shapes {
                context.stroke(shape.path(in: .zero), with: .color(.primary), lineWidth: 5.0)
            }
        }
        .gesture(signature.drawGesture)
    }
}

struct SignatureCanvas_Previews: PreviewProvider
{
    static var previews: some View {
        SignatureCanvas()
            .frame(width: 500, height: 200)
    }
}
