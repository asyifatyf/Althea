//
//  ToolsView.swift
//  Althea
//
//  Created by James Jeremia on 01/07/23.
//

import SwiftUI

struct ToolsView: View {
    let resultItem: String
    @State private var isShowFoodView = true
    var body: some View {
        if isShowFoodView {
            ZStack {
                VStack {
                    Text("Congratulations! You just made a tool").font(.custom("PixelGameFont", size: 40)).foregroundColor(.white).multilineTextAlignment(.center).frame(width: UIScreen.main.bounds.width - 100)
                    Image(resultItem)
                    Image("done").scaleEffect(0.5).onTapGesture {
                        isShowFoodView = false
                    }
                    
                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(BlurView(style: .systemUltraThinMaterialDark))
                .padding(.top, 20)
        }
    }
}
