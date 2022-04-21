import SwiftUI
import SignatureCanvas

@main
struct TestApp: App
{
    @State public var signature = Signature()

    var body: some Scene {
        WindowGroup {
            SignatureCanvas(signature)
                .frame(minWidth: 500, minHeight: 200)
                .border(Color.black)
                .background(Color.white)
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button("Clear", action: clear)
                    }
                    ToolbarItem {
                        Button("Save as PDF", action: exportPDF)
                    }
                    ToolbarItem {
                        Button("Save as PNG", action: exportPNG)
                    }
                }
        }
    }
    
    func clear()
    {
        signature.clear()
    }

    func exportPDF()
    {
        #if os(macOS)
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "signature.pdf"
        savePanel.allowedContentTypes = [.pdf]
        savePanel.begin { result in
            if result == .OK, let url = savePanel.url, let pdfData = try? signature.getPDF() {
                try? pdfData.write(to: url)

            }
        }
        #endif
    }

    func exportPNG()
    {
        #if os(macOS)
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "signature.png"
        savePanel.allowedContentTypes = [.png]
        savePanel.begin { result in
            if result == .OK,
               let url = savePanel.url,
               let cgImage = try? signature.getImage(),
               let pngData = NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:])
            {
                try? pngData.write(to: url)
            }
        }
        #endif
    }
}
