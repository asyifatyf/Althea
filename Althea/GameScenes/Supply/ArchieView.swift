//
//  ArchieView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 26/06/23.
//

import SwiftUI
import SpriteKit
import AVFoundation


struct ArchieView: View {
    @EnvironmentObject var game: RealTimeGame

    @State private var itemsCollected: [String: Int] = [:]
    @State private var seeInstruction = false
    @State var seeMerge = false
    
    @State private var isPlayerInTreasureLocation = false
    
    let gameScene = ArchieScene(fileNamed: "ArchieScene")
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    @State var healthLevel: CGFloat = 200
    @State var healthBarOffset: CGFloat = -2
    let widthIncrease: CGFloat = 20
    var conditionA = true // if energyReceived
    
    @State var showCongratsView = false
    @State var isMetalDetector = false
    @State var isShovel = false
    @State var isEmpty = false
    @State var isMetalDetectorActive = false
    @State private var isShovelActive = false
    var playerNode: SKNode?
    let scene: ArchieScene?

    
    @State private var selectedItems: [String] = []
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene!)
                .frame(width: screenWidth,height: screenHeight + 20)
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
                    seeInstruction = true
                }) {
                    Image("instructionButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .position(x: 790, y: 70)
                if seeInstruction {
                    PopUpArchie(isShowPopUp: $seeInstruction)
                }
                
                
                Button(action: {
                    isMetalDetectorActive = true
                    print(isMetalDetectorActive)
                    //MENYARI
                }) {
                    Image(isMetalDetector ? "metal-detector" : "metal-detector-red")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 61, height: 61)
                }
                .disabled(!isMetalDetector)
                .position(x: screenWidth / 1.16, y: screenHeight / 2.4)
                
                
                if showCongratsView && isPlayerInTreasureLocation && isMetalDetectorActive {
                    CongratulationsView()
                }
                Button(action: {
                    showCongratsView = true
                    isPlayerInTreasureLocation = true
                    isShovelActive.toggle()
                    if isShovelActive {
                        let positions: [CGPoint] = [
                            CGPoint(x: 3545.295, y: -1871),
                            CGPoint(x: 3932, y: -1758),
                            CGPoint(x: 3214, y: -120),
                            CGPoint(x: 3690, y: -162),
                            CGPoint(x: 1809, y: -1537),
                            CGPoint(x: 1333, y: -1495),
                            CGPoint(x: 770, y: -2034),
                        ]
                        
                        for position in positions {
                            let bombNode = SKSpriteNode(imageNamed: "bomb")
                            bombNode.position = position
                            scene?.bombNodes.append(bombNode)
                            scene?.addChild(bombNode)
                        }
                        print(positions)
                    } else {
                        for bombNode in scene?.bombNodes ?? [] {
                            bombNode.removeFromParent()
                        }
                        scene?.bombNodes.removeAll()
                    }
                }) {
                    Image(isShovel ? "shovel-green" : "shovel-red")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 61, height: 61)
                }
                .disabled(!isShovel)
                .position(x: screenWidth / 1.25, y: screenHeight / 2.7)
                if showCongratsView && isPlayerInTreasureLocation {
//                    CongratulationsView()
                }
                HStack {
                    InventoryViewArchie(itemsCollected: $itemsCollected, selectedItems: $selectedItems, isEmpty: $isEmpty)
                        .position(x:430, y:-10)
                        .opacity(showCongratsView ? 0 : 1)
                    
                    Button(action: {
                        seeMerge = true
                    }) {
                        Image("makebutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 87, height: 87)
                    }
                    .position(x: screenWidth / 2.4, y: screenHeight / 10.0)
                    if seeMerge {
                        MergeItemArchie(itemsCollected: $itemsCollected, isMerge: $seeMerge, isMetalDetector: $isMetalDetector, isShovel: $isShovel, isEmpty: $isEmpty)
                    }
                }
                
                
            }
        }.padding(.trailing,20)

        }.onAppear {
            let filePath = Bundle.main.path(forResource: "ambiance", ofType: "wav")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            
            do { backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
            catch { return print("Cannot Find The Audio")}
            
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.volume = 0.5
//            backgroundMusic.play()
            
//            while conditionA {
//                if game.objectType == "Bomb"{
//                    print("mbledos")
//                    game.sendObjectType(objectType: "None")
//                }
//            }
        }
        .onChange(of: game.objectType, perform: { type in
            if game.objectType == "Bomb"{
                print("mbledos")
                self.healthLevel -= 100
                game.objectType = "None"
                self.isShovel = false
                self.isMetalDetector = false
            }

        })
        .onChange(of: game.supplyEnergy, perform: { energy in
            if game.supplyEnergy == 36{
                self.healthLevel += 40
                game.supplyEnergy = 0
            }
        })
        .onChange(of: showCongratsView, perform: { newValue in
            if showCongratsView{
                game.sendObjectType(objectType: "treasure")
            }
        })
        .navigationBarBackButtonHidden(true)
    }
}

//struct ArchieView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArchieView(scene: ArchieScene()).environmentObject(RealTimeGame()).previewInterfaceOrientation(.landscapeLeft)
//    }
//}

