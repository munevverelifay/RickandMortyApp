//
//  CharacterResponse.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 31.03.2023.
//
import Foundation
struct CharacterResponse: Codable {
    var results: [Character]?
}
struct Character: Codable {
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let gender: String?
    let origin: CharLoc
    let location: CharLoc
    let episode: [String?]
    let image: String?
    let url: String?
    var imageData: Data?
}
struct CharLoc: Codable {
    let name: String
    let url: String
}
