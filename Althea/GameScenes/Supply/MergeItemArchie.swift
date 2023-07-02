//
//  MergeItemArchie.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 24/06/23.
//

import SwiftUI

struct MergeItemArchie: View {
    @Binding var itemsCollected: [String: Int]
    @State private var selectedItems: [String] = []
    @State private var resultItem: String = ""
    @State private var showAlert = false
    
    //buat close button
    @Binding var isMerge: Bool
    @Binding var isMetalDetector: Bool
    @Binding var isShovel: Bool
    @Binding var isEmpty: Bool
    
    @State private var isShowFood = false
    
    @State private var seeHint = false
    
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
                        seeHint = true
                    }) {
                        Image("infoAja")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .position(x: 485, y: 20)
                    
                    HStack(spacing: 110) {
                        ForEach(selectedItems, id: \.self) { key in
//                            if itemsCollected[key] != 0 {
                                Image(key)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
//                            }
                        }
                    }
                    
                    Image("make")
                        .resizable()
                        .frame(width: 108, height: 61)
                        .offset(y: 70)
                        .onTapGesture {
                            mergeItems()
                            isShowFood = true
                        }
//                        .disabled(isEmpty)
                    if seeHint {
                        HintArchie(isShowHint: $seeHint)
                    }
                }
                InventoryViewArchie(itemsCollected: $itemsCollected, selectedItems: $selectedItems, isEmpty: $isEmpty)
            }
            .padding(.top, 40)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(BlurView(style: .systemUltraThinMaterialDark))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text("You cannot make this tool. Let's try another one!"),
                    dismissButton: .default(Text("Okay"))
                )
            }
            if isShowFood {
                ToolsView(resultItem: resultItem)
            }
        }
    }
    
    func mergeItems() {
        guard selectedItems.count == 2 else {
            showAlert = true
            return
        }
        let item1 = selectedItems[0]
        let item2 = selectedItems[1]
        
        if (item1 == "Magnet" && item2 == "Rock") || (item1 == "Rock" && item2 == "Magnet") {
//            if itemsCollected["Magnet"]! != 0 && itemsCollected["Rock"]! != 0{
                isEmpty = false
                isMetalDetector = true
                itemsCollected["Magnet"]! -= 1
                itemsCollected["Rock"]! -= 1
//            } else if itemsCollected["Magnet"]! == 0 && itemsCollected["Rock"]! == 0{
//                isEmpty = true
//            }
        } else if (item1 == "Wood" && item2 == "Rock") || (item1 == "Rock" && item2 == "Wood") {
            isShovel = true
            itemsCollected["Wood"]! -= 1
            itemsCollected["Rock"]! -= 1
        } else {
            showAlert = true
            return
        }
        print("yayyy")
    }
}

//struct MergeItemArchie_Previews: PreviewProvider {
//    static var previews: some View {
//        MergeItemArchie(isSMerge: .constant(true))
//    }
//}
