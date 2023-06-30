//
//  ReadyButtonComponent.swift
//  Althea
//
//  Created by James Jeremia on 22/06/23.
//

import SwiftUI

struct ReadyButtonComponent: View {
    
    @EnvironmentObject var game: RealTimeGame
    
    @State private var isButtonClicked = false
    @State var readyStatus: Bool = false

    
    var body: some View {
        Button(action: {
            isButtonClicked.toggle()
            game.ready()
            switch game.myRole{
            case "navigator":
                readyStatus = game.isNavigatorReady
            case "supply":
                readyStatus = game.isSupplyReady
            case "cook":
                readyStatus = game.isCookReady
            default:
                return
            }
            
        })
        {
            Image(isButtonClicked ? "buttonWaiting" : "readyButton")

        }
        .disabled(readyStatus)
        
    }
}

struct ReadyButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ReadyButtonComponent()
            .environmentObject(RealTimeGame())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
