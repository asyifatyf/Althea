//
//  FoodView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 29/06/23.
//

import SwiftUI

struct FoodView: View {
    let resultItem: String
    @State private var isShowFoodView = true
    var body: some View {
        if isShowFoodView {
            ZStack {
                VStack {
                    Text("Congratulations! You just made a food for your friend!").font(.custom("PixelGameFont", size: 40)).foregroundColor(.white).multilineTextAlignment(.center).frame(width: UIScreen.main.bounds.width - 100)
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

//struct FoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodView()
//    }
//}
