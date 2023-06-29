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
    @State var showFriends: Bool = false
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Image("BackgroundInvitePage").resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            HStack{
                // Display the game title.
                Image("LogoAlthea")
                    .font(.title)
                    .padding(.horizontal)
                Spacer().frame(width: 100)
                HomeViewButtonComponent(showFriends: $showFriends)

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
            .navigationBarBackButtonHidden(true)
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
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(RealTimeGame())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

