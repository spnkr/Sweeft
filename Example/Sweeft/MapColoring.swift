//
//  MapColoring.swift
//  Sweeft
//
//  Created by Mathias Quintero on 2/8/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Sweeft

// Here's a small example on how to use the CSP Solver in Sweeft to solve map coloring

// First here comes our actual work. Creating the constraints and calling the framework.

protocol MapEntity: Hashable {
    associatedtype Coloring: CSPValue, Equatable
    var neighbours: [Self] { get }
}

extension MapEntity {
    
    static func color(entities: [Self]) -> [Self:Coloring]? {
        let constraints = entities.flatMap { entity in
            return entity.neighbours => { Constraint<Self, Coloring>.binary(entity, $0, constraint: (!=)) }
        }
        let csp = CSP<Self, Coloring>(constraints: constraints)
        return csp.solution()
    }
    
}

// Our Hardcoded Example. Coloring Australia with 3 colors

enum Color: String, CSPValue {
    static var all: [Color] = [.red, .green, .blue]
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
}

enum State: String {
    
    static var all: [State] {
        return [.westernAustralia, .northernTerritory, .southAustralia, .queensland, .newSouthWales, .victoria, .tasmania]
    }
    
    case westernAustralia = "Western Australia"
    case northernTerritory = "Northern Territory"
    case southAustralia = "South Australia"
    case queensland = "Queensland"
    case newSouthWales = "New South Wales"
    case victoria = "Victoria"
    case tasmania = "Tasmania"
}

extension State: MapEntity {
    
    typealias Coloring = Color
    
    var neighbours: [State] {
        switch self {
        case .westernAustralia:
            return [.northernTerritory, .southAustralia]
        case .northernTerritory:
            return [.westernAustralia, .southAustralia, .queensland]
        case .southAustralia:
            return [.westernAustralia, .northernTerritory, .queensland, .newSouthWales, .victoria]
        case .queensland:
            return [.northernTerritory, .southAustralia, .newSouthWales]
        case .newSouthWales:
            return [.queensland, .southAustralia, .victoria]
        case .victoria:
            return [.southAustralia, .newSouthWales]
        default:
            return .empty
        }
    }
    
}
