//
//  NoCommentCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/29/23.
//

import UIKit

class NoCommentCLVCell: UICollectionViewCell {
    @IBOutlet weak var imageViewPoster:UIImageView!
    @IBOutlet weak var imageShowAll:UIImageView!
    @IBOutlet weak var GotoButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.GotoButton.setTitle("", for: .normal)

    }

}
