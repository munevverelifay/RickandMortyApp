//
//  EpisodesResponse.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 31.03.2023.
//
import Foundation
struct EpisodesResponse: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
