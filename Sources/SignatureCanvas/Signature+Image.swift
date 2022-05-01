import SwiftUI

extension Signature
{
    public func getCgImage(scalingFactor:Double = 2) throws -> CGImage
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

        context.translateBy(x: 0, y: size.height*scalingFactor)
        context.scaleBy(x: scalingFactor, y: -scalingFactor)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(lineColor)
        context.setLineWidth(self.lineWidth)

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

extension Signature
{
    public func getImage(scalingFactor:Double = 2) throws -> Data?
    {
        let cgImage = try getCgImage(scalingFactor: scalingFactor)
        #if canImport(AppKit)
        let pngData = NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:])
        #elseif canImport(UIKit)
        let pngData = UIImage(cgImage: cgImage).pngData()
        #endif
        return pngData
    }
}
