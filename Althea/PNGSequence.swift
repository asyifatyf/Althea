//
//  PNGSequence.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 26/06/23.
//

import Foundation
import SwiftUI

struct NaviSequenceView: View {
    @State var Navi: String = ""
    
    var body: some View {
        VStack(alignment: .center){
            Image(Navi)
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .onAppear(perform: timerNavi)

            
        }
    }
    
    func timerNavi() {
        var index = 1
        _ = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) {
            (timer) in
            
            Navi = "navi\(index)"
            index += 1
            
            if (index > 3){
                index = 1
            }
        }
    }
}


struct PNGSequence_Previews: PreviewProvider {
    static var previews: some View {
        NaviSequenceView()
    }
}
