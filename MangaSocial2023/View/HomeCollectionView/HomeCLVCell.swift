//
//  HomeCLVCell.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 06/02/2023.
//

import UIKit
import Kingfisher

class HomeCLVCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewHomeMain:UICollectionView!
    @IBOutlet weak var labelName:UILabel!
    var mangaList: [MangaItemModel] = [MangaItemModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewHomeMain.backgroundColor = UIColor.clear
        collectionViewHomeMain.register(UINib(nibName: Home1CollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: Home1CollectionViewCell.className)
    }

}
extension HomeCLVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewHomeMain.dequeueReusableCell(withReuseIdentifier: Home1CollectionViewCell.className, for: indexPath) as! Home1CollectionViewCell
        let url = URL(string: self.mangaList[indexPath.row].image)
        print("____SONPRO____")
        let processor = DownsamplingImageProcessor(size: cell.imageManga.bounds.size )
                     |> RoundCornerImageProcessor(cornerRadius: 5)
        cell.imageManga.kf.indicatorType = .activity
        cell.imageManga.kf.setImage(
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
        cell.imageManga?.clipsToBounds = true
        cell.labName?.text = self.mangaList[indexPath.row].title
        cell.labName?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = self.parentViewController?.storyboard?.instantiateViewController(withIdentifier: "DetailMangaViewController") as! DetailMangaViewController
        detail.idManga = String(self.mangaList[indexPath.row].id)
        detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.parentViewController?.present(detail, animated: true, completion: nil)
    }

}
//
extension HomeCLVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: UIScreen.main.bounds.width/6 - 10, height: 300)
        }else{
            let width = (Int(collectionView.bounds.size.width))
            return CGSize(width: width/4, height: 200)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    }
}


