//
//  NaviView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 24/06/23.
//

import SwiftUI
import SpriteKit
import AVFoundation

var backgroundMusic = AVAudioPlayer()


struct NaviView: View {
    @EnvironmentObject var game: RealTimeGame
    @State private var showMap = false
    @State private var isMapClickable = true
    
    @State private var lastOpenTime: Date?
    @State private var disableTimer: Timer?
    
    
    let gameScene = NaviScene(fileNamed: "NaviScene")
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    @State var healthLevel: CGFloat = 200
    @State var healthBarOffset: CGFloat = 15
    let widthIncrease: CGFloat = 20
    @State var showCongratsView = false
    
    

    
    var conditionA = false // if energyReceived
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene!)
                .frame(width: screenWidth, height: screenHeight + 20)
                .previewInterfaceOrientation(.landscapeLeft)
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            HStack(spacing: -220){
                ZStack (alignment: .leading) {
                    Image("health-container")
                        .resizable().frame(width: 220, height: 30)
                    Image("health-level")
                        .resizable()
                        .frame(width: conditionA ? healthLevel + widthIncrease : healthLevel, height: 20)
                        .offset(x: healthBarOffset)
                    Image("health-icon-thunder")
                        .resizable().frame(width: 34, height: 40).offset(x: -7)
                }.padding(.leading, 20).offset(y: -screenHeight/3)
                VStack {
                    Button(action: {
                        if isMapClickable {
                            showMap = true
                        }
                    }) {
                        Image("instructionButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    .position(x: 790, y: 70)
                    if showMap {
                        MapPopUpView(isShowingMap: $showMap)
                            .disabled(!isMapClickable)
                    }
                    if showCongratsView{
                        CongratulationsView()
                    }
                    Button(action: {
                        if isMapClickable {
                            showMap = true
                            lastOpenTime = Date()
                            disableTimer?.invalidate()
                            isMapClickable = false
                            if !isMapClickable {
                                disableTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { _ in
                                    isMapClickable = true
                                }
                            }
                        }
                    }) {
                        Image(isMapClickable ? "map" : "map-inactive")
                            .resizable()
                            .frame(width: 94, height: 94)
                    }.position(x: screenWidth / 1.13, y: screenHeight / 3.5)
                        .disabled(!isMapClickable)
                }
            }.padding(.trailing,20)
        }.onAppear {
            let filePath = Bundle.main.path(forResource: "ambiance", ofType: "wav")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            
            do { backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
            catch { return print("Cannot Find The Audio")}
            
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.volume = 0.5
            backgroundMusic.play()
            
//            while game.objectType == "Bomb" {
//                self.conditionA = true
//            }
//            while conditionA{
//                print("mbledos")
//                game.sendObjectType(objectType: "None")
//            }
            
        }
        .onChange(of: game.objectType, perform: { type in
            if game.objectType == "Bomb"{
                print("mbledos")
                self.healthLevel -= 100
                game.objectType = "None"
            } else if game.objectType == "treasure"{
                showCongratsView = true
            }
            
        })
        .onChange(of: game.navigatorEnergy, perform: { energy in
            if game.navigatorEnergy == 36{
                self.healthLevel += 40
                game.navigatorEnergy = 0
            }

        })
        .navigationBarBackButtonHidden(true)
    }
}



//struct NaviView_Previews: PreviewProvider {
//    static var previews: some View {
//        NaviView().environmentObject(RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
//    }
//}
