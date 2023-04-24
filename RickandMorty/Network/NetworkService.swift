//
//  NetworkService.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 27.03.2023.
//
import Foundation
import Alamofire
//MARK: - Network Service
private let baseURL = "https://rickandmortyapi.com/api"
class NetworkService {
    static let sharedNetwork = NetworkService()
    var charactersURL: String?
    var locationsURL: String?
    var episodesURL: String?
    //MARK: - Functions
    //MARK: - ApiURL
    func getApiUrl(completion: @escaping (Result<ApiUrlResponse, AFError>) -> Void) {
        let NetworkURL = "\(baseURL)"
        AF.request(NetworkURL, method: .get).responseDecodable(of: ApiUrlResponse.self) {
            response in completion(response.result)
        }
    }
    //MARK: - LocationsApiInfo
    func getLocationsData(completion: @escaping (Result<LocationResponse, AFError>) -> Void) { //location api urlden bilgileri alıyoruz
        if let NetworkURL = locationsURL {
            AF.request(NetworkURL, method: .get).responseDecodable(of: LocationResponse.self) {
                locationResponse in completion(locationResponse.result)
            }
        }
    }
    //MARK: - LocationsResidentApiInfo
    func getResidenetsData(residentsURL: String? ,completion: @escaping (Result<ResidentsResponse, AFError>) -> Void) { //residents api urlden bilgileri alıyoruz
        if let NetworkURL = residentsURL {
            AF.request(NetworkURL, method: .get).responseDecodable(of: ResidentsResponse.self) {
                residentsResponse in completion(residentsResponse.result)
            }
        }
    }
    //MARK: - CharacterApiInfo
    func getCharactersData(characterId: Int? ,completion: @escaping (Result<ResidentsResponse, AFError>) -> Void) { //residents api urlden bilgileri alıyoruz
        if let id = characterId {
            if let NetworkURL = charactersURL {
                let url = "\(NetworkURL)/\(id)"
                AF.request(url, method: .get).responseDecodable(of: ResidentsResponse.self) {
                    characterIdResponse in completion(characterIdResponse.result)
                }
            }
        }
    }
    //MARK: - EpisodesApiInfo
    func getEpisodesData(episodesURL: String?, completion: @escaping (Result<EpisodesResponse, AFError>) -> Void) {
        if let networkURL = episodesURL {
            AF.request(networkURL, method: .get).responseDecodable(of: EpisodesResponse.self) {
                episodeResponse in completion(episodeResponse.result)
            }
        }
    }
}
