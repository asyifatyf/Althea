//
//  HomeView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI
import GameKit

struct HomeView: View {
    @EnvironmentObject private var game: RealTimeGame
    @State private var showFriends = false
    
    var body: some View {
        ZStack{
            Image("homePageBg").resizable()
                .scaledToFill()
                .scaleEffect(1.2)
        VStack{
            // Display the game title.
            Text("AlTHEA")
                .font(.title)
                .padding()
            Spacer()
            Button {
                game.choosePlayer()
            } label: {
                Text("START")
            }.disabled(!game.matchAvailable)
            
            Button {
                game.addFriends()
            } label: {
                Text("ADD FRIENDS")
            }.disabled(!game.matchAvailable)
           
            Button {
                Task{
                    await game.accessFriends()
                    showFriends = true
                    GKAccessPoint.shared.isActive = false
                }
            } label: {
                Text("MY FRIENDS")
            }.disabled(!game.matchAvailable)

//            Form {
//                Section("Start Game") {
//                    Button("Choose Player") {
//                        game.choosePlayer()
//                    }
//
//
//                }
//
//                Section("Friends") {
//                    Button("Add Friends") {
//                        game.addFriends()
//                    }
//
//                    Button("Access Friends") {
//                        Task {
//                            await game.accessFriends()
//                            showFriends = true
//                            GKAccessPoint.shared.isActive = false
//                        }
//                    }
//                }
//            }
//            .disabled(!game.matchAvailable)
        }
    }
        // Authenticate the local player when the game first launches.
        .onAppear {
            if !game.playingGame {
                game.authenticatePlayer()
            }
        }
            
        // Display the game interface if a match is ongoing.
        .fullScreenCover(isPresented: $game.playingGame) {
            RolePickView()
        }
        
        // Display the local player's friends.
        .sheet(isPresented: $showFriends, onDismiss: {
            showFriends = false
            GKAccessPoint.shared.isActive = true
        }) {
            FriendsView(game: game)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(RealTimeGame())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

