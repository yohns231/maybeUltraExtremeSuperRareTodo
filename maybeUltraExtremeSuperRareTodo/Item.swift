//
//  Item.swift
//  maybeUltraExtremeSuperRareTodo
//
//  Created by 고요한 on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
