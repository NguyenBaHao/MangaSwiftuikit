//
//  CategoriesViewController.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/30/23.
//

import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var collectionViewMain:UICollectionView!
    var listCategories:[CategoriesModel] = [CategoriesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMain.delegate = self
        collectionViewMain.dataSource = self
        collectionViewMain.backgroundColor = UIColor.clear
        collectionViewMain.register(UINib(nibName: CategoriesItemCLVCell.className, bundle: nil), forCellWithReuseIdentifier: CategoriesItemCLVCell.className)
        APIService.shared.getMangaCategories() { (response, error) in
            if let listData = response{
                self.listCategories = listData
                DispatchQueue.main.async {
                    self.collectionViewMain.reloadData()
                }
            }
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.listCategories.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesItemCLVCell.className, for: indexPath) as! CategoriesItemCLVCell
        cell.labelName.text = self.listCategories[indexPath.row].title
        cell.itemCategories = self.listCategories[indexPath.row]
        cell.collectionViewMain.reloadData()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: CategoriesMoreViewController.className) as! CategoriesMoreViewController
        detail.idManga = String(self.listCategories[indexPath.row].id)
        detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(detail, animated: true, completion: nil)
    }
    
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemIndex = 1
        if self.listCategories[indexPath.row].listMangaItem.count != 0{
            itemIndex = self.listCategories[indexPath.row].listMangaItem.count
        }
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: Int(UIScreen.main.bounds.width) - 10, height: itemIndex * 250)
        }else{
            let width = (Int(collectionView.bounds.size.width) - 10)
            return CGSize(width: width, height: itemIndex * 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}

