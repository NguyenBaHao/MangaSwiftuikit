//
//  CategoriesItemCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/30/23.
//

import UIKit
import Kingfisher

class CategoriesItemCLVCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewMain:UICollectionView!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelSeeMore:UILabel!
    var itemCategories: CategoriesModel = CategoriesModel()
    override func awakeFromNib() {
        super.awakeFromNib()
       // collectionViewMain.backgroundColor = UIColor.clear
       // self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 20.0
        self.clipsToBounds = true
        self.collectionViewMain.layer.cornerRadius = 20.0
        self.collectionViewMain.clipsToBounds = true
        collectionViewMain.register(UINib(nibName: CategoriesItem1CLVCell.className, bundle: nil), forCellWithReuseIdentifier: CategoriesItem1CLVCell.className)
    }
    
}
extension CategoriesItemCLVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.itemCategories.listMangaItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesItem1CLVCell.className, for: indexPath) as! CategoriesItem1CLVCell
        cell.labelName.text = self.itemCategories.listMangaItem[indexPath.row].title
        var authodPro = ""
        for item in self.itemCategories.listMangaItem[indexPath.row].authors{
            authodPro = authodPro + " - " + item
        }
        let date = NSDate(timeIntervalSince1970: TimeInterval(self.itemCategories.listMangaItem[indexPath.row].updated_at))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        cell.labeUpdate.text = dateString
        cell.labelAuthod.text = authodPro
        //__________________
        let url = URL(string: self.itemCategories.listMangaItem[indexPath.row].image)
        let processor = DownsamplingImageProcessor(size: cell.imageCover.bounds.size )
        |> RoundCornerImageProcessor(cornerRadius: 5)
        cell.imageCover.kf.indicatorType = .activity
        cell.imageCover.kf.setImage(
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
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaViewController") as! DetailMangaViewController
        //        detail.idManga = String(self.listData[indexPath.row].id)
        //        detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        //        self.present(detail, animated: true, completion: nil)
    }
    
}

extension CategoriesItemCLVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: UIScreen.main.bounds.width , height: 130)
        }else{
            let width = (Int(collectionView.bounds.size.width) )
            return CGSize(width: width, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

