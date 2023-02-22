//
//  BannerCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/26/23.
//

import UIKit
import FSPagerView
import Kingfisher


class BannerCLVCell: UICollectionViewCell, FSPagerViewDataSource,FSPagerViewDelegate {
    var listBanner:[MangaItemModel] = [MangaItemModel]()
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = self.listBanner.count
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(ItemBannerViewCLVCell.self, forCellWithReuseIdentifier: "ItemBannerViewCLVCell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pagerView.register(UINib(nibName: ItemBannerViewCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ItemBannerViewCLVCell.className)
        self.pagerView.decelerationDistance = 2
        let newScale = 0.5
        self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: newScale * 2))
        self.pagerView.interitemSpacing = 5 // [0 - 20]
        self.pageControl.numberOfPages = 4
        self.pagerView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.pageControl.backgroundColor = UIColor.clear
    }
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.listBanner.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ItemBannerViewCLVCell", at: index) as? ItemBannerViewCLVCell{
            let url = URL(string: self.listBanner[index].image)
            print(self.listBanner[index].image)
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
            cell.labelName?.text = self.listBanner[index].title
            cell.labelName?.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        return ItemBannerViewCLVCell()
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
        if let detail = self.parentViewController as? DetailMangaViewController{
            detail.idManga = String(self.listBanner[index].id)
            detail.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.parentViewController?.present(detail, animated: true, completion: nil)
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }

}
