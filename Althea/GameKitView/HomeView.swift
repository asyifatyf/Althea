//
//  HomeView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI
import GameKit
import AVFoundation

struct HomeView: View {
    @EnvironmentObject private var game: RealTimeGame
    @State var showFriends: Bool = false
    let audioURL = Bundle.main.url(forResource: "Althea-Soundtrack", withExtension: "mp3")
    @State private var audioPlayer: AVAudioPlayer?
    
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

            }
        }
            .navigationBarBackButtonHidden(true)
            // Authenticate the local player when the game first launches.
            .onAppear {
                if !game.playingGame {
                    game.authenticatePlayer()
                }

                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
                    audioPlayer?.numberOfLoops = -1 // Set the number of loops to -1 for infinite looping
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.volume = 0.4
                    audioPlayer?.play()
                    

                } catch{
                    print("Error loading audio file: \(error.localizedDescription)")
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
            })
            {
                FriendsView(game: game, showFriends: $showFriends)
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

