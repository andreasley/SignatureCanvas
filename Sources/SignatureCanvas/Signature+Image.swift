import SwiftUI

extension Signature
{
    public func getImage(scalingFactor:Double = 2) throws -> CGImage
    {
        let bounds = self.bounds
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let width = Int(size.width*scalingFactor)
        let height = Int(size.height*scalingFactor)
        let transparentBackgroundInfo = CGImageAlphaInfo.premultipliedFirst.rawValue

        guard
            let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: transparentBackgroundInfo),
            let lineColor = self.lineColor.cgColor
        else { throw Error.exportError }

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(lineColor)
        context.setLineWidth(self.lineWidth)
        context.scaleBy(x: scalingFactor, y: scalingFactor)

        for shape in shapes {
            context.addPath(shape.path(in: bounds).cgPath)
            context.strokePath()
        }
        
        guard let image = context.makeImage() else {
            throw Error.exportError
        }
        return image
    }
}
