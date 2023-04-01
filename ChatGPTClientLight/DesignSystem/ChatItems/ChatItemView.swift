//
//  ChatItemView.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import MarkdownUI
import SwiftUI

struct ChatItemView: View {

    let item: ChatItem
    let retryAction: () -> Void
    
    init(item: ChatItem, retryAction: @escaping () -> Void) {
        self.item = item
        self.retryAction = retryAction
    }

    var body: some View {
        HStack {
            sideView
            if item.role == .user {
                Spacer()
            }
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: Constants.infoTopSpace)
                ForEach(item.blocks, id: \.value) { block in
                    ZStack {
                        HStack {
                            Markdown(block.value)
                                .markdownTheme(.docC)
                                .textSelection(.enabled)
                        }
                        if case .code = block.type {
                            VStack {
                                HStack {
                                    Spacer()
                                    ButtonDS(
                                        "",
                                        icon: Image(systemName: "doc.on.doc"),
                                        style: .outlined
                                    ) {
                                        let pasteboard = NSPasteboard.general
                                        pasteboard.clearContents()
                                        pasteboard.setString(
                                            block.value.replacingOccurrences(
                                                of: "```",
                                                with: ""
                                            ),
                                            forType: .string
                                        )
                                    }
                                    .padding(.trailing, Constants.buttonTrailingSpace)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            if item.role == .assistant {
                Spacer()
            }
        }
    }

    private var sideView: some View {
        VStack(spacing: .zero) {
            Circle()
                .frame(
                    width: Constants.infoSpace,
                    height: Constants.infoSpace
                )
                .foregroundColor(accentColor)
            VerticalLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(accentColor)
                .frame(height: Constants.infoTopSpace - Constants.infoSpace)
            VStack(spacing: Constants.smallSpace) {
                Image(systemName: iconName)
                    .padding(.top, Constants.infoSpace)
                Text(item.date, style: .date)
                    .padding(.horizontal, Constants.infoSpace)
                    .padding(.top, Constants.smallSpace)
                Text(item.date, style: .time)
                    .padding(.bottom, Constants.smallSpace)
                if item.role == .assistant {
                    ButtonDS(
                        "", icon: Image(systemName: "arrow.2.squarepath"),
                        style: .outlined,
                        action: retryAction
                    )
                    .padding(.bottom, Constants.smallSpace)
                }
            }
            .background(accentColor)
            .cornerRadius(Constants.radius)
            VerticalLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(accentColor)
                
        }
        .frame(width: Constants.infoWidth)
    }

    private var accentColor: Color {
        switch item.role {
        case .user: return Color.orange.opacity(Constants.backOpacity)
        default: return Color.mint.opacity(Constants.backOpacity)
        }
    }

    private var iconName: String {
        switch item.role {
        case .user: return "person.fill"
        default: return "cloud.fill"
        }
    }
}

private extension ChatItemView {

    enum Constants {
        static let horizontalChatSpace: CGFloat = 48
        static let infoSpace: CGFloat = 6
        static let infoTopSpace: CGFloat = 24
        static let radius: CGFloat = 6
        static let infoWidth: CGFloat = 120
        static let buttonTopSpace: CGFloat = 4
        static let buttonTrailingSpace: CGFloat = 16
        static let smallSpace: CGFloat = 4
        static let backOpacity: CGFloat = 0.3
    }
}

struct VerticalLine: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        return path
    }
}

struct ChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: .zero) {
                ChatItemView(
                    item: ChatItem(
                        date: Date(),
                        role: .user,
                        blocks: [
                            .init(
                                value: "Hello",
                                type: .text
                            )
                        ],
                        raw: ""
                    ),
                    retryAction: {}
                )
                ChatItemView(
                    item: ChatItem(
                        date: Date(),
                        role: .assistant,
                        blocks: [
                            .init(
                                value: "Hello, write me a code that will implemnt merge sort algorithm in Swift",
                                type: .text
                            ),
                            .init(
                                value: "```\nvar foo = Foo()\nvar foo = Foo()```\n",
                                type: .code
                            )
                        ],
                        raw: ""
                    ),
                    retryAction: {}
                )
            }
        }
        .padding()
    }
}
