//
//  DetailMangaViewController.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/28/23.
//

import UIKit

class DetailMangaViewController: UIViewController {
    var idManga:String = ""
    var mangaDetail:MangaInfoModel = MangaInfoModel()
    var isSelectDetail = true
    @IBOutlet weak var collectionViewMain:UICollectionView!
    @IBOutlet weak var buttonBack:UIButton!
    
    @IBAction func backApp(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonBack.setTitle("", for: .normal)
        collectionViewMain.register(UINib(nibName: InfoMangaDetailCLVCell.className, bundle: nil), forCellWithReuseIdentifier: InfoMangaDetailCLVCell.className)
        collectionViewMain.register(UINib(nibName: DescriptionCLVCell.className, bundle: nil), forCellWithReuseIdentifier: DescriptionCLVCell.className)
        collectionViewMain.register(UINib(nibName: NoCommentCLVCell.className, bundle: nil), forCellWithReuseIdentifier: NoCommentCLVCell.className)
        collectionViewMain.register(UINib(nibName: ChapterItemCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ChapterItemCLVCell.className)
        collectionViewMain.backgroundColor = UIColor.clear
        getDetailFullData(){moviesResponse,error in
        }
    }
    
    func getDetailFullData(andCompletion completion:@escaping (_ moviesResponse: MangaInfoModel, _ error: Error?) -> ()) {
        APIService.shared.GetDetailManga(idManga: idManga) { (response, error) in
            if let listData = response{
                self.mangaDetail = listData
                DispatchQueue.main.async {
                    self.collectionViewMain.reloadData()
                }
            }
            completion(self.mangaDetail, error)
        }
    }
}

extension DetailMangaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSelectDetail == true{
            return 3
        }
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelectDetail == false{
            let viewControllerInXib = MangaReaderViewController(nibName: "MangaReaderViewController", bundle: nil)
            viewControllerInXib.mangaModel = self.mangaDetail
            if mangaDetail.chapterList.count > 0{
                viewControllerInXib.currentChapter = mangaDetail.chapterList[indexPath.row]
            }
            self.present(viewControllerInXib, animated: true, completion: nil)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSelectDetail == true{
            return 1
        }
        if section == 0{
            return 1
        }
        return mangaDetail.chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoMangaDetailCLVCell.className, for: indexPath) as! InfoMangaDetailCLVCell
            cell.mangaDetail = self.mangaDetail
            cell.loadDataInCell()
            return cell
        }
        if isSelectDetail == true{
            if indexPath.section == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCLVCell.className, for: indexPath) as! DescriptionCLVCell
                cell.mangaDetail = self.mangaDetail
                cell.TextViewDescript.text = self.mangaDetail.descriptionPro
                cell.TextViewDescript.isEditable = false
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCommentCLVCell.className, for: indexPath) as! NoCommentCLVCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterItemCLVCell.className, for: indexPath) as! ChapterItemCLVCell
            cell.labelName.text = mangaDetail.chapterList[indexPath.row].name
            cell.indexSend = indexPath.row
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
    }
    
}

extension DetailMangaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if indexPath.section == 0{
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                return CGSize(width: UIScreen.main.bounds.width, height: 350)
            }else{
                let width = Int(UIScreen.main.bounds.width)
                return CGSize(width: width, height: 350)
            }
        }
        if isSelectDetail == true{
            if indexPath.section == 1{
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    return CGSize(width: UIScreen.main.bounds.width, height: 100)
                }else{
                    let width = (Int(UIScreen.main.bounds.width) - 10)
                    return CGSize(width: width, height: 200)
                }
            }
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                return CGSize(width: UIScreen.main.bounds.width, height: 300)
            }else{
                let width = (Int(UIScreen.main.bounds.width) - 10)
                return CGSize(width: width, height: 300)
            }
        }else if isSelectDetail == false{
            if indexPath.section == 1{
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    return CGSize(width: UIScreen.main.bounds.width, height: 50)
                }else{
                    let width = (Int(UIScreen.main.bounds.width) - 10)
                    return CGSize(width: width, height: 50)
                }
            }
        }
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: UIScreen.main.bounds.width, height: 300)
        }else{
            let width = (Int(UIScreen.main.bounds.width) - 10)
            return CGSize(width: width, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}

