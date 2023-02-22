//
//  MainMangaViewController.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/25/23.
//

import UIKit
import Kingfisher

class MainMangaViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMain:UICollectionView!
    @IBOutlet weak var buttonSearch:UIButton!
    var dataHome:HomeMangaModel = HomeMangaModel()
    var bIsSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonSearch.setTitle("", for: .normal)
        collectionViewMain.register(UINib(nibName: BannerCLVCell.className, bundle: nil), forCellWithReuseIdentifier: BannerCLVCell.className)
        collectionViewMain.register(UINib(nibName: HomeCLVCell.className, bundle: nil), forCellWithReuseIdentifier: HomeCLVCell.className)

        collectionViewMain.register(UINib(nibName: SearchTextCLVCell.className, bundle: nil), forCellWithReuseIdentifier: SearchTextCLVCell.className)
        collectionViewMain.register(UINib(nibName: ItemBannerViewCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ItemBannerViewCLVCell.className)
        
        collectionViewMain.delegate = self
        collectionViewMain.dataSource = self
        collectionViewMain.backgroundColor = UIColor.clear
        
        self.getHomeNimeManga{moviesResponse,error in
        }
    }
    
    @IBAction func searchClickDetect(){
        self.bIsSearch = !self.bIsSearch
        self.collectionViewMain.reloadData()
    }
    
    func getHomeNimeManga(andCompletion completion:@escaping (_ moviesResponse:HomeMangaModel, _ error: Error?) -> ()) {
        APIService.shared.getHomeMangaReload() { (response, error) in
            if let listData = response{
                self.dataHome = listData
                DispatchQueue.main.async {
                    self.collectionViewMain.reloadData()
                }
            }
        }
    }
    
}
extension MainMangaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if bIsSearch == false{
            return 4
        }
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bIsSearch == false{
            if section == 0{
                return 1
            }
            return 1
            
        }
        if section == 0{
            return 1
        }
        return self.dataHome.manga_new.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if bIsSearch == false{
            if indexPath.section == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCLVCell.className, for: indexPath) as! BannerCLVCell
                cell.listBanner = self.dataHome.manga_new
                cell.pagerView.reloadData()
                return cell
            }
            if indexPath.section == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCLVCell.className, for: indexPath) as! HomeCLVCell
                cell.mangaList = self.dataHome.hot_manga
                cell.collectionViewHomeMain.reloadData()
                cell.labelName.text = "Hot Manga"
                return cell
            }
            if indexPath.section == 2{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCLVCell.className, for: indexPath) as! HomeCLVCell
                cell.mangaList = self.dataHome.manga_last_update
                cell.collectionViewHomeMain.reloadData()
                cell.labelName.text = "Lastest Manga"
                return cell
            }
            if indexPath.section == 3{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCLVCell.className, for: indexPath) as! HomeCLVCell
                cell.mangaList = self.dataHome.hot_update
                cell.collectionViewHomeMain.reloadData()
                cell.labelName.text = "Last Update"
                return cell
            }
            
        }
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTextCLVCell.className, for: indexPath) as! SearchTextCLVCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemBannerViewCLVCell.className, for: indexPath) as! ItemBannerViewCLVCell
        let url = URL(string: self.dataHome.hot_manga[indexPath.row].image)
        print(self.dataHome.hot_manga[indexPath.row].image)
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
        cell.labelName?.text = self.dataHome.hot_manga[indexPath.row].title
        cell.labelName?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaViewController") as! DetailMangaViewController
        detail.idManga = String(self.dataHome.hot_manga[indexPath.row].id)
        detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(detail, animated: true, completion: nil)
    }
    
    
}

extension MainMangaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if bIsSearch == false{
            if indexPath.section == 0{
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    return CGSize(width: UIScreen.main.bounds.width, height: 300)
                }else{
                    let width = (Int(collectionView.bounds.size.width) - 10)
                    return CGSize(width: width, height: 300)
                }
            }
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                return CGSize(width: UIScreen.main.bounds.width/6 - 10, height: 250)
            }else{
                let width = (Int(collectionView.bounds.size.width) - 10)
                return CGSize(width: width, height: 250)
            }
        }
        if indexPath.section == 0{
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                return CGSize(width: UIScreen.main.bounds.width, height: 50)
            }else{
                let width = (Int(collectionView.bounds.size.width) - 10)
                return CGSize(width: width, height: 50)
            }
        }
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: UIScreen.main.bounds.width/6 - 10, height: 250)
        }else{
            let width = (Int(collectionView.bounds.size.width))
            return CGSize(width: width/3 - 10, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}

