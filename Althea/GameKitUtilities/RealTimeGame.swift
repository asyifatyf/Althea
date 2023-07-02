//
//  RealTimeGame.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import Foundation
import GameKit
import SwiftUI

/// - Tag:RealTimeGame
@MainActor
class RealTimeGame: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    // The local player's friends, if they grant access.
    @Published var friends: [Friend] = []
    
    static let shared = RealTimeGame()
    // The game interface state.
    @Published var matchAvailable = false
    @Published var playingGame = false
    @Published var myMatch: GKMatch? = nil 
    
    // The match information.
    @Published var myAvatar = Image(systemName: "person.crop.circle")
    @Published var opponentAvatar = Image(systemName: "person.crop.circle")
    @Published var opponentAvatar1 = Image(systemName: "person.crop.circle")
    @Published var opponent  : GKPlayer? = nil
    @Published var opponent1 : GKPlayer? = nil
    @Published var messages: [Message] = []
    @Published var myScore = 0
    @Published var myRole = ""
    
    // The voice chat properties.
    @Published var voiceChat: GKVoiceChat? = nil
    @Published var opponentSpeaking = false
    
    @Published var navigatorName = ""
    @Published var supplyName = ""
    @Published var cookName = ""
    
    // Ready properties
    @Published var isNavigatorReady: Bool = false
    @Published var isSupplyReady: Bool = false
    @Published var isCookReady: Bool = false
    @Published var numbersPlayerReady: Int = 0
    @Published var isActive: Bool = false
    
    //in game data
    @Published var navigatorXPosition: CGFloat = 0
    @Published var supplyXPosition: CGFloat = 0
    @Published var cookXPosition: CGFloat = 0
    @Published var navigatorYPosition: CGFloat = 0
    @Published var supplyYPosition: CGFloat = 0
    @Published var cookYPosition: CGFloat = 0
    
    @Published var isNavigatorData: Bool = false
    @Published var isSupplyData: Bool = false
    @Published var isCookData: Bool = false
    
    @Published var navigatorOrientation: String = "upStop"
    @Published var supplyOrientation: String = "upStop"
    @Published var cookOrientation: String = "upStop"
    
    @Published var objectType: String = ""
    @Published var isObjectAvailable: Bool = false
    
    @Published var navigatorEnergy: CGFloat = 0
    @Published var supplyEnergy: CGFloat = 0
    @Published var cookEnergy: CGFloat = 0
    @Published var isEnergyData: Bool = false
    
    
    /// The name of the match.
    var matchName: String {
        "\(opponentName) Match"
    }
    
    /// The local player's name.
    var myName: String {
        GKLocalPlayer.local.displayName
    }
    
    /// The opponent's name.
    var opponentName: String {
        opponent?.displayName ?? "Invitation Pending"
    }
//    var opponentName1: String {
//        opponent1?.displayName ?? "Invitation Pending"
//    }
    
    /// The root view controller of the window.
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }

    /// Authenticates the local player, initiates a multiplayer game, and adds the access point.
    /// - Tag:authenticatePlayer
    func authenticatePlayer() {
        // Set the authentication handler that GameKit invokes.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If the view controller is non-nil, present it to the player so they can
                // perform some necessary action to complete authentication.
                self.rootViewController?.present(viewController, animated: true) { }
                return
            }
            if let error {
                // If you can’t authenticate the player, disable Game Center features in your game.
                print("Error: \(error.localizedDescription).")
                return
            }
            
            // A value of nil for viewController indicates successful authentication, and you can access
            // local player properties.
            
            // Load the local player's avatar.
            GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
                if let image {
                    self.myAvatar = Image(uiImage: image)
                }
                if let error {
                    // Handle an error if it occurs.
                    print("Error: \(error.localizedDescription).")
                }
            }

            // Register for real-time invitations from other players.
            GKLocalPlayer.local.register(self)
            
            // Add an access point to the interface.
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = true
            
            // Enable the Start Game button.
            self.matchAvailable = true
        }
    }
    
    
    /// Presents the matchmaker interface where the local player selects and sends an invitation to another player.
    /// - Tag:choosePlayer
    func choosePlayer() {
        // Create a match request.
        let request = GKMatchRequest()
        request.minPlayers = 3
        request.maxPlayers = 3
        
        // Present the interface where the player selects opponents and starts the game.
        if let viewController = GKMatchmakerViewController(matchRequest: request) {
            viewController.matchmakerDelegate = self
            rootViewController?.present(viewController, animated: true) { }
        }
    }
    
    // Starting and stopping the game.
    
    /// Starts a match.
    /// - Parameter match: The object that represents the real-time match.
    /// - Tag:startMyMatchWith
    func startMyMatchWith(match: GKMatch) {
        GKAccessPoint.shared.isActive = false
        playingGame = true
        myMatch = match
        myMatch?.delegate = self
        
        // For automatch, check whether the opponent connected to the match before loading the avatar.
        if myMatch?.expectedPlayerCount == 0 {
            opponent = myMatch?.players[0]
            opponent1 = myMatch?.players[1]
            
            // Load the opponent's avatar.
            opponent?.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
                if let image {
                    self.opponentAvatar = Image(uiImage: image)
                }
                if let error {
                    print("Error: \(error.localizedDescription).")
                }
            }
            
            opponent1?.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
                if let image {
                    self.opponentAvatar1 = Image(uiImage: image)
                }
                if let error {
                    print("Error: \(error.localizedDescription).")
                }
            }
        }
            
        // Increment the achievement to play 10 games.
//        reportProgress()
    }
    
    func ready() {
//        isReady.toggle()
        numbersPlayerReady += 1
        switch myRole{
        case "navigator":
            isNavigatorReady = true
            
            do {
                let ready = encode(playerReady: isNavigatorReady)
                try myMatch?.sendData(toAllPlayers: ready!, with: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        case "supply":
            isSupplyReady = true
            do {
                let ready = encode(playerReady: isSupplyReady)
                try myMatch?.sendData(toAllPlayers: ready!, with: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        case "cook":
            isCookReady = true
            do {
                let ready = encode(playerReady: isCookReady)
                try myMatch?.sendData(toAllPlayers: ready!, with: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        default:
            return
        }
        
        if numbersPlayerReady == 3 {
            isActive = true
            do {
                let pindah = encode(moveToScene: isActive)
                try myMatch?.sendData(toAllPlayers: pindah!, with: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        }

    }
    
    /// Takes the player's turn.
    /// - Tag:takeAction
    func roleNavigator() {
        // Take your turn by incrementing the counter.
        myScore = 1
        navigatorName = myName
        myRole = "navigator"
        

        do {
            let data = encode(score: myScore)
            try myMatch?.sendData(toAllPlayers: data!, with: GKMatch.SendDataMode.unreliable)
            let roleName = encode(navigatorName: navigatorName)
            try myMatch?.sendData(toAllPlayers: roleName!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    func roleSupply() {
        // Take your turn by incrementing the counter.
        myScore = 2
        supplyName = myName
        myRole = "supply"

        do {
            let data = encode(score: myScore)
            try myMatch?.sendData(toAllPlayers: data!, with: GKMatch.SendDataMode.unreliable)
            let roleName = encode(supplyName: supplyName)
            try myMatch?.sendData(toAllPlayers: roleName!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    func roleCook() {
        // Take your turn by incrementing the counter.
        myScore = 3
        cookName = myName
        myRole = "cook"

        do {
            let data = encode(score: myScore)
            try myMatch?.sendData(toAllPlayers: data!, with: GKMatch.SendDataMode.unreliable)
            let roleName = encode(cookName: cookName)
            try myMatch?.sendData(toAllPlayers: roleName!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendNavigatorData(xPosition: CGFloat, yPosition: CGFloat) {
        do {
            let dataX = encodeChar(xPosition: xPosition)
            try myMatch?.sendData(toAllPlayers: dataX!, with: GKMatch.SendDataMode.unreliable)
            let dataY = encodeChar(yPosition: yPosition)
            try myMatch?.sendData(toAllPlayers: dataY!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendNavigatorOrientation(navigatorOrientation: String) {
        do {
            let navigatorOrientation = encodeChar(characterOrientation: navigatorOrientation)
            try myMatch?.sendData(toAllPlayers: navigatorOrientation!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }

    
    func sendSupplyData(xPosition: CGFloat, yPosition: CGFloat) {
        do {
            let dataX = encodeChar(xPosition: xPosition)
            try myMatch?.sendData(toAllPlayers: dataX!, with: GKMatch.SendDataMode.unreliable)
            let dataY = encodeChar(yPosition: yPosition)
            try myMatch?.sendData(toAllPlayers: dataY!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendSupplyOrientation(supplyOrientation: String) {
        do {
            let supplyOrientation = encodeChar(characterOrientation: supplyOrientation)
            try myMatch?.sendData(toAllPlayers: supplyOrientation!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }

    func sendCookData(xPosition: CGFloat, yPosition: CGFloat) {
        do {
            let dataX = encodeChar(xPosition: xPosition)
            try myMatch?.sendData(toAllPlayers: dataX!, with: GKMatch.SendDataMode.unreliable)
            let dataY = encodeChar(yPosition: yPosition)
            try myMatch?.sendData(toAllPlayers: dataY!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendCookOrientation(cookOrientation: String) {
        do {
            let cookOrientation = encodeChar(characterOrientation: cookOrientation)
            try myMatch?.sendData(toAllPlayers: cookOrientation!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendObjectType(objectType: String) {
        do {
            let objectType = encodeChar(objectType: objectType)
            try myMatch?.sendData(toAllPlayers: objectType!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
    
    func sendEnergy(energyAmount: CGFloat, who: String) {
        var supplyPlayer: GKPlayer
        var navigatorPlayer: GKPlayer
        if "\(myMatch?.players[0])" == supplyName{
            supplyPlayer = (myMatch?.players[0])!
            navigatorPlayer = (myMatch?.players[1])!
        } else{
            supplyPlayer = (myMatch?.players[1])!
            navigatorPlayer = (myMatch?.players[0])!
        }
        if who == "supply"{
            do {
                let energyAmount = encodeChar(characterEnergy: energyAmount)
                try myMatch?.send(energyAmount!, to: [supplyPlayer], dataMode: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        } else if who == "navigator"{
            do {
                let energyAmount = encodeChar(characterEnergy: energyAmount)
                try myMatch?.send(energyAmount!, to: [navigatorPlayer], dataMode: GKMatch.SendDataMode.unreliable)
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        }
    }
//    func sendEnergyNavigator(energyAmount: CGFloat) {
//
//        var navigatorPlayer: GKPlayer
//        if "\(myMatch?.players[0])" == navigatorName{
//            navigatorPlayer = (myMatch?.players[0])!
//        } else{
//            navigatorPlayer = (myMatch?.players[1])!
//
//        }
//        do {
//            let energyAmount = encodeChar(characterEnergy: energyAmount)
//            try myMatch?.send(energyAmount!, to: [navigatorPlayer], dataMode: GKMatch.SendDataMode.unreliable)
//        } catch {
//            print("Error: \(error.localizedDescription).")
//        }
//    }

    
    /// Quits a match and saves the game data.
    /// - Tag:endMatch
//    func endMatch() {
//        let myOutcome = myScore >= opponentScore ? "won" : "lost"
//        let opponentOutcome = opponentScore > myScore ? "won" : "lost"
//
//        // Notify the opponent that they won or lost, depending on the score.
//        do {
//            let data = encode(outcome: opponentOutcome)
//            try myMatch?.sendData(toAllPlayers: data!, with: GKMatch.SendDataMode.unreliable)
//        } catch {
//            print("Error: \(error.localizedDescription).")
//        }
//
//        // Notify the local player that they won or lost.
//        if myOutcome == "won" {
//            youWon = true
//        } else {
//            opponentWon = true
//        }
//    }
    
    /// Forfeits a match without saving the score.
    /// - Tag:forfeitMatch
//    func forfeitMatch() {
//        // Notify the opponent that you forfeit the game.
//        do {
//            let data = encode(outcome: "forfeit")
//            try myMatch?.sendData(toAllPlayers: data!, with: GKMatch.SendDataMode.unreliable)
//        } catch {
//            print("Error: \(error.localizedDescription).")
//        }
//
//        youForfeit = true
//    }
    
    
    /// Resets a match after players reach an outcome or cancel the game.
    func resetMatch() {
        // Reset the game data.
        playingGame = false
        myMatch?.disconnect()
        myMatch?.delegate = nil
        myMatch = nil
        voiceChat = nil
        opponent = nil
        opponent1 = nil
        opponentAvatar = Image(systemName: "person.crop.circle")
        opponentAvatar1 = Image(systemName: "person.crop.circle")
        messages = []
        GKAccessPoint.shared.isActive = true
//        youForfeit = false
//        opponentForfeit = false
//        youWon = false
//        opponentWon = false
        
        // Reset the score.
        myScore = 0
    }
    
}
