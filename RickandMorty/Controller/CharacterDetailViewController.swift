//
//  CharacterDetailViewController.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 27.03.2023.
//
import UIKit
import Kingfisher
class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var characterScrollView: UIScrollView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDetailView: UIView!
    @IBOutlet weak var characterStatusLabel: UILabel!
    @IBOutlet weak var characterSpecyLabel: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    @IBOutlet weak var characterOriginLabel: UILabel!
    @IBOutlet weak var characterLocationLabel: UILabel!
    @IBOutlet weak var characterEpisodesLabel: UILabel!
    @IBOutlet weak var characterCreatedLabel: UILabel!
    var characterResponse: ResidentsResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        characterImage.layer.cornerRadius = 50
        characterImage.layer.borderWidth = 5
        characterImage.layer.borderColor = UIColor.white.cgColor
        characterDetailView.layer.cornerRadius = 22
        if let url = URL(string: (characterResponse?.image!)!){
            let imageUrl = url
            characterImage.kf.setImage(with: imageUrl)
        }
        // Avenir yazı tipini ve 22 punto boyutunu ayarla
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!]
        // Navigation bar title'ına yeni stil özelliklerini uygula
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        // Title'ı ayarla
        title = characterResponse?.name
        characterScrollView.showsVerticalScrollIndicator = false
        characterStatusLabel.text = characterResponse?.status
        characterSpecyLabel.text = characterResponse?.species
        characterGenderLabel.text = characterResponse?.gender
        characterOriginLabel.text = characterResponse?.origin.name
        characterLocationLabel.text = characterResponse?.location.name
        //MARK: - setCreatedAt
        let dateString = characterResponse?.created ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            // Tarih biçimlendirici oluştur
            let formattedDateFormatter = DateFormatter()
            formattedDateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
            formattedDateFormatter.locale = Locale(identifier: "en_US_POSIX")//İngilizceye çevir
            // Tarih metnini biçimlendir
            let formattedDate = formattedDateFormatter.string(from: date)
            characterCreatedLabel.text = formattedDate
        } else {
            print("Invalid date format")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let episodes = GlobalDataManager.sharedGlobalManager.episodesCharId?.map { String($0) }
        characterEpisodesLabel.text = episodes?.joined(separator: ", ")
    }
}
