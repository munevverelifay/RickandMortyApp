//
//  LocationCell.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 23.03.2023.
//
import UIKit
class LocationCell: UICollectionViewCell {
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        locationView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        locationView.layer.cornerRadius = locationView.frame.height / 2
        locationView.layer.masksToBounds = true
        locationView.backgroundColor = UIColor(red: 83/255, green: 232/255, blue: 139/255, alpha: 0.1)
        locationView.layer.borderColor = UIColor(red: 83/255, green: 232/255, blue: 139/255, alpha: 1.0).cgColor
        locationView.layer.borderWidth = 0.2
    }
}
