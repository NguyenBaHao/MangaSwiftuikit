//
//  DescriptionCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/29/23.
//

import UIKit

class DescriptionCLVCell: UICollectionViewCell {
    var mangaDetail:MangaInfoModel = MangaInfoModel()
    @IBOutlet weak var TextViewDescript:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.TextViewDescript.backgroundColor = UIColor.clear
    }


}
