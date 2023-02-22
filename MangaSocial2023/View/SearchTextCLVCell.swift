//
//  SearchTextCLVCell.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/29/23.
//

import UIKit

class SearchTextCLVCell: UICollectionViewCell,UITextViewDelegate  {
    @IBOutlet weak var textViewMain:UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        textViewMain.layer.cornerRadius = 20.0
        textViewMain.clipsToBounds = true
        textViewMain.backgroundColor = UIColor(red: 220/225, green: 226/225, blue: 237/225, alpha: 1)
        textViewMain.delegate = self //Without setting the delegate you won't be able to track UITextView events
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text);
        APIService.shared.searchMangaText(searchKey: textView.text) { (response, error) in
            if let listData = response{
                DispatchQueue.main.async {
                    if let parentView = self.parentViewController as? MainMangaViewController{
                        parentView.dataHome.hot_manga = listData //self.dataHome.hot_manga
                        parentView.collectionViewMain.reloadData()
                    }
                }
            }
        }
    }
}
