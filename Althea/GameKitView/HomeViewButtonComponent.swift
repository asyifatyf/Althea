//
//  HomeViewButtonComponent.swift
//  Althea
//
//  Created by James Jeremia on 29/06/23.
//

import SwiftUI
import GameKit

struct HomeViewButtonComponent: View {
    
    @EnvironmentObject private var game: RealTimeGame
    @Binding var showFriends: Bool
    
    var body: some View {
        VStack{
            Button {
                game.choosePlayer()
            } label: {
                Image("PlayButton")
            }.disabled(!game.matchAvailable)
            
            Button {
                game.addFriends()
            } label: {
                Image("InviteFriendButton")
            }.disabled(!game.matchAvailable)
           
            Button {
                Task{
                    await game.accessFriends()
                    showFriends = true
                    GKAccessPoint.shared.isActive = false
                }
            } label: {
                Image("FriendListButton")
            }.disabled(!game.matchAvailable)    }

        }
}

struct HomeViewButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewButtonComponent(showFriends: .constant(false)).environmentObject(RealTimeGame())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
