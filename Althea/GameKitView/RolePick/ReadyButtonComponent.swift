//
//  ReadyButtonComponent.swift
//  Althea
//
//  Created by James Jeremia on 22/06/23.
//

import SwiftUI

struct ReadyButtonComponent: View {
    
    @EnvironmentObject var game: RealTimeGame

    @State private var buttonText = "Ready"
    @State private var buttonColor = Color(.blue)
    
    var body: some View {
        Button(action: {
            game.ready()
            print(game.isReady)
            buttonText = "Clicked"
            buttonColor = Color(.gray)
        })
        {
            Text(buttonText)
                .padding()
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(game.isReady)    }
}

//struct ReadyButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadyButtonComponent()
//    }
//}
