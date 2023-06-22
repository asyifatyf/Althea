//
//  GameView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI
import GameKit

struct RolePickView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var game: RealTimeGame
    @State private var showMessages = false
    @State private var isChatting = false
    @State private var isButtonEnabled = true
    @State private var buttonText = "Ready"
    @State private var buttonColor = Color(.blue)
    //    @State var navigatorName = ""
    //    @State var supplyName = ""
    //    @State var cookName = ""
    
    var body: some View {
        VStack {
            // Display the game title.
            Text("Real-Time Game")
                .font(.title)
            HStack{
                VStack{
                    Rectangle().foregroundColor(.red).frame(width: 150, height: 200)
                        .onTapGesture {
                            if !game.isReady{
                                game.roleNavigator()
                                print(game.myScore)
                            }
                            //                        self.navigatorName = game.myName
                            
                        }.disabled((game.isReady && game.myScore == 1) || (game.isOpponentReady && game.opponentScore == 1) || (game.isOpponent1Ready && game.opponentScore1 == 1))
                    Text("\(game.navigatorName)")
                    //                    Text("\(game.opponentScore) + \(game.opponentName)")
                }
                VStack{
                    Rectangle()
                        .foregroundColor(.green).frame(width: 150, height: 200)
                        .onTapGesture {
                            if !game.isReady{
                                game.roleSupply()
                                print(game.myScore)
                                
                            }
                        }.disabled((game.isReady && game.myScore == 2) || (game.isOpponentReady && game.opponentScore == 2) || (game.isOpponent1Ready && game.opponentScore1 == 2))
                    Text("\(game.supplyName)")
                    //                    Text("\(game.opponentScore1) + \(game.opponentName1)")
                    
                }
                VStack{
                    Rectangle().foregroundColor(.blue).frame(width: 150, height: 200)
                        .onTapGesture {
                            if !game.isReady{
                                game.roleCook()
                                print(game.myScore)
                            }
                            //                        self.cookName = game.myName
                        }.disabled((game.isReady && game.myScore == 3) || (game.isOpponentReady && game.opponentScore == 3) || (game.isOpponent1Ready && game.opponentScore1 == 3))
                    Text("\(game.cookName)")
                }
            }
            
            Button(action: {
                game.ready()
                print(game.isReady)
                buttonText = "Clicked"
                buttonColor = Color(.gray)
            }) {
                Text(buttonText)
                    .padding()
                    .background(buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(game.isReady)
            
            //            Text("\(game.opponentScore)")
            //            Text("\(game.opponentName)")
            //            Text("\(game.opponentScore1)")
            //            Text("\(game.opponentName1)")
            
            //            Form {
            //                Section("Game Data") {
            //                    // Display the local player's avatar, name, and score.
            //                    HStack {
            //                        HStack {
            //                            game.myAvatar
            //                                .resizable()
            //                                .frame(width: 35.0, height: 35.0)
            //                                .clipShape(Circle())
            //
            //                            Text(game.myName + " (me)")
            //                                .lineLimit(2)
            //                        }
            //                        Spacer()
            //
            //                        Text("\(game.myScore)")
            //                            .lineLimit(2)
            //                    }
            //
            //                    // Display the opponent's avatar, name, and score.
            //                    HStack {
            //                        HStack {
            //                            game.opponentAvatar
            //                                .resizable()
            //                                .frame(width: 35.0, height: 35.0)
            //                                .clipShape(Circle())
            //
            //                            Text(game.opponentName)
            //                                .lineLimit(2)
            //                        }
            //                        Spacer()
            //
            //                        Text("\(game.opponentScore)")
            //                            .lineLimit(2)
            //                    }
            //                }
            //                .listItemTint(.blue)
            //
            //                Section("Game Controls") {
            //                    Button("Navigator") {
            //                        game.roleNav()
            //                    }.onTapGesture {
            //
            //                    }
            //                    Button("Crafter") {
            //                        game.roleSupp()
            //                    }
            //
            //                }
            //                Section("Communications") {
            //                    HStack {
            //                        // Send text messages.
            //                        Button("Message") {
            //                            withAnimation(.easeInOut(duration: 1)) {
            //                                showMessages = true
            //                            }
            //                        }
            //                        .buttonStyle(MessageButtonStyle())
            //                        .onTapGesture {
            //                            presentationMode.wrappedValue.dismiss()
            //                        }
            //                    }
            //                    HStack {
            //                        // Voice chat with the opponent.
            //                        Toggle("Chat", isOn: $isChatting)
            //                            .onChange(of: isChatting) { value in
            //                                if value == true {
            //                                    game.startVoiceChat()
            //                                } else {
            //                                    game.stopVoiceChat()
            //                                }
            //                            }
            //                            .toggleStyle(ChatToggleStyle())
            //                            .disabled(!GKVoiceChat.isVoIPAllowed())
            //                    }
            //                }
            //            }
        }
        .sheet(isPresented: $showMessages, onDismiss: {
            showMessages = false
        }) {
            ChatView(game: game)
        }
        .alert("Game Over", isPresented: $game.youForfeit, actions: {
            Button("OK", role: .cancel) {
                game.resetMatch()
            }
        }, message: {
            Text("You forfeit. Opponent wins.")
        })
        .alert("Game Over", isPresented: $game.opponentForfeit, actions: {
            Button("OK", role: .cancel) {
                // Save the score when the opponent forfeits the game.
                //                game.saveScore()
                game.resetMatch()
            }
        }, message: {
            Text("Opponent forfeits. You win.")
        })
        .alert("Game Over", isPresented: $game.youWon, actions: {
            Button("OK", role: .cancel) {
                //  Save the score when the local player wins.
                //                game.saveScore()
                game.resetMatch()
            }
        }, message: {
            Text("You win.")
        })
        .alert("Game Over", isPresented: $game.opponentWon, actions: {
            Button("OK", role: .cancel) {
                game.resetMatch()
            }
        }, message: {
            Text("You lose.")
        })
    }
}

struct ChatToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "phone.fill" : "phone")
                .imageScale(.medium)
                .onTapGesture { configuration.isOn.toggle() }
            Text("Voice Chat")
        }
        .foregroundColor(Color.blue)
    }
}

struct MessageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isPressed ? "bubble.left.fill" : "bubble.left")
                .imageScale(.medium)
            Text("Text Chat")
        }
        .foregroundColor(Color.blue)
    }
}

struct RolePickViewPreviews: PreviewProvider {
    static var previews: some View {
        RolePickView(game: RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
    }
}
