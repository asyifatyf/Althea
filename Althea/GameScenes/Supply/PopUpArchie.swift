//
//  PopUpArchie.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 24/06/23.
//

import SwiftUI

struct PopUpArchie: View {
    @Binding var isShowPopUp: Bool
    
    var body: some View {
        
        ZStack{
            ZStack {
                Image("InfoArchie")
                
                Button(action: {
                    isShowPopUp = false
                }) {
                    Image("closeButton")
                        .resizable()
                        .frame(width:50, height: 50)
                        .scaledToFit()
                }
                .position(x: 625, y: 130)
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 40)
            .background(BlurView(style: .systemUltraThinMaterialDark))
    }
}

//struct PopUpArchie_Previews: PreviewProvider {
//    static var previews: some View {
//        PopUpArchie(isShowPopUp: $seeInstruction)
//    }
//}
