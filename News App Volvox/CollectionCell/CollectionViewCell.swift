//
//  CollectionViewCell.swift
//  News App Volvox
//
//  Created by Güney Köse on 17.03.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    let device = UIDevice.current.model
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.borderColor = UIColor.black.cgColor
        newsImage.layer.cornerRadius = 20
        newsImage.clipsToBounds = true
        
        if device == "iPhone" {
            return
        } else if device == "iPad" {
            imageHeight.constant = 150
        }
    }
    
}
