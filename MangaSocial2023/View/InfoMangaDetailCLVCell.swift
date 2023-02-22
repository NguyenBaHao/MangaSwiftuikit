//
//  InfoMangaDetailCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/28/23.
//

import UIKit
import Kingfisher

class InfoMangaDetailCLVCell: UICollectionViewCell {
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelAuthod:UILabel!
    @IBOutlet weak var labelCategories:UILabel!
    @IBOutlet weak var labelUpdate:UILabel!
    @IBOutlet weak var imageCover:UIImageView!
    @IBOutlet weak var buttonRead:UIButton!
    @IBOutlet weak var buttonFavorite:UIButton!
    @IBOutlet weak var buttonShare:UIButton!
    @IBOutlet weak var buttonComment:UIButton!
    @IBOutlet weak var buttonDetail:UIButton!
    @IBOutlet weak var buttonChapter:UIButton!

    var mangaDetail:MangaInfoModel = MangaInfoModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonRead.setTitle("", for: .normal)
        self.buttonFavorite.setTitle("", for: .normal)
        self.buttonShare.setTitle("", for: .normal)
        self.buttonComment.setTitle("", for: .normal)
        buttonDetail.setTitle("", for: .normal)
        buttonChapter.setTitle("", for: .normal)
    }

    func loadDataInCell(){
        let url = URL(string: mangaDetail.image)
        let processor = DownsamplingImageProcessor(size: imageCover.bounds.size )
                     |> RoundCornerImageProcessor(cornerRadius: 5)
        imageCover.kf.indicatorType = .activity
        imageCover.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        imageCover.clipsToBounds = true
        labelName.text = mangaDetail.title
        var authodPro = ""
        for item in mangaDetail.authors{
            authodPro = authodPro + " "
            authodPro = authodPro + item.title
        }
        labelAuthod.text = authodPro
        labelCategories.text = mangaDetail.type
        let date = NSDate(timeIntervalSince1970: TimeInterval(mangaDetail.updated_at))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        labelUpdate.text = dateString
    }
    
    @IBAction func shareAction(){
        
    }
    
    @IBAction func faviroteAction(){
        
    }
    
    @IBAction func commentAction(){
        
    }
    @IBAction func DetailSegmentAction(){
        if let parentView = self.parentViewController as? DetailMangaViewController{
            parentView.isSelectDetail = true
            parentView.collectionViewMain.reloadData()
            if parentView.isSelectDetail == true{
                buttonDetail.setImage(UIImage(named: "detail_select.png"), for: .normal)
                buttonChapter.setImage(UIImage(named: "chapter.png"), for: .normal)
            }else{
                buttonDetail.setImage(UIImage(named: "detail.png"), for: .normal)
                buttonChapter.setImage(UIImage(named: "chapter_select.png"), for: .normal)
            }
        }
    }
    @IBAction func ChapterSegmentAction(){
        if let parentView = self.parentViewController as? DetailMangaViewController{
            parentView.isSelectDetail = false
            parentView.collectionViewMain.reloadData()
            if parentView.isSelectDetail == true{
                buttonDetail.setImage(UIImage(named: "detail_select.png"), for: .normal)
                buttonChapter.setImage(UIImage(named: "chapter.png"), for: .normal)
            }else{
                buttonDetail.setImage(UIImage(named: "detail.png"), for: .normal)
                buttonChapter.setImage(UIImage(named: "chapter_select.png"), for: .normal)
            }
        }
    }
    
}
