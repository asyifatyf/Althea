//
//  InventoryView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 26/06/23.
//

import SwiftUI

struct InventoryViewPepper: View {
    @Binding var itemsCollected: [String: Int]
    @Binding var selectedItems: [String]
    
    var body: some View {
        HStack {
            ForEach(itemsCollected.keys.sorted(), id: \.self) { key in
                ZStack {
                    Image("INVENT") // inventory tile
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                    
                    if let itemCount = itemsCollected[key] {
                        Image(key) // item image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                toggleSelection(key)
                            }
                        Text("\(itemCount)") // item count
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .offset(x: 30, y: 30)
                        Button(action: {
                            selectItem(key)
                        }) {
                            Color.clear
                        }
                        .frame(width: 100, height: 100)
                        .contentShape(Rectangle())
                    }
                }
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 20)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UpdateInventory"))) { notification in
            if let updatedItemsCollected = notification.object as? [String: Int] {
                itemsCollected = updatedItemsCollected
                print(itemsCollected)
            }
        }
    }
    
    func toggleSelection(_ key: String) {
            if selectedItems.contains(key) {
                selectedItems.removeAll { $0 == key }
            } else {
                selectedItems.append(key)
            }
        }
    
    func selectItem(_ key: String) {
        if selectedItems.count < 2 {
            selectedItems.append(key)
        } else {
            return
        }
    }
    
}

//struct InventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryView()
//    }
//}
