//
//  GobalDataManager.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 28.03.2023.
//
import Foundation
class GlobalDataManager {
    static let sharedGlobalManager = GlobalDataManager() //singletone
    var locationResults: [Results]? = [] 
    var residentsResults: ResidentsResponse?
    var residentsArrays: [ResidentsResponse] = []
    var characterResults: [Character]? = []
    var residentsURLs: [String]? = []
    var episodesCharId: [Int]? = [] //episodeiçin
    var characterId: [Int]?  = [] //Home'da seçilen lokasyona göre gözüken karakterlerin id listesi
    var selectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
}

