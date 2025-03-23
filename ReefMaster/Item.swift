//
//  Item.swift
//  ReefMaster
//
//  Created by Alonso Huerta on 22/03/25.
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
