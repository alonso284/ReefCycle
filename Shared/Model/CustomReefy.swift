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
    
    var skin: Skin? {
        get { Skin(rawValue: skinRaw) }
        set { skinRaw = newValue?.rawValue ?? "" }
    }

    init(skin: Skin) {
        self.skinRaw = skin.rawValue
    }
}

@Model
class OwnedTool {
    var toolRaw: String = ""
    
    var tool: Tool? {
        get { Tool(rawValue: toolRaw) }
        set { toolRaw = newValue?.rawValue ?? "" }
    }

    init(tool: Tool) {
        self.toolRaw = tool.rawValue
    }
}

@Model
class OwnedHat {
    var hatRaw: String = ""
    
    var hat: Hat? {
        get { Hat(rawValue: hatRaw) }
        set { hatRaw = newValue?.rawValue ?? "" }
    }

    init(hat: Hat) {
        self.hatRaw = hat.rawValue
    }
}

enum Skin: String, CaseIterable, Encodable {
    case ReefyGreen
    case ReefyPurple
    case ReefyRed
    
    var price: Int {
        switch self {
        case .ReefyGreen:
            200
        case .ReefyPurple:
            300
        case .ReefyRed:
            400
        }
    }
}

enum Hat: String, CaseIterable, Encodable {
    case CookHat
    case EggHat
    case LeafeHat
    case MariachiHat
    case PartyHat
    
    var price: Int {
        switch self {
        case .CookHat:
            100
        case .EggHat:
            200
        case .LeafeHat:
            300
        case .MariachiHat:
            400
        case .PartyHat:
            500
        }
    }
}

enum Tool: String, CaseIterable, Encodable {
    case BottleTool
    case FishTool
    case ShovelTool
    
    var price: Int {
        switch self {
        
        case .BottleTool:
            100
        case .FishTool:
            200
        case .ShovelTool:
            300
        }
    }
}
