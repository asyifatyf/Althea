//
//  MessageView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        Text(message.content)
            .padding(10)
            .foregroundColor(message.isLocalPlayer ? Color.white : Color.black)
            .background(message.isLocalPlayer ? Color.blue : Color(white: 240 / 255.0))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .frame(maxWidth: .infinity, alignment: message.isLocalPlayer ? .bottomTrailing : .bottomLeading)
    }
}

struct MessageViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageView(message: Message(content: "This is the local player.", playerName: "Player 1",
                                         isLocalPlayer: true))
            MessageView(message: Message(content: "This is the remote player.", playerName: "Player 2",
                                         isLocalPlayer: false))
        }
    }
}
