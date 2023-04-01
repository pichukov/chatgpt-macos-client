//
//  TextEditorDS.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import SwiftUI

struct TextEditorDS: View {

    @Binding var text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.border, lineWidth: 2)
                .foregroundColor(.textBackground)
            TextEditor(text: $text)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(8)
        }
    }
}

struct TextEditorDS_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorDS(text: .constant("Hello world"))
            .padding()
            .frame(height: 80)
    }
}
