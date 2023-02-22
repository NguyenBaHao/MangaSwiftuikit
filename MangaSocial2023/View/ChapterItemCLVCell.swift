//
//  ChapterItemCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/29/23.
//

import UIKit

class ChapterItemCLVCell: UICollectionViewCell {
    @IBOutlet weak var labelName:UITextView!
    @IBOutlet weak var buttonAction:UIButton!
    var indexSend = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.backgroundColor = UIColor.clear
        self.buttonAction.setTitle("", for: .normal)
        labelName.isEditable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        labelName.isUserInteractionEnabled = true
        labelName.addGestureRecognizer(tap)
    }
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            print("tap working")
            if let detail = self.parentViewController as? DetailMangaViewController{
                let viewControllerInXib = MangaReaderViewController(nibName: "MangaReaderViewController", bundle: nil)
                viewControllerInXib.mangaModel = detail.mangaDetail
                if detail.mangaDetail.chapterList.count > 0{
                    viewControllerInXib.currentChapter = detail.mangaDetail.chapterList[indexSend]
                }
                detail.present(viewControllerInXib, animated: true, completion: nil)
            }
        }
}
