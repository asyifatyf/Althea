//
//  HintPepper.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 30/06/23.
//
// ---------------------------------- @James @Tiff -------------------------------

import SwiftUI

struct HintPepper: View {
    
    @Binding var isShowingHint: Bool
    
    var body: some View {
        ZStack{
            ZStack {
                Image("HintPepper")
                
                Button(action: {
                    isShowingHint = false
                }) {
                    Image("closeButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width:30, height:30)
                }
                .position(x: 515, y: 215)
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)
            .background(BlurView(style: .systemUltraThinMaterialDark))
        
        
    }
}

//struct HintPepper_Previews: PreviewProvider {
//    static var previews: some View {
//        HintPepper()
//    }
//}
