//
//  CharacterUrlResponse.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 28.03.2023.
//
//
import Foundation
struct ResidentsResponse: Codable {
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let gender: String?
    let origin: CharLocation
    let location: CharLocation
    let episode: [String?]
    let image: String?
    let url: String?
    let created: String?
    var imageData: Data?
}
struct CharLocation: Codable {
    let name: String
    let url: String
}
