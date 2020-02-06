//
//  NewPlantRepresentation.swift
//  Plants
//
//  Created by Alexander Supe on 05.02.20.
//

import Foundation

struct NewPlantRepresentation: Codable {
    var nickname: String
    var location: String
    var wateredDate: Date
    var image: Data
    var id: String
    var h2oFrequency: Double
}
