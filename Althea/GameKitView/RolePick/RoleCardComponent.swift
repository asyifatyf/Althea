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
                        Image("naviCard")
                            .scaleEffect(0.85)
                            .onTapGesture {
                                if !game.isNavigatorReady{
                                    game.roleNavigator()
                                }
                                
                            }.disabled(game.isNavigatorReady)

                        Text("\(game.navigatorName)")
                            .foregroundColor(.black)
                            .offset(x: 4, y: -38)
                    }
                    VStack{
                        Image("archieCard")
                            .scaleEffect(0.85)
                            .offset(x: -6, y: -10)
                            .onTapGesture {
                                if !game.isSupplyReady{
                                    game.roleSupply()
                                }
                            }.disabled(game.isSupplyReady)

                        Text("\(game.supplyName)")
                            .foregroundColor(.black)
                            .offset(x: -5,y: -48)
                        
                    }
                    VStack{
                        Image("pepperCard")
                            .scaleEffect(0.85)
                            .offset(y: 3.4)
                            .onTapGesture {
                                if !game.isCookReady{
                                    game.roleCook()
                                    print(game.myScore)
                                }
                            }.disabled(game.isCookReady)

                        Text("\(game.cookName)")
                            .foregroundColor(.black)
                            .offset(y: -34)
                    }
                }.position(x: geometry.size.width/2.015, y:geometry.size.height/2)

            }
        }
    }
}

struct RoleCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoleCardComponent()
            .environmentObject(RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
    }
}
