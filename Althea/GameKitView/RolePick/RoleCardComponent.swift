//
//  RoleCardComponent.swift
//  Althea
//
//  Created by James Jeremia on 22/06/23.
//

import SwiftUI

struct RoleCardComponent: View {
    
    @EnvironmentObject var game: RealTimeGame

    var body: some View {
        HStack{
            VStack{
                Rectangle().foregroundColor(.red).frame(width: 150, height: 200)
                    .onTapGesture {
                        if !game.isReady{
                            game.roleNavigator()
                            print(game.myScore)
                        }
                        
                    }.disabled((game.isReady && game.myScore == 1) || (game.isOpponentReady && game.opponentScore == 1) || (game.isOpponent1Ready && game.opponentScore1 == 1))
                Text("\(game.navigatorName)")
            }
            VStack{
                Rectangle()
                    .foregroundColor(.green).frame(width: 150, height: 200)
                    .onTapGesture {
                        if !game.isReady{
                            game.roleSupply()
                        }
                    }.disabled((game.isReady && game.myScore == 2) || (game.isOpponentReady && game.opponentScore == 2) || (game.isOpponent1Ready && game.opponentScore1 == 2))
                Text("\(game.supplyName)")
                
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
        }    }
}

struct RoleCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoleCardComponent()
    }
}
