//
//  SupplyView.swift
//  Althea
//
//  Created by James Jeremia on 22/06/23.
//

import SpriteKit
import GameplayKit
import SwiftUI

struct SupplyView: View {

    let gameView = SupplyScene(fileNamed: "SupplyScene")
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var game: RealTimeGame


    var body: some View {
        ZStack {
            SpriteView(scene: gameView!)
                .frame(width: 852,height: 415)
                .previewInterfaceOrientation(.landscapeLeft)
            .edgesIgnoringSafeArea(.all)
            .environmentObject(game)

        }.navigationBarBackButtonHidden(true)
    }
}

struct SupplyView_Previews: PreviewProvider {
    static var previews: some View {
        SupplyView()
    }
}

