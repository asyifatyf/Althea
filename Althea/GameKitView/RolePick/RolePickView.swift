//
//  GameView.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI
import GameKit
import Combine

struct RolePickView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var game: RealTimeGame

    @State private var showMessages = false
    @State private var isChatting = false
            
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("RolePick")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .position(x: geometry.size.width/2, y:geometry.size.height/2)
                    
                    RoleCardComponent()
                        .position(x: geometry.size.width/2, y:geometry.size.height/2)
                    ReadyButtonComponent()
                        .position(x: geometry.size.width/2, y:geometry.size.height/1.03)
                    
                    if game.numbersPlayerReady == 3 {
                        let pageName: String = game.myRole
                        
                        switch pageName{
                        case "navigator":
                            NavigationLink(destination: NaviView(), isActive: $game.isActive, label: {EmptyView()})
                        case "supply":
                            NavigationLink(destination: ArchieView(scene: ArchieScene()), isActive: $game.isActive, label: {EmptyView()})
                        case "cook":
                            NavigationLink(destination: PepperView(), isActive: $game.isActive, label: {EmptyView()})
                            
                        default:
                            EmptyView()
                        }
                    }

                }
            }
            
        }

    }
}



struct RolePickViewPreviews: PreviewProvider {
    static var previews: some View {
        RolePickView().previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(RealTimeGame())
    }
}
