//
//  SessionView.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import MarkdownUI
import SwiftUI

struct SessionView: View {

    @Namespace private var bottomID
    @ObservedObject private var viewModel: SessionViewModel

    init(viewModel: SessionViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.ready {
                VStack {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            ForEach(viewModel.chatItems, id: \.id) { item in
                                ChatItemView(item: item) {
                                    viewModel.reset(fromID: item.id)
                                }
                            }
                            .padding(.trailing, 16)
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Color.clear
                                .frame(height: 1)
                                .id(bottomID)
                        }
                        .onChange(of: viewModel.chatItems.count) { _ in
                            scrollProxy.scrollTo(bottomID)
                        }
                    }
                    HStack {
                        TextEditorDS(text: $viewModel.message)
                            .frame(height: 80)
                        ButtonDS("Send") {
                            viewModel.request()
                        }
                    }
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    Text("You have to provide token first. Go to Settings and add your token there.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.checkToken()
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(viewModel: SessionViewModel())
    }
}
