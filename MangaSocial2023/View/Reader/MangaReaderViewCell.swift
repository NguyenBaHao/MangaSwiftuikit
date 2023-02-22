//
//  MangaReaderViewCell.swift
//  MangaReader2022
//
//  Created by mac on 03/03/2022.
//

import UIKit

protocol MangaReaderViewCellDelegate: AnyObject {
    func didClickOnImage(cell: MangaReaderViewCell)
    func didZoomImage(cell: MangaReaderViewCell, zoomed: Bool)
}

class MangaReaderViewCell: UICollectionViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    weak var delegate: MangaReaderViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let zoomGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomWhenDoubleTapped))
        zoomGestureRecognizer.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(zoomGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.require(toFail: zoomGestureRecognizer)

        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 3
    }
        
    @objc private func tappedOnView(_ gesture: UITapGestureRecognizer) {
        delegate?.didClickOnImage(cell: self)
    }
    
    @objc private func zoomWhenDoubleTapped(_ gesture: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    public class func bundle() -> Bundle{
        let bundle = Bundle(for: MangaReaderViewCell.self)
        let path = bundle.path(forResource: "ServiceManager", ofType: "bundle")!
        let xibBundle = Bundle(path: path)!
        return xibBundle
    }
}

// MARK: - UIScrollViewDelegate

extension MangaReaderViewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let isOriginalSize = scrollView.zoomScale == scrollView.minimumZoomScale
        delegate?.didZoomImage(cell: self, zoomed: isOriginalSize)
    }
}
