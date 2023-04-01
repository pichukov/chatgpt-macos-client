import SwiftUI

@main
struct ChatGPTClientApp: App {
    @State private var window: NSWindow?
    var body: some Scene {
        WindowGroup {
            Group {
                if window != nil {
                    ContentView(store: WindowStore(window: window))
                }
            }
            .background(WindowAccessor(window: $window))
        }
    }
}

class WindowStore {
    var window: NSWindow?

    init(window: NSWindow?) {
        self.window = window
    }
}

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
