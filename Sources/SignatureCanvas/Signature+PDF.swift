import SwiftUI

extension Signature
{
    public func getPDF() throws -> Data
    {
        let data = NSMutableData()
        var mediaBox = self.bounds

        guard
            let consumer = CGDataConsumer(data: data),
            let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil),
            let lineColor = self.lineColor.cgColor
        else { throw Error.exportError }

        context.beginPDFPage(nil)
        context.translateBy(x: 0, y: mediaBox.height)
        context.scaleBy(x: 1, y: -1)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(lineColor)
        context.setLineWidth(self.lineWidth)

        for shape in shapes {
            context.addPath(shape.path(in: mediaBox).cgPath)
            context.strokePath()
        }
        
        context.endPDFPage()
        context.closePDF()
        
        return data as Data
    }
}
