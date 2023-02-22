//
//  CategoriesMoreViewController.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/30/23.
//

import UIKit
import Kingfisher

class CategoriesMoreViewController: UIViewController {
    @IBOutlet weak var collectionViewMain:UICollectionView!
    var listMangaItem:[MangaItemModel] = [MangaItemModel]()
    var idManga:String = ""
    @IBOutlet weak var buttonBack:UIButton!

    func loadDataManga(){
        APIService.shared.get3MangaItemList(idCategories: idManga) { (response, error) in
            if let itemManga = response{
                self.listMangaItem = itemManga
                self.collectionViewMain.reloadData()
            }
        }
    }
    
    @IBAction func backApp(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonBack.setTitle("", for: .normal)
        collectionViewMain.register(UINib(nibName: ItemBannerViewCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ItemBannerViewCLVCell.className)
        collectionViewMain.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        loadDataManga()
    }
}
extension CategoriesMoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.listMangaItem.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemBannerViewCLVCell.className, for: indexPath) as! ItemBannerViewCLVCell
        let url = URL(string: self.listMangaItem[indexPath.row].image)
        print(self.listMangaItem[indexPath.row].image)
        let processor = DownsamplingImageProcessor(size: cell.imagePoster.bounds.size )
        |> RoundCornerImageProcessor(cornerRadius: 5)
        cell.imagePoster.kf.indicatorType = .activity
        cell.imagePoster.kf.setImage(
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
        cell.imagePoster?.clipsToBounds = true
        cell.labelName?.text = self.listMangaItem[indexPath.row].title
        cell.labelName?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaViewController") as! DetailMangaViewController
//        detail.idManga = String(self.listData[indexPath.row].id)
//        detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(detail, animated: true, completion: nil)
    }
    
}

extension CategoriesMoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: Int(UIScreen.main.bounds.width/6) - 10, height:  250)
        }else{
            let width = (Int(collectionView.bounds.size.width/3) - 10)
            return CGSize(width: width, height:  250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}

