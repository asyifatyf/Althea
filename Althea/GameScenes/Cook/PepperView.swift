//
//  PepperView.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 23/06/23.
//


import SwiftUI
import SpriteKit
import AVFoundation


struct PepperView: View {
    @EnvironmentObject var game: RealTimeGame
    
    @State private var itemsCollected: [String: Int] = [:]
    
    @State private var showInstruction = false
    @State private var showMerge = false
    @State private var showFeed = false
    
    @State private var selectedItems: [String] = []
    
    
    let gameScene = PepperScene(fileNamed: "PepperScene")
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    @State var showCongratsView = false

    @State var healthLevel: CGFloat = 200
    @State var healthBarOffset: CGFloat = 15
    let widthIncrease: CGFloat = 20
    @State var isFoodReady: Bool = false

    var conditionA = true // if energyReceived
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene!)
                .frame(width: screenWidth,height: screenHeight + 20)
                .previewInterfaceOrientation(.landscapeLeft)
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            HStack(spacing: -220) {
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
                        showInstruction = true
                    }) {
                        Image("instructionButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    .position(x: 790, y: 70)
                    if showInstruction {
                        PopUpPepper(isShowingPopup: $showInstruction)
                    }
                    
                    HStack() {
                        HStack(spacing: 15) {
                            InventoryViewPepper(itemsCollected: $itemsCollected, selectedItems: $selectedItems)
                        }.position(x: screenWidth / 2, y: screenHeight / 3)
                        
                        
                        Button(action: {
                            showFeed = true
                        }) {
                            Image(isFoodReady ? "feed-green" : "feed-red")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 61, height: 61)
                        }
                        .disabled(!isFoodReady)
                        .position(x: 380, y: 130)
                        if showFeed {
                            FeedPepper(isShowFeed: $showFeed, isFoodReady: $isFoodReady)
                        }
                        if showCongratsView{
                            CongratulationsView()
                        }
                        Button(action: {
                            showMerge = true
                        }) {
                            Image(isFoodReady ? "cooking-inactive" : "cooking-active")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 87, height: 87)
                        }
                        .disabled(isFoodReady)
                        .position(x: 200, y: 125)
                        if showMerge {
                            MergeItemPepper(itemsCollected: $itemsCollected, isFoodReady: $isFoodReady, isMerge: $showMerge)
                        }
                        
                    }
                }.padding(.trailing,20)
            }
        }.onAppear {
            let filePath = Bundle.main.path(forResource: "ambiance", ofType: "wav")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            
            do { backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
            catch { return print("Cannot Find The Audio")}
            
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.volume = 0.5
            backgroundMusic.play()
            

            
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
        .navigationBarBackButtonHidden(true)
    }
}


//struct PepperView_Previews: PreviewProvider {
//    static var previews: some View {
//        PepperView().environmentObject(RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
//    }
//}
