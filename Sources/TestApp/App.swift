import SwiftUI
import SignatureCanvas

@main
struct TestApp: App
{
    var body: some Scene {
        WindowGroup {
            SignatureCanvas()
                .frame(width: 500, height: 200)
                .border(Color.black)
                .padding()
        }
    }
}
