//
//  InstructionPopUpView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 22/06/23.
//

import SwiftUI

struct InstructionPopUpView: View {
    var body: some View {
        ZStack {
            Image("instructionBg")
            Image("instructionsDetail").padding(.top, 20)
        }
    }
}


struct InstructionPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionPopUpView()
    }
}
