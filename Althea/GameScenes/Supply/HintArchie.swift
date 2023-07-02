//
//  HintArchie.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 30/06/23.
//

// ---------------------------------- @James @Tiff -------------------------------

import SwiftUI

import SwiftUI

struct HintArchie: View {
    
    @Binding var isShowHint: Bool
    
    var body: some View {
        //       ZStack{
        ZStack {
            Image("HintArchie")
            
            Button(action: {
                isShowHint = false
            }) {
                Image("closeButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width:30, height:30)
            }
            .position(x: 515, y: 215)
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)
            .background(BlurView(style: .systemUltraThinMaterialDark))
    }
    }

//}

//struct HintArchie_Previews: PreviewProvider {
//    static var previews: some View {
//        HintArchie()
//    }
//}
