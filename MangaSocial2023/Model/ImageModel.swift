//
//  ImageModel.swift
//  ServiceManager
//
//  Created by mac on 07/07/2022.
//

import UIKit
import RealmSwift

public class ImageModel: Object {
    
    @objc public dynamic  var thumbnail_url = ""
    @objc public dynamic  var index = 0
    @objc public dynamic  var id = 0
    @objc public dynamic  var chapter_id = 0
    var width: CGFloat = UIScreen.main.bounds.size.width
    var height: CGFloat = UIScreen.main.bounds.size.height
    
    func initLoad(_ json:  [String: Any]) -> ImageModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["chapter_id"] as? Int { chapter_id = temp }
        if let temp = json["thumbnail_url"] as? String { thumbnail_url = temp }
        return self
    }
    
    public static func imageWith(url: String, index: Int) -> ImageModel{
        let chapterImage = ImageModel()
        chapterImage.thumbnail_url = url
        chapterImage.index = index
        return chapterImage
    }
}
