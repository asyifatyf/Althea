//
//  RealTimeGame+MatchData.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import Foundation
import GameKit
import SwiftUI

// MARK: Game Data Objects

struct GameData: Codable {
    var matchName: String
    var playerName: String
    var score: Int?
    var roleName: String?
    var message: String?
    var playerReady: Bool?
    var moveToScene: Bool?
}

struct CharacterData: Codable {
    var xCharacterPos: CGFloat?
    var yCharacterPos: CGFloat?
}

extension RealTimeGame {
    
    // MARK: Codable Game Data
    
    /// Creates a data representation of the local player's score for sending to other players.
    ///
    /// - Returns: A representation of game data that contains only the score.
    func encode(score: Int) -> Data? {
        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: score, message: nil)
        return encode(gameData: gameData)
    }
    
    /// Creates a data representation of a text message for sending to other players.
    ///
    /// - Parameter message: The message that the local player enters.
    /// - Returns: A representation of game data that contains only a message.
    func encode(message: String?) -> Data? {
        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: nil, message: message)
        return encode(gameData: gameData)
    }
    
    func encodeChar(xPosition: CGFloat?) -> Data? {
        let characterData = CharacterData(xCharacterPos: xPosition)
        return encodeChar(characterData: characterData)
    }
    func encodeChar(yPosition: CGFloat?) -> Data? {
        let characterData = CharacterData(yCharacterPos: yPosition)
        return encodeChar(characterData: characterData)
    }
    
    func encode(roleName: String) -> Data? {
        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: nil, roleName: roleName, message: nil)
        return encode(gameData: gameData)
    }
    
    func encode(playerReady: Bool?) -> Data? {
        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: nil, roleName: nil, message: nil, playerReady: playerReady)
        return encode(gameData: gameData)
    }
    func encode(moveToScene : Bool?) -> Data? {
        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: nil, roleName: nil, message: nil, playerReady: nil, moveToScene: moveToScene)
        return encode(gameData: gameData)
    }
    
    /// Creates a data representation of the game outcome for sending to other players.
    ///
    /// - Returns: A representation of game data that contains only the game outcome.
//    func encode(outcome: String) -> Data? {
//        let gameData = GameData(matchName: matchName, playerName: GKLocalPlayer.local.displayName, score: nil, message: nil, outcome: outcome)
//        return encode(gameData: gameData)
//    }
    
    /// Creates a data representation of game data for sending to other players.
    ///
    /// - Returns: A representation of game data.
    func encode(gameData: GameData) -> Data? {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        do {
            let data = try encoder.encode(gameData)
            return data
        } catch {
            print("Error: \(error.localizedDescription).")
            return nil
        }
    }
    
    func encodeChar(characterData: CharacterData) -> Data? {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
            let data = try encoder.encode(characterData)
            return data
        } catch {
            print("Error: \(error.localizedDescription).")
            return nil
        }
    }
    
    /// Decodes a data representation of match data from another player.
    ///
    /// - Parameter matchData: A data representation of the game data.
    /// - Returns: A game data object.
    func decode(matchData: Data) -> GameData? {
        // Convert the data object to a game data object.
        return try? PropertyListDecoder().decode(GameData.self, from: matchData)
    }
    
    func decodeChar(matchData: Data) -> CharacterData? {
        // Convert the data object to a game data object.
        return try? PropertyListDecoder().decode(CharacterData.self, from: matchData)
    }
}
