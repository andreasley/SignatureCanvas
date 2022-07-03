import SwiftUI
import SignatureCanvas

@main
struct TestApp: App
{
    @ObservedObject var signature = Signature()
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    class AppDelegate: NSObject, NSApplicationDelegate
    {
        func applicationDidFinishLaunching(_ notification: Notification)
        {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    #endif

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
        .onChange(of: signature.hasDrawing, perform: { newValue in print("Signature has drawing: \(signature.hasDrawing)") })
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
               let pngData = try? signature.getImage(scalingFactor: 2, cropTo: .drawing(padding: 1))
            {
                try? pngData.write(to: url)
            }
        }
        #endif
    }
}
