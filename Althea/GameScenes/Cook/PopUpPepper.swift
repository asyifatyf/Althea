//
//  PopUpPepper.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 23/06/23.
//

import SwiftUI

struct PopUpPepper: View {
    @Binding var isShowingPopup: Bool
    
    var body: some View {
        ZStack{
            ZStack {
                Image("InfoPepper")
                Button(action: {
                    isShowingPopup = false
                }) {
                    Image("closeButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width:45, height:45)
                }
                .position(x: 600, y: 120)
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(BlurView(style: .systemUltraThinMaterialDark))
    }
}

struct PopUpPepper_Previews: PreviewProvider {
    static var previews: some View {
        PepperView()
    }
}
