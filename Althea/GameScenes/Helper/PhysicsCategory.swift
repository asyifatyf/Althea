//
//  PhysicsCategory.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 22/06/23.
//

import Foundation

struct PhysicsCategory {
    // Main componente
    static let None: UInt32 = 0
    static let Player: UInt32 = 0x1
    static let Playerss: UInt32 = 0x2
    static let CornerArea: UInt32 = 0x3
    static let MiddleArea: UInt32 = 0x4
    
    // Loots / Items
    
    static let Apple: UInt32 = 0x5
    static let Wheat: UInt32 = 0x6
    static let Pineapple: UInt32 = 0x7
    
    static let Wood: UInt32 = 0x8
    static let Magnet: UInt32 = 0x9
    static let Rock: UInt32 = 0x10
    
    static let Shovel: UInt32 = 0x8
    static let Bomb: UInt32 = 0x9
    
    static let TreasureBigArea: UInt32 = 0x12 
    static let TreasureLocation: UInt32 = 0x13
    
}
