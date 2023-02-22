//
//  CategoriesItem1CLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/30/23.
//

import UIKit

class CategoriesItem1CLVCell: UICollectionViewCell {
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelAuthod:UILabel!
    @IBOutlet weak var labeUpdate: UILabel!
    @IBOutlet weak var imageCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageCover.layer.cornerRadius = 10.0
        self.imageCover.clipsToBounds = true
    }

}
