//
//  FeedPepper.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 23/06/23.
//

import SwiftUI

struct FeedPepper: View {
    @EnvironmentObject var game: RealTimeGame
    @Binding var isShowFeed: Bool
    @State private var confirmationNavi = false
    @State private var confirmationArchie = false
    @State private var isImageTapped = false
    @Binding var isFoodReady: Bool
    
    var body: some View {
            ZStack {
                Image("SelectPlayer")
                    .resizable()
                    .scaleEffect(0.7)
                    .offset(y: -20)
                
                HStack{
                    Image("NaviFeed")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.4)
                        .offset(x: 70)
                        .onTapGesture {
                            if !isImageTapped {
                                print("Navi bosq")
                                confirmationNavi = true
                                isImageTapped = true
                                game.sendEnergy(energyAmount: 36, who: "navigator")
                                isFoodReady.toggle()
                            }
                        }.opacity(isImageTapped ? 0.5 : 1.0)
                        .disabled(isImageTapped)
                    
                    Image("ArchieFeed")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.4)
                        .offset(x: -70)
                        .onTapGesture {
                            if !isImageTapped {
                                print("Archie bosq")
                                confirmationArchie = true
                                isImageTapped = true
                                game.sendEnergy(energyAmount: 36, who: "supply")
                                isFoodReady.toggle()

                            }
                        }.opacity(isImageTapped ? 0.5 : 1.0)
                        .disabled(isImageTapped)
                }.offset(y: -2)
                
                Image("CloseButton")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.1)
                    .onTapGesture {
                        isShowFeed = false
                    }
                    .offset(x: 200, y: -80)
            
                if confirmationNavi {
                    Image("NaviConfirmation")
                        .offset(y: 130)
                } else if confirmationArchie {
                    Image("ArchieConfirmation")
                        .offset(y: 130)
                }
                
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
            .background(BlurView(style: .systemUltraThinMaterialDark))
    }
}

struct FeedPepper_Previews: PreviewProvider {
    static var previews: some View {
        FeedPepper(isShowFeed: .constant(true), isFoodReady: .constant(false)) //error in this code
    }
}
