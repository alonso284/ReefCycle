//
//  CustomReefy.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import SwiftData

@Model
class OwnedSkin {
    var skinRaw: String = ""
    
    var skin: Skin {
        get { Skin(rawValue: skinRaw) ?? .light }
        set { skinRaw = newValue.rawValue }
    }

    init(skin: Skin) {
        self.skinRaw = skin.rawValue
    }
}

@Model
class OwnedTool {
    var toolRaw: String = ""
    
    var tool: Tool {
        get { Tool(rawValue: toolRaw) ?? .shovel }
        set { toolRaw = newValue.rawValue }
    }

    init(tool: Tool) {
        self.toolRaw = tool.rawValue
    }
}

@Model
class OwnedHat {
    var hatRaw: String = ""
    
    var hat: Hat {
        get { Hat(rawValue: hatRaw) ?? .cap }
        set { hatRaw = newValue.rawValue }
    }

    init(hat: Hat) {
        self.hatRaw = hat.rawValue
    }
}

enum Skin: String, CaseIterable, Encodable {
    case light
    case dark
    
    var price: Int {
        switch self {
        case .light:
            return 100
        case .dark:
            return 200
        }
    }
}

enum Hat: String, CaseIterable, Encodable {
    case cap
    case bandana
    
    var price: Int {
        switch self {
        case .cap:
            return 100
        case .bandana:
            return 200
        }
    }
}

enum Tool: String, CaseIterable, Encodable {
    case shovel
    case hammer
    
    var price: Int {
        switch self {
        case .shovel:
            return 100
        case .hammer:
            return 200
        }
    }
}
