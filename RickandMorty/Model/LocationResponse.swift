//
//  LocationUrlResponse.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 27.03.2023.
//
import Foundation
struct LocationResponse: Codable {
    let results: [Results]?
}
struct Results: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String?
}
