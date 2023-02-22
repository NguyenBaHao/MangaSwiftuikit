//
//  Home1CollectionViewCell.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 07/02/2023.
//

import UIKit

class Home1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageManga: UIImageView!
    @IBOutlet weak var labName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        imageManga.layer.cornerRadius = 15
        imageManga.layer.masksToBounds = true
        // Initialization code
    }

}
