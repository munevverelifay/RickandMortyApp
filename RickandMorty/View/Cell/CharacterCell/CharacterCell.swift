//
//  CharacterCell.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 24.03.2023.
//
import UIKit
class CharacterCell: UICollectionViewCell {
    @IBOutlet weak var characterBackgroundView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var femaleGenderView: UIView!
    @IBOutlet weak var femaleGenderIconImage: UIImageView!
    @IBOutlet weak var maleGenderView: UIView!
    @IBOutlet weak var maleGenderIconImage: UIImageView!
    @IBOutlet weak var unknownGenderView: UIView!
    @IBOutlet weak var unknownGenderIconImage: UIImageView!
    @IBOutlet weak var charactersNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImage.layer.cornerRadius = 10
        characterImage.layer.masksToBounds = true
        characterBackgroundView.layer.cornerRadius = 22
        genderView(genderView: femaleGenderView)
        genderView(genderView: maleGenderView)
        genderView(genderView: unknownGenderView)
        applyShadowOnView(femaleGenderView)
        applyShadowOnView(maleGenderView)
        applyShadowOnView(unknownGenderView)
        applyShadowOnView(characterBackgroundView)
    }
    func applyShadowOnView(_ view: UIView) {
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor =   UIColor(red: 90/255, green: 108/255, blue: 234/255, alpha: 1).cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
    }
    func genderView(genderView: UIView) {
        genderView.layer.cornerRadius = genderView.frame.height / 2
        genderView.layer.masksToBounds = true
    }
}
