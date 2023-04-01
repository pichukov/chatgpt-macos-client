//
//  SettingsView.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import SwiftUI

struct SettingsView: View {

    @State private var token: String = ""
    @State private var currenToken: String = ""
    private weak var tokenDelegate: TokenDelegate?

    init(tokenDelegate: TokenDelegate? = nil) {
        self.tokenDelegate = tokenDelegate
    }

    var body: some View {
        VStack {
            if currenToken.isEmpty {
                Text("Set up your token. You can't chat without it!")
                    .font(.title)
            } else {
                Text(currenToken)
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
            TextField("Token", text: $token)
            ButtonDS("Update token") {
                tokenDelegate?.update(token: token)
                currenToken = token
                token = ""
            }
            .disabled(token.isEmpty)
        }
        .padding(60)
        .onAppear {
            currenToken = tokenDelegate?.getToken() ?? ""
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
