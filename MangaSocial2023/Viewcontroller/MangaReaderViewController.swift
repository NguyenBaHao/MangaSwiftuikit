//
//  MangaReaderViewController.swift
//  MangaReader2022
//
//  Created by mac on 03/03/2022.
//

import UIKit
import Kingfisher
import RealmSwift

public enum MangaReaderMode: Int {
    case fromTop = 1
    case fromLeft = 2
    case fromRight = 3
}

let timeForHideControl = 10

public protocol MangaReaderViewControllerDelegate: AnyObject {
    func didShowPhotoAtIndex(_ reader: MangaReaderViewController, index: Int)
}

open class MangaReaderViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomControlView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chapterButton: UIButton!
    
    public weak var delegate: MangaReaderViewControllerDelegate?
    
    var currentIndex: Int = 0
    var readingMode: MangaReaderMode = .fromLeft
    
    var timer: Timer?
    
    var initDatas: [PhotoItem] = []
    var dataSources: [PhotoItem] = []
    var currentChapter: ChapterModel!
    var chapters = List<ChapterModel>()
    var mangaModel: MangaInfoModel!
    
    let cacheImageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "MangaReaderViewCell", bundle: nil), forCellWithReuseIdentifier: "MangaReaderViewCell")
        view.addSubview(cacheImageView)
        
        configNavigationBar()
        
        cacheImageView.isHidden = true
        setUpData()
        collectionView.reloadData()
        collectionView.isHidden = true
        updateLayout()
        reloadBackNextButton()
        showControlView()
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        reloadChapter(chapter: currentChapter)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showControlView()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.reloadData()
        self.scrollToCurrentIndex()
    }
    
    private func configNavigationBar(){
        navigationItem.title = mangaModel.title
        //        let rightItem = UIBarButtonItem(image: UIImage(named: "ic_read_more"), style: .plain, target: self, action: #selector(onReaderMore(_:)))
        //        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "ic_close_white"), style: .plain, target: self, action: #selector(actionClose(_:)))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.title = mangaModel.title
        
    }
    
    public class func bundle() -> Bundle{
        let bundle = Bundle(for: MangaReaderViewController.self)
        let path = bundle.path(forResource: "ServiceManager", ofType: "bundle")!
        let xibBundle = Bundle(path: path)!
        return xibBundle
    }
}

//MARK: -- Reader Helper

extension MangaReaderViewController{
    
    func reloadReadingMode(){
        self.collectionView.isHidden = true
        self.dataSources.removeAll()
        self.collectionView.reloadData()
        showControlView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.setUpData()
            self?.collectionView.reloadData()
            self?.updateLayout()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            self?.scrollToCurrentIndex()
        })
    }
    
    func reloadBackNextButton(){
        let chapterIds = chapters.map({$0.id})
        if let index = chapterIds.firstIndex(of: currentChapter.id){
            if index == 0{
                nextButton.isEnabled = false
            }else{
                nextButton.isEnabled = true
            }
            
            if index == (chapters.count - 1){
                backButton.isEnabled = false
            }else{
                backButton.isEnabled = true
            }
        }
    }
    
    func reloadChapter(chapter: ChapterModel){
        getImages(chapter: chapter)
    }
    
    //    func readNonCacheChapter(images: [ImageModel], chapter: ChapterModel){
    func readNonCacheChapter(images: List<ImageModel>, chapter: ChapterModel){
        if images.count > 0{
            let imageChapters = images.sorted { (chapterImage1, chapterImage2) -> Bool in
                return chapterImage1.index < chapterImage2.index
            }
            var photoItems = [PhotoItem]()
            for imageChapter in imageChapters{
                let photo = PhotoItem.photoWithImageURL(imageChapter.thumbnail_url)
                photo.viewWidth = CGFloat(imageChapter.width)
                photo.viewHeight = CGFloat(imageChapter.height)
                photoItems.append(photo)
            }
            currentIndex = 0
            let readingPage = chapter.readingPage
            if readingPage < photoItems.count && readingPage != -1{
                currentIndex = readingPage
            }
            if let saveChapter = DataManager.instance.chapterById(String(chapter.id)){
                currentChapter = saveChapter
            }else{
                currentChapter = chapter
            }
            //            delegate?.didReadChapter(self, chapter: currentChapter)
            initDatas.removeAll()
            setUpData()
            collectionView.reloadData()
            initDatas.append(contentsOf: photoItems)
            setUpData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                self?.setUpData()
                self?.collectionView.reloadData()
                self?.updateLayout()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.scrollToCurrentIndex()
            })
            
            reloadBackNextButton()
        }
    }
}

//MARK: -- Data Helper

extension MangaReaderViewController{
    
    func setUpData(){
        var chapter = currentChapter
        let chapterIds = chapters.map({$0.id})
        if let index = chapterIds.firstIndex(of: currentChapter.id){
            chapter = chapters[index]
        }
        if let chap = chapter{
            if chap.name.count > 0{
                //                let att: [NSAttributedString.Key: Any] = [.font: UIFont.appFontRegular(15), .foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
                //                let newAtt = NSMutableAttributedString(string: chap.name, attributes: att)
                //                chapterButton.setAttributedTitle(newAtt, for: .normal)
                chapterButton.titleLabel?.text = chap.name
            }else{
                //                let att: [NSAttributedString.Key: Any] = [.font: UIFont.appFontRegular(15), .foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
                //                let newAtt = NSMutableAttributedString(string: "\(mangaModel.name) \(chap.index)", attributes: att)
                //                chapterButton.setAttributedTitle(newAtt, for: .normal)
                chapterButton.titleLabel?.text = mangaModel.title
            }
        }
        dataSources.removeAll()
        dataSources.append(contentsOf: initDatas)
        //        let readingMode = MangaReaderMode(rawValue: ReadModeManager.shared.getReadingMode())!
        //        if readingMode == .fromRight{
        //            dataSources.reverse()
        //        }
    }
    
    func getImages(chapter: ChapterModel){
        //        showLoadLock()
        APIService.shared.loadAllImageInChapter(chapterIn: chapters[currentIndex]) { (response, error) in
            if let response = response{
                if response.listImage.count > 0{
                    self.readNonCacheChapter(images: response.listImage, chapter: response)
                }
            }
        }
    }
    
    func updateLayout(){
        let readingMode = MangaReaderMode(rawValue: ReadModeManager.shared.getReadingMode() ?? 1)
        let layout = UICollectionViewFlowLayout()
        var isPaging = true
        if readingMode == .fromLeft{
            layout.scrollDirection = .horizontal
            isPaging = true
        }else if readingMode == .fromRight{
            layout.scrollDirection = .horizontal
            isPaging = true
        }else if readingMode == .fromTop{
            layout.scrollDirection = .vertical
            isPaging = false
        }
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = isPaging
        collectionView.reloadData()
    }
    
    func scrollToCurrentIndex(){
        readingMode = MangaReaderMode(rawValue: ReadModeManager.shared.getReadingMode() ?? 1) ?? MangaReaderMode.fromTop
        if currentIndex < dataSources.count && currentIndex >= 0{
            if readingMode == .fromLeft{
                collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }else if readingMode == .fromRight{
                let index = dataSources.count - currentIndex - 1
                collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: false)
            }else if readingMode == .fromTop{
                collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .top, animated: false)
            }
        }
        collectionView.isHidden = false
    }
    
    func getCurrentIndex(){
        if let indexPath = collectionView.indexPathsForVisibleItems.last {
            delegate?.didShowPhotoAtIndex(self, index: indexPath.row)
            let readingMode = MangaReaderMode(rawValue: ReadModeManager.shared.getReadingMode() ?? 1)
            if readingMode == .fromRight{
                currentIndex = dataSources.count - indexPath.row - 1
            }else{
                currentIndex = indexPath.row
            }
        }
    }
}

//MARK: -- UI Helper

extension MangaReaderViewController{
    
    func showControlView(){
        bottomView.isHidden = false
        bottomControlView.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeForHideControl), repeats: false, block: { [weak self] (timer) in
            self?.hideControlView()
        })
    }
    
    func hideControlView(){
        bottomView.isHidden = true
        bottomControlView.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: -- Action handle

extension MangaReaderViewController{
    
    @objc func actionClose(_ sender: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onReaderMore(_ sender: UIBarButtonItem){
        //        let settingVC = ReaderSettingViewController()
        //        settingVC.delegate = self
        //        settingVC.modalPresentationStyle = .overFullScreen
        //        present(settingVC, animated: true, completion: nil)
    }
    
    @IBAction func onNextChapter(_ sender: Any) {
        let chapterIds = chapters.map({$0.id})
        if let index = chapterIds.firstIndex(of: currentChapter.id){
            let backIndex = index - 1
            if backIndex >= 0{
                reloadChapter(chapter: chapters[backIndex])
            }
        }
    }
    
    @IBAction func onBackChapter(_ sender: Any) {
        let chapterIds = chapters.map({$0.id})
        if let index = chapterIds.firstIndex(of: currentChapter.id){
            let nextIndex = index + 1
            if nextIndex < chapters.count{
                reloadChapter(chapter: chapters[nextIndex])
            }
        }
    }
    
    @IBAction func onChapter(_ sender: Any) {
        //        let chapterVC = ChaptersViewController.init(nibName: "ChaptersViewController", bundle: ChaptersViewController.bundle())
        //        chapterVC.chapters = chapters
        //        chapterVC.mangaModel = mangaModel
        //        chapterVC.delegate = self
        //        let navi = BaseNavigationController.init(rootViewController: chapterVC)
        //        navi.modalPresentationStyle = .fullScreen
        //        present(navi, animated: true)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension MangaReaderViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if readingMode == .fromTop{
            delegate?.didShowPhotoAtIndex(self, index: indexPath.row)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaReaderViewCell", for: indexPath) as! MangaReaderViewCell
        
        let photoModel = dataSources[indexPath.row]
        if let image = photoModel.underlyingImage{
            cell.imageView.image = image
            self.loadCacheImage(nowIndex: indexPath.row)
        }else{
            if let imageUrl = photoModel.photoURL{
                let url = URL(string: imageUrl)
                let i = CustomIndicator()
                cell.imageView.kf.indicatorType = .custom(indicator: i)
                cell.imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (result) in
                    switch result {
                    case .success(let value):
                        for (index, item) in self?.initDatas.enumerated() ?? [].enumerated(){
                            let urlddd = value.source.url?.absoluteString
                            if item.photoURL == urlddd{
                                let temp = PhotoItem.init(image: value.image)
                                self?.initDatas.remove(at: index)
                                self?.initDatas.insert(temp, at: index)
                            }
                        }
                        for (index, item) in self?.dataSources.enumerated() ?? [].enumerated(){
                            let urlddd = value.source.url?.absoluteString
                            if item.photoURL == urlddd{
                                let temp = PhotoItem.init(image: value.image)
                                self?.dataSources.remove(at: index)
                                self?.dataSources.insert(temp, at: index)
                                collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                                self?.loadCacheImage(nowIndex: index)
                                break
                            }
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        }
        // cell.delegate = self
        return cell
    }
    
    func loadCacheImage(nowIndex: Int){
        var cacheModel: PhotoItem?
        if readingMode == .fromRight{
            let index = nowIndex - 1
            if index >= 0 {
                cacheModel = dataSources[index]
            }
        }else{
            let index = nowIndex + 1
            if index < dataSources.count {
                cacheModel = dataSources[index]
            }
        }
        if cacheModel?.underlyingImage == nil,
           let imageUrl = cacheModel?.photoURL{
            let url = URL(string: imageUrl)
            cacheImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (result) in
                switch result {
                case .success(let value):
                    for (index, item) in self?.initDatas.enumerated() ?? [].enumerated(){
                        let urlddd = value.source.url?.absoluteString
                        if item.photoURL == urlddd{
                            let temp = PhotoItem.init(image: value.image)
                            self?.initDatas.remove(at: index)
                            self?.initDatas.insert(temp, at: index)
                        }
                    }
                    for (index, item) in self?.dataSources.enumerated() ?? [].enumerated(){
                        let urlddd = value.source.url?.absoluteString
                        if item.photoURL == urlddd{
                            let temp = PhotoItem.init(image: value.image)
                            self?.dataSources.remove(at: index)
                            self?.dataSources.insert(temp, at: index)
                            self?.collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                            break
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MangaReaderViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if readingMode == .fromTop {
            let photoModel = dataSources[indexPath.row]
            let width = UIScreen.main.bounds.size.width
            let height = (photoModel.viewHeight / photoModel.viewWidth) * UIScreen.main.bounds.size.width
            if height < 20{
                return view.bounds.size
            }
            return CGSize.init(width: width, height: height)
        }else{
            return view.bounds.size
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if readingMode == .fromTop {
            return 1
        }else{
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK : -- MangaReaderViewCellDelegate

//extension MangaReaderViewController: MangaReaderViewCellDelegate{
//
//    func didClickOnImage(cell: MangaReaderViewCell) {
//        if bottomControlView.isHidden{
//            showControlView()
//        }else{
//            hideControlView()
//        }
//    }
//
//    func didZoomImage(cell: MangaReaderViewCell, zoomed: Bool) {
//        collectionView.isScrollEnabled = zoomed
//    }
//}

//MARK : -- UIScrollViewDelegate

extension MangaReaderViewController: UIScrollViewDelegate{
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if readingMode != .fromTop{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
                self?.getCurrentIndex()
            })
        }
    }
}

//MARK : -- UIGestureRecognizerDelegate

extension MangaReaderViewController: UIGestureRecognizerDelegate{
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if readingMode == .fromTop{
            return false
        }
        return true
    }
}

//MARK : -- ReaderSettingViewControllerDelegate

//extension MangaReaderViewController: ReaderSettingViewControllerDelegate{
//
//    func didChangeSetting(_ reader: ReaderSettingViewController, mode: MangaReaderMode) {
//        if mode == .fromTop{
//            if readingMode != .fromTop{
//                getCurrentIndex()
//                readingMode = mode
//                ReadModeManager.shared.saveReadingMode(mode: .fromTop)
//                reloadReadingMode()
//            }
//        }else if mode == .fromLeft{
//            if readingMode != .fromLeft{
//                getCurrentIndex()
//                readingMode = mode
//                ReadModeManager.shared.saveReadingMode(mode: .fromLeft)
//                reloadReadingMode()
//            }
//        }else if mode == .fromRight{
//            if readingMode != .fromRight{
//                getCurrentIndex()
//                readingMode = mode
//                ReadModeManager.shared.saveReadingMode(mode: .fromRight)
//                reloadReadingMode()
//            }
//        }
//    }
//
//    func didClickNextButton(_ reader: ReaderSettingViewController) {
//        let chapterIds = chapters.map({$0.id})
//        if let index = chapterIds.firstIndex(of: currentChapter.id){
//            let backIndex = index - 1
//            if backIndex >= 0{
//                reloadChapter(chapter: chapters[backIndex])
//            }
//        }
//    }
//
//    func didClickBackButton(_ reader: ReaderSettingViewController) {
//        let chapterIds = chapters.map({$0.id})
//        if let index = chapterIds.firstIndex(of: currentChapter.id){
//            let nextIndex = index + 1
//            if nextIndex < chapters.count{
//                reloadChapter(chapter: chapters[nextIndex])
//            }
//        }
//    }
//}

//MARK : -- CustomIndicator

final class CustomIndicator: Indicator {
    
    private let activityIndicatorView: UIActivityIndicatorView
    
    private var animatingCount = 0
    
    var view: IndicatorView {
        return activityIndicatorView
    }
    
    func startAnimatingView() {
        if animatingCount == 0 {
            activityIndicatorView.startAnimating()
            activityIndicatorView.isHidden = false
        }
        animatingCount += 1
    }
    
    func stopAnimatingView() {
        animatingCount = max(animatingCount - 1, 0)
        if animatingCount == 0 {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    func sizeStrategy(in imageView: KFCrossPlatformImageView) -> IndicatorSizeStrategy {
        return .intrinsicSize
    }
    
    init() {
        if #available(iOS 13.0, *) {
            activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        } else {
            activityIndicatorView = UIActivityIndicatorView.init(style: .white)
        }
        activityIndicatorView.color = .white
    }
}

//MARK: -- ChaptersViewControllerDelegate
//extension MangaReaderViewController: ChaptersViewControllerDelegate{
//    func didSelectChapter(_ chapter: ChapterModel) {
//        reloadChapter(chapter: chapter)
//    }
//}
