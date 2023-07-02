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
        
        if let receiveNavigatorName = gameData?.navigatorName{
            navigatorName = receiveNavigatorName
        } else if let receiveSupplyName = gameData?.supplyName{
            supplyName = receiveSupplyName
        } else if let receiveCookName = gameData?.cookName{
            cookName = receiveCookName
        }
        
        
        if player.alias == navigatorName {
            if let playerReady = gameData?.playerReady{
                isNavigatorReady = playerReady
                numbersPlayerReady += 1
            } else if let moveToScene = gameData?.moveToScene{
                isActive = moveToScene
            } else if let xCharPos = characterData?.xCharacterPos{
                navigatorXPosition = xCharPos
                isNavigatorData = true
            } else if let yCharPos = characterData?.yCharacterPos{
                navigatorYPosition = yCharPos
                isNavigatorData = true
            } else if let orientation = characterData?.characterOrientation{
                navigatorOrientation = orientation
                isNavigatorData = true
            } else if let objectTypeData = characterData?.objectType{
                objectType = objectTypeData
                isObjectAvailable = true
            }
//            else if let characterEnergy = characterData?.characterEnergy{
//                navigatorEnergy = characterEnergy
//                isEnergyData = true
//            }
            
        } else if player.alias == supplyName {
            if let playerReady = gameData?.playerReady{
                isSupplyReady = playerReady
                numbersPlayerReady += 1
            } else if let moveToScene = gameData?.moveToScene{
                isActive = moveToScene
            } else if let xCharPos = characterData?.xCharacterPos{
                supplyXPosition = xCharPos
                isSupplyData = true
            } else if let yCharPos = characterData?.yCharacterPos{
                supplyYPosition = yCharPos
                isSupplyData = true
            }else if let orientation = characterData?.characterOrientation{
                supplyOrientation = orientation
                isSupplyData = true
            }else if let objectTypeData = characterData?.objectType{
                objectType = objectTypeData
                isObjectAvailable = true
            }
//            else if let characterEnergy = characterData?.characterEnergy{
//                supplyEnergy = characterEnergy
//                isEnergyData = true
//            }
            
        } else if player.alias == cookName {
            if let playerReady = gameData?.playerReady{
                isCookReady = playerReady
                numbersPlayerReady += 1
            } else if let moveToScene = gameData?.moveToScene{
                isActive = moveToScene
            } else if let xCharPos = characterData?.xCharacterPos{
                cookXPosition = xCharPos
                isCookData = true
            } else if let yCharPos = characterData?.yCharacterPos{
                cookYPosition = yCharPos
                isCookData = true
            }
            else if let orientation = characterData?.characterOrientation{
                cookOrientation = orientation
                isCookData = true
            }else if let objectTypeData = characterData?.objectType{
                objectType = objectTypeData
                isObjectAvailable = true
            }else if let characterEnergy = characterData?.characterEnergy{
                if myRole == "supply" {
                    supplyEnergy += characterEnergy
                } else if myRole == "navigator" {
                    navigatorEnergy += characterEnergy
                }
//                cookEnergy = characterEnergy
                isEnergyData = true
            }
        }
        

        
        
//        if player == opponent{
//            if let score = gameData?.score{
//                opponentScore = score
//            } else if let roleName = gameData?.roleName{
//                if opponentScore == 1{
//                    navigatorName = roleName
//                } else if opponentScore == 2{
//                    supplyName = roleName
//                } else if opponentScore == 3{
//                    cookName = roleName
//                }
//            }else if let playerReady = gameData?.playerReady{
//                isOpponentReady = playerReady
//                numbersPlayerReady += 1
//            }
//            else if let moveToScene = gameData?.moveToScene{
//                isActive = true
//            }
//            else if let charPos = characterData?.xCharacterPos {
//                switch opponentScore {
//                case 1:
//                    navigatorXPosition = charPos
//                    isDataChanged1 = true
//                case 2:
//                    supplyXPosition = charPos
//                    isDataChanged1 = true
//                case 3:
//                    cookXPosition = charPos
//                    isDataChanged1 = true
//                default:
//                    return
//                }
//            }
//            else if let charPos = characterData?.yCharacterPos{
//                switch opponentScore1 {
//                case 1:
//                    navigatorYPosition = charPos
//                    isDataChanged1 = true
//                case 2:
//                    supplyYPosition = charPos
//                    isDataChanged1 = true
//
//                case 3:
//                    cookYPosition = charPos
//                    isDataChanged1 = true
//                default:
//                    return
//                }
//
//            }
//
//        } else if player == opponent1 {
//            if let score = gameData?.score{
//                opponentScore1 = score
//            } else if let roleName = gameData?.roleName{
//                if opponentScore1 == 1{
//                    navigatorName = roleName
//                } else if opponentScore1 == 2{
//                    supplyName = roleName
//                } else if opponentScore1 == 3{
//                    cookName = roleName
//                }
//            }else if let playerReady = gameData?.playerReady{
//                isOpponent1Ready = playerReady
//                numbersPlayerReady += 1
//            }
//            else if let moveToScene = gameData?.moveToScene{
//                isActive = true
//            }
//            else if let charPos = characterData?.xCharacterPos{
//                switch opponentScore1 {
//                case 1:
//                    navigatorXPosition = charPos
//                    isDataChanged2 = true
//
//                case 2:
//                    supplyXPosition = charPos
//                    isDataChanged2 = true
//
//                case 3:
//                    cookXPosition = charPos
//                    isDataChanged2 = true
//
//                default:
//                    return
//                }
//
//            }
//            else if let charPos = characterData?.yCharacterPos{
//                switch opponentScore1 {
//                case 1:
//                    navigatorYPosition = charPos
//                    isDataChanged2 = true
//
//                case 2:
//                    supplyYPosition = charPos
//                    isDataChanged2 = true
//
//                case 3:
//                    cookYPosition = charPos
//                    isDataChanged2 = true
//
//                default:
//                    return
//                }
//
//            }
//        }
    }
}
