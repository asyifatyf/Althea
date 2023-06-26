//
//  RealTimeGame+GKMatchDelegate.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import Foundation
import GameKit
import SwiftUI

extension RealTimeGame: GKMatchDelegate {
    /// Handles a connected, disconnected, or unknown player state.
    /// - Tag:didChange
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .connected:
            print("\(player.displayName) Connected")
            
            // For automatch, set the opponent and load their avatar.
            if match.expectedPlayerCount == 0 {
                opponent = match.players[0]
                
                // Load the opponent's avatar.
                opponent?.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
                    if let image {
                        self.opponentAvatar = Image(uiImage: image)
                    }
                    if let error {
                        print("Error: \(error.localizedDescription).")
                    }
                }
            }
        case .disconnected:
            print("\(player.displayName) Disconnected")
        default:
            print("\(player.displayName) Connection Unknown")
        }
    }
    
    /// Handles an error during the matchmaking process.
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        print("\n\nMatch object fails with error: \(error!.localizedDescription)")
    }
    
    /// Reinvites a player when they disconnect from the match.
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        return false
    }
    
    /// Handles receiving a message from another player.
    /// - Tag:didReceiveData
    
    
    /// Receive a message from one player to another.
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer){
        myMatch = match
        let gameData = decode(matchData: data)
        let characterData = decodeChar(matchData: data)
        opponent = myMatch?.players[0]
        opponent1 = myMatch?.players[1]
        
        if player == opponent{
            if let score = gameData?.score{
                opponentScore = score
            } else if let roleName = gameData?.roleName{
                if opponentScore == 1{
                    navigatorName = roleName
                } else if opponentScore == 2{
                    supplyName = roleName
                } else if opponentScore == 3{
                    cookName = roleName
                }
            }else if let playerReady = gameData?.playerReady{
                isOpponentReady = playerReady
                numbersPlayerReady += 1
            }
            else if let moveToScene = gameData?.moveToScene{
                isActive = true
            }
            else if let charPos = characterData?.xCharacterPos {
                switch opponentScore {
                case 1:
                    navigatorXPosition = charPos
                case 2:
                    supplyXPosition = charPos
                case 3:
                    cookXPosition = charPos
                default:
                    return
                }
            }
            else if let charPos = characterData?.yCharacterPos{
                switch opponentScore1 {
                case 1:
                    navigatorYPosition = charPos
                case 2:
                    supplyYPosition = charPos
                case 3:
                    cookYPosition = charPos
                default:
                    return
                }
                
            }
            
        } else if player == opponent1 {
            if let score = gameData?.score{
                opponentScore1 = score
            } else if let roleName = gameData?.roleName{
                if opponentScore1 == 1{
                    navigatorName = roleName
                } else if opponentScore1 == 2{
                    supplyName = roleName
                } else if opponentScore1 == 3{
                    cookName = roleName
                }
            }else if let playerReady = gameData?.playerReady{
                isOpponent1Ready = playerReady
                numbersPlayerReady += 1
            }
            else if let moveToScene = gameData?.moveToScene{
                isActive = true
            }
            else if let charPos = characterData?.xCharacterPos{
                switch opponentScore1 {
                case 1:
                    navigatorXPosition = charPos
                case 2:
                    supplyXPosition = charPos
                case 3:
                    cookXPosition = charPos
                default:
                    return
                }
                
            }
            else if let charPos = characterData?.yCharacterPos{
                switch opponentScore1 {
                case 1:
                    navigatorYPosition = charPos
                case 2:
                    supplyYPosition = charPos
                case 3:
                    cookYPosition = charPos
                default:
                    return
                }
                
            }
        }
    }
    //    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
    //        // Decode the data representation of the game data.
    //        let gameData = decode(matchData: data)
    //
    //        // Update the interface from the game data.
    //        if let text = gameData?.message {
    //            // Add the message to the chat view.
    //            let message = Message(content: text, playerName: player.displayName, isLocalPlayer: false)
    //            messages.append(message)
    //        } else if let score = gameData?.score {
    //            // Show the opponent's score.
    //            opponentScore = score
    //        } else if let roleName = gameData?.roleName {
    //            // Show the opponent's score.
    //            if opponentScore == 1 {
    //                navigatorName = roleName
    //            } else if opponentScore == 2 {
    //                supplyName = roleName
    //            } else if opponentScore == 3 {
    //                cookName = roleName
    //            }
    //
    //        } else if let outcome = gameData?.outcome {
    //            // Show the outcome of the game.
    //            switch outcome {
    //            case "forfeit":
    //                opponentForfeit = true
    //            case "won":
    //                youWon = true
    //            case "lost":
    //                opponentWon = true
    //            default:
    //                return
    //            }
    //        }
    //    }
}
