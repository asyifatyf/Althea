//
//  FriendsView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI
import GameKit

struct FriendsView: View {
    @ObservedObject var game: RealTimeGame
    @Binding var showFriends: Bool
    
    var body: some View {
        Spacer()
        Text("My Friends")
            .font(.title2)
        Form {
            Section() {
                if game.friends.isEmpty {
                    Text("Add some friends or grant the app access to your friends.")
                } else {
                    ForEach(game.friends) { friend in
                        Text(friend.player.displayName)
                            .lineLimit(2)
                    }
                }
            }
        }.onTapGesture {
            showFriends = false
        }
    }
}

struct FriendsIView_Previews: PreviewProvider {
    static var previews: some View {
        Form() {
            Section() {
                Text("Player 1")
                    .lineLimit(2)
                Text("Player 2")
                    .lineLimit(2)
            }
        }
    }
}

