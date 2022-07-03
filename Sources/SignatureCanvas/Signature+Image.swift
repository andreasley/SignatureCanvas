import SwiftUI

extension Signature
{
    public enum Cropping {
        case view
        case drawing(padding:Double)
    }
    
    public func getCgImage(scalingFactor:Double = 2, cropTo cropping:Cropping = .view) throws -> CGImage
    {
        let width:Int
        let height:Int
        let bounds:CGRect
        let translateX:Double
        let translateY:Double

        switch cropping {
        case .view:
            width = Int(ceil(size.width * scalingFactor))
            height = Int(ceil(size.height * scalingFactor))
            bounds = self.bounds
            translateX = 0
            translateY = size.height * scalingFactor
        case .drawing(let padding):
            let drawingWidth = max.x - min.x
            let drawingHeight = max.y - min.y
            width = Int(ceil((drawingWidth + lineWidth + padding * 2) * scalingFactor))
            height = Int(ceil((drawingHeight + lineWidth + padding * 2) * scalingFactor))
            bounds = .init(x: min.x, y: min.y, width: drawingWidth, height: drawingHeight)
            translateX = (min.x - lineWidth/2 - padding) * -scalingFactor
            translateY = (drawingHeight + min.y + lineWidth/2 + padding) * scalingFactor
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let transparentBackgroundInfo = CGImageAlphaInfo.premultipliedFirst.rawValue

        guard
            let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: transparentBackgroundInfo),
            let lineColor = self.lineColor.cgColor
        else { throw Error.exportError }

        context.translateBy(x: translateX, y: translateY)
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
    public func getImage(scalingFactor:Double = 2, cropTo cropping:Cropping = .view) throws -> Data?
    {
        let cgImage = try getCgImage(scalingFactor: scalingFactor, cropTo:cropping)
        #if canImport(AppKit)
        let pngData = NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:])
        #elseif canImport(UIKit)
        let pngData = UIImage(cgImage: cgImage).pngData()
        #endif
        return pngData
    }
}
