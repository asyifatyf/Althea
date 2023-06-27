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
        GeometryReader { geometry in
            VStack (spacing: -330) {
                Image("chooseYourRole")
                    .position(x: geometry.size.width/2, y:geometry.size.height/12)
                    

                HStack (spacing: 40){
                    VStack{
                        Image("naviGroup")
                            .scaleEffect(0.95)
                            .onTapGesture {
                                if !game.isNavigatorReady{
                                    game.roleNavigator()
                                }
                                
                            }.disabled(game.isNavigatorReady)
//                            .disabled((game.isReady && game.myScore == 1) || (game.isOpponentReady && game.opponentScore == 1) || (game.isOpponent1Ready && game.opponentScore1 == 1))
                        Text("\(game.navigatorName)")
                            .foregroundColor(.black)
                            .offset(y: -24)
                    }
                    VStack{
                        Image("archieGroup")
                            .scaleEffect(0.95)
                            .offset(x: -6, y: -10)
                            .onTapGesture {
                                if !game.isSupplyReady{
                                    game.roleSupply()
                                }
                            }.disabled(game.isSupplyReady)
//                            .disabled((game.isReady && game.myScore == 2) || (game.isOpponentReady && game.opponentScore == 2) || (game.isOpponent1Ready && game.opponentScore1 == 2))
                        Text("\(game.supplyName)")
                            .foregroundColor(.black)
                            .offset(y: -34)
                        
                    }
                    VStack{
                        Image("pepperGroup")
                            .scaleEffect(0.95)
                            .offset(y: 3.4)
                            .onTapGesture {
                                if !game.isCookReady{
                                    game.roleCook()
                                    print(game.myScore)
                                }
                                //                        self.cookName = game.myName
                            }.disabled(game.isCookReady)
//                            .disabled((game.isReady && game.myScore == 3) || (game.isOpponentReady && game.opponentScore == 3) || (game.isOpponent1Ready && game.opponentScore1 == 3))
                        Text("\(game.cookName)")
                            .foregroundColor(.black)
                            .offset(y: -20)
                    }
                }.position(x: geometry.size.width/2.073, y:geometry.size.height/1.9)

            }
        }
    }
}

struct RoleCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoleCardComponent()
            .environmentObject(RealTimeGame())
    }
}
