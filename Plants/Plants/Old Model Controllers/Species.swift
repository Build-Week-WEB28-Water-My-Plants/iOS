//
//  Species.swift
//  Plants
//
//  Created by Alexander Supe on 04.02.20.
//

import Foundation

struct Species: Codable {
    var id: Int?
    var h2oFrequency: Double?
    var imageUrl: String?
    var commonName: String?
    var scientificName: String?
    var imageBinary: Data?
}
