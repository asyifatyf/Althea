//
//  CountdownTimer.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 22/06/23.
//

import SwiftUI

struct CountdownView: View {
    @Binding var isShowingMap: Bool
    @Binding var isMapClickable: Bool
    @State private var timeRemaining = 3.0
    @State private var isCountdownActive = true

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalTime: Double = 3.0
    
    var body: some View {
        VStack {
            Text("\(Int(timeRemaining))")
                .font(.largeTitle)
                .padding()
                .foregroundColor(Color("textHighlight"))
        }
        .onReceive(timer) { _ in
            if timeRemaining > 1 {
                timeRemaining -= 1
            } else {
                timeRemaining = 0
                isShowingMap = false
                isCountdownActive = false
                isMapClickable = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    isCountdownActive = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isMapClickable = true
                    }
                }
            }
        }
        .onAppear {
            if !isCountdownActive {
                isMapClickable = false
            }
        }
    }
}



