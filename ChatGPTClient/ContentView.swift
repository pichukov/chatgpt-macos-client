import MarkdownUI
import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel()
    private let windowStore: WindowStore

    init(store: WindowStore) {
        windowStore = store
    }

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: SessionView(viewModel: viewModel.getSessionViewModel()),
                    isActive: $viewModel.isChatsSelected
                ) {
                    Label("Chats", systemImage: "message")
                      .navigationTitle("Chats")
                }
                NavigationLink(
                    destination: SettingsView(tokenDelegate: viewModel),
                    isActive: $viewModel.isSettingsSelected
                ) {
                    Label("Settings", systemImage: "gear")
                      .navigationTitle("Settings")
                }
            }
            .navigationTitle("Menu")
        }
        .listStyle(.sidebar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: WindowStore(window: nil))
    }
}
