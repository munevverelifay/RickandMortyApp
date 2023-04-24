//
//  ViewController.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 23.03.2023.
//
import UIKit
import Kingfisher
class HomePageViewController: UIViewController {
    static let shared = HomePageViewController()
    @IBOutlet weak var appNameIconImage: UIImageView!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    var controlReloadData: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(UINib(nibName: String(describing: LocationCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LocationCell.self))
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        characterCollectionView.register(UINib(nibName: String(describing: CharacterCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CharacterCell.self))
        locationCollectionView.showsHorizontalScrollIndicator = false
        characterCollectionView.showsVerticalScrollIndicator = false
        self.configureApiUrl()
        self.setupSwipeRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func configureApiUrl() {
        NetworkService.sharedNetwork.getApiUrl { apiUrl in
            switch apiUrl {
            case .success(let apiResponse):
                NetworkService.sharedNetwork.charactersURL = apiResponse.characters
                NetworkService.sharedNetwork.locationsURL = apiResponse.locations
                NetworkService.sharedNetwork.episodesURL = apiResponse.episodes
                self.configureApiLocation { res in
                    self.updateUI(results: res)
                }
            case .failure(let apiError):
                print(apiError)
            }
        }
    }
    func configureApiLocation(completion: @escaping ([Results]) -> Void) {
        NetworkService.sharedNetwork.getLocationsData { locationApiUrl in
            switch locationApiUrl {
            case .success(let locationApiResponse):
                DispatchQueue.main.async {
                    guard let results = locationApiResponse.results else {
                        return
                    }
                completion(results)
                }
            case .failure(let apiError):
                print(apiError)
            }
        }
    }
    func configureApiResidents(residentsURL: String?, completion: @escaping (ResidentsResponse) -> Void) {
        NetworkService.sharedNetwork.getResidenetsData(residentsURL: residentsURL) { residentResults in
            switch residentResults {
            case .success(let residentResponse):
                DispatchQueue.main.async {
                    completion(residentResponse)
                }
            case .failure(let residentError):
                print(residentError)
            }
        }
    }
    func configureApiCharacter(characterId: Int?, completion: @escaping(ResidentsResponse) -> Void) {
        NetworkService.sharedNetwork.getCharactersData(characterId: characterId) { characterResults in
            switch characterResults {
            case .success(let characterResponse):
                DispatchQueue.main.async {
                    characterResponse.episode.forEach { episodeURL in
                        self.configureApiEpisode(episodesURL: episodeURL) { episodesResponse in
                            GlobalDataManager.sharedGlobalManager.episodesCharId?.append(episodesResponse.id)
                        }
                    }
                    completion(characterResponse)
                }
            case .failure(let characterError):
                print(characterError)
            }
        }
    }
    func configureApiEpisode(episodesURL: String?, completion: @escaping(EpisodesResponse) -> Void) {
        NetworkService.sharedNetwork.getEpisodesData(episodesURL: episodesURL) { episodeResults in
            switch episodeResults {
            case .success(let episodeResponse):
                DispatchQueue.main.async {
                    completion(episodeResponse)
                }
            case .failure(let episodeError):
                print(episodeError)
            }
        }
    }
    func updateUI(results: [Results]) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.locationResults = results
            self.locationCollectionView.reloadData()
        }
    }
    func updateResidentUI(results: ResidentsResponse) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.residentsResults = results
            GlobalDataManager.sharedGlobalManager.residentsArrays.append(results)
            GlobalDataManager.sharedGlobalManager.characterId?.append(results.id)
            self.characterCollectionView.reloadData()
        }
    }
    func selectDataCheck(indexPath: IndexPath, collectionView: UICollectionView) {
        GlobalDataManager.sharedGlobalManager.residentsURLs = GlobalDataManager.sharedGlobalManager.locationResults?[indexPath.item].residents
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.residentsURLs?.forEach({ url in
                self.configureApiResidents(residentsURL: url) { residentResponse in
                    self.updateResidentUI(results: residentResponse)
                }
            })
            GlobalDataManager.sharedGlobalManager.residentsArrays = []
            GlobalDataManager.sharedGlobalManager.characterId = [] //yeni locationa tıkladığımız da temizledik
            GlobalDataManager.sharedGlobalManager.selectedIndexPath = indexPath
            collectionView.reloadData()
        }
    }
    func setupSwipeRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
       if gesture.direction == .right {
            print("Swipe Right")
           if var indexPath = GlobalDataManager.sharedGlobalManager.selectedIndexPath {
               if indexPath.item > 0 {
                   indexPath.item = indexPath.item - 1
                   selectDataCheck(indexPath: indexPath, collectionView: characterCollectionView)
                   locationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

                   locationCollectionView.reloadData()
               }
           }
       } else if gesture.direction == .left {
            print("Swipe Left")
           if var indexPath = GlobalDataManager.sharedGlobalManager.selectedIndexPath {
               if indexPath.item < (GlobalDataManager.sharedGlobalManager.locationResults?.count ?? 0) - 1 {
                   indexPath.item = indexPath.item + 1
                   selectDataCheck(indexPath: indexPath, collectionView: characterCollectionView)
                   locationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                   locationCollectionView.reloadData()
               }
           }
       }
    }
}
extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == characterCollectionView {
            return GlobalDataManager.sharedGlobalManager.residentsArrays.count
        } else {
            return GlobalDataManager.sharedGlobalManager.locationResults?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == locationCollectionView {
            guard let locationCell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LocationCell.self), for: indexPath) as? LocationCell else {
                return UICollectionViewCell()
            }
            locationCell.locationNameLabel.text = GlobalDataManager.sharedGlobalManager.locationResults?[indexPath.item].name
            
            if let selectedIndexPath = GlobalDataManager.sharedGlobalManager.selectedIndexPath {
                if selectedIndexPath == indexPath {
                    locationCell.locationView.backgroundColor = UIColor(red: 83/255, green: 232/255, blue: 139/255, alpha: 1.0)
                    locationCell.locationNameLabel.textColor = UIColor.white
                }
                else {
                    locationCell.locationView.backgroundColor = UIColor(red: 83/255, green: 232/255, blue: 139/255, alpha: 0.1)
                    locationCell.locationNameLabel.textColor = UIColor(red: 21/255, green: 190/255, blue: 119/255, alpha: 1.0)
                    
                }
                if selectedIndexPath.item == 0, controlReloadData == false {
                    selectDataCheck(indexPath: selectedIndexPath, collectionView: characterCollectionView)
                    controlReloadData = true
                    
                }
            }
            return locationCell
        }
        if collectionView == characterCollectionView {
            guard let characterCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCell.self), for: indexPath) as? CharacterCell else {
                return UICollectionViewCell()
            }
            let globalResidentsArray = GlobalDataManager.sharedGlobalManager.residentsArrays
            characterCell.charactersNameLabel.text = globalResidentsArray[indexPath.item].name
            let url = URL(string: globalResidentsArray[indexPath.item].image!)
            characterCell.characterImage.kf.setImage(with: url)
            if globalResidentsArray[indexPath.item].gender == "Male" {
                characterCell.maleGenderIconImage.image = UIImage(named: "maleIcon")
                characterCell.maleGenderView.isHidden = false
                characterCell.femaleGenderView.isHidden = true
                characterCell.unknownGenderView.isHidden = true
            } else if globalResidentsArray[indexPath.item].gender == "Female" {
                characterCell.femaleGenderIconImage.image = UIImage(named: "femaleIcon")
                characterCell.maleGenderView.isHidden = true
                characterCell.femaleGenderView.isHidden = false
                characterCell.unknownGenderView.isHidden = true
            } else if globalResidentsArray[indexPath.item].gender == "Genderless" {
                characterCell.unknownGenderIconImage.image = UIImage(named: "genderlessIcon")
                characterCell.maleGenderView.isHidden = true
                characterCell.femaleGenderView.isHidden = true
                characterCell.unknownGenderView.isHidden = false
            }else {
                characterCell.unknownGenderIconImage.image = UIImage(named: "unknownIcon")
                characterCell.maleGenderView.isHidden = true
                characterCell.femaleGenderView.isHidden = true
                characterCell.unknownGenderView.isHidden = false
            }
            return characterCell
        } else{
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == characterCollectionView {
            configureApiCharacter(characterId: GlobalDataManager.sharedGlobalManager.characterId?[indexPath.item]) { characterResponse in
                if let characterDetailVC =  self.storyboard?.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController {
                    self.navigationController?.pushViewController(characterDetailVC, animated: true)
                    characterDetailVC.characterResponse = characterResponse
                }
            }
        } else {
            selectDataCheck(indexPath: indexPath, collectionView: collectionView)
            locationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == characterCollectionView {
            return 22
        } else {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == characterCollectionView {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        } else {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
    }
}
extension HomePageViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is CharacterDetailViewController {
            GlobalDataManager.sharedGlobalManager.episodesCharId = []
        }
    }
}
