//
//  NavigatorView.swift
//  Althea
//
//  Created by James Jeremia on 22/06/23.
//

import SpriteKit
import GameplayKit
import SwiftUI

struct NavigatorView: View {
    let gameView = NavigatorScene(fileNamed: "NavigatorScene")
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width


    var body: some View {
        ZStack {
            SpriteView(scene: gameView!)
                .frame(width: 852,height: 415)
                .previewInterfaceOrientation(.landscapeLeft)
            .edgesIgnoringSafeArea(.all)
        }.navigationBarBackButtonHidden(true)
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
