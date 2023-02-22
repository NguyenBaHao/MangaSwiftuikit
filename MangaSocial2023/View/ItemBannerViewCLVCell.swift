//
//  ItemBannerViewCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/26/23.
//

import UIKit
import FSPagerView

class ItemBannerViewCLVCell: FSPagerViewCell {
    @IBOutlet weak var labelName:UITextView!
    @IBOutlet weak var imagePoster:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.isEditable = false
        labelName.backgroundColor = UIColor.white
        labelName.textColor = UIColor.green
        self.backgroundColor = UIColor.clear
        imagePoster.layer.cornerRadius = 15
        imagePoster.layer.masksToBounds = true
    }

}
