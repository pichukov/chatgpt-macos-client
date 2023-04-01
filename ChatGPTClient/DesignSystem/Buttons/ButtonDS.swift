//
//  ButtonDS.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import SwiftUI

struct ButtonDS: View {

    private let text: String
    private let icon: Image?
    private let style: ButtonDS.Style
    private var action: () -> Void

    init(
        _ text: String,
        icon: Image? = nil,
        style: ButtonDS.Style = .primary,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if let icon = icon {
                icon
                    .font(.title3)
                    .fontWeight(.medium)
            } else {
                Text(text)
                    .font(.title3)
            }
        }
        .if(style == .primary) { content in
            content.buttonStyle(PrimaryButtonStyle())
        }
        .if(style == .outlined) { content in
            content.buttonStyle(OutlinedButtonStyle())
        }
    }
}

extension ButtonDS {

    enum Style {
        case primary
        case outlined
    }
}

struct ButtonDS_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonDS("Test button") {}
                .padding()
            ButtonDS("Test button", icon: Image(systemName: "doc.on.doc")) {}
                .padding()
            ButtonDS("Test button", style: .outlined) {}
                .padding()
            ButtonDS("Test button", icon: Image(systemName: "doc.on.doc"), style: .outlined) {}
                .padding()
        }
    }
}
