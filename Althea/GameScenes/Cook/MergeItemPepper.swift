//
//  MergeItemPepper.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 23/06/23.
//

import SwiftUI

struct MergeItemPepper: View {
    @Binding var itemsCollected: [String: Int]
    @State private var selectedItems: [String] = []
    @State private var resultItem: String = ""
    @State private var showAlert = false
    
    @State private var showHint = false
    
    @State private var isShowFood = false
    
    @Binding var isFoodReady: Bool
    @State var isFoodGiven = false
    
    //buat close button
    @Binding var isMerge: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 50) {
                ZStack {
                    Image("select-items-banner")
                        .resizable()
                        .frame(width: 200, height: 105)
                        .offset(y: -70)
                    Image("select-items-container")
                        .resizable()
                        .frame(width: 300, height: 134)
                    
                    Button(action: {
                        isMerge = false
                    }) {
                        Image("closeButton")
                            .resizable()
                            .frame(width:30, height: 30)
                            .scaledToFit()
                    }
                    .position(x: 557, y: 47)
                    
                    Button(action: { // ---------------------------------- @James @Tiff -------------------------------
                        showHint = true
                    }) {
                        Image("infoAja")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .position(x: 485, y: 20)
                    
                    HStack(spacing: 110) {
                        ForEach(selectedItems, id: \.self) { key in
                            Image(key)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                    }
                        Image("cook")
                            .resizable()
                            .frame(width: 108, height: 61)
                            .offset(y: 70)
                            .onTapGesture {
                                mergeItems()
                                // isShowFood = true
                            }
                    if showHint {
                        HintPepper(isShowingHint: $showHint)
                    }
                    if showHint {
                        HintPepper(isShowingHint: $showHint)
                    }
                }
                InventoryViewPepper(itemsCollected: $itemsCollected, selectedItems: $selectedItems)
            }
            .padding(.top, 40)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(BlurView(style: .systemUltraThinMaterialDark))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text("You cannot make this recipe. Let's try another one!"),
                    dismissButton: .default(Text("Okay"))
                )
            }
            if isShowFood {
               FoodView(resultItem: resultItem)
            }
        }.onChange(of: isShowFood) { newValue in
            isFoodReady.toggle()
        }
        
    }
    
    func mergeItems() {
        guard selectedItems.count == 2 else {
            showAlert = true
            return
        }
        let item1 = selectedItems[0]
        let item2 = selectedItems[1]
        
        if (item1 == "Apple" && item2 == "Pineapple") || (item1 == "Pineapple" && item2 == "Apple") {
            resultItem = "juice"
            isShowFood = true
            itemsCollected["Apple"]! -= 1
            itemsCollected["Pineapple"]! -= 1

        } else if (item1 == "Apple" && item2 == "Wheat") || (item1 == "Wheat" && item2 == "Apple") {
            resultItem = "applepie"
            isShowFood = true
            
            itemsCollected["Apple"]! -= 1
            itemsCollected["Wheat"]! -= 1

        } else {
            showAlert = true
            return
        }
        print("yayyy")
    }
}
