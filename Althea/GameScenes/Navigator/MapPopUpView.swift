//
//  MapPopUpView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 22/06/23.
//

import SwiftUI
import SpriteKit

struct MapPopUpView: View {
    @Binding var isShowingMap: Bool
    @State private var isMapClickable = true

    var body: some View {
        ZStack {
            VStack {
                CountdownView(isShowingMap: $isShowingMap, isMapClickable: $isMapClickable)
                ZStack {
                    Image("instructionBg")
                    Image("ViewMapNavi").resizable()
                        .scaleEffect(0.9)
                }
            }
            .disabled(!isMapClickable)
            .onTapGesture {
                // "Please wait for n seconds.."
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height +
         20)
        .background(BlurView(style: .systemUltraThinMaterialDark))
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

//struct MapPopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        NaviView().environmentObject(RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
//    }
//}
