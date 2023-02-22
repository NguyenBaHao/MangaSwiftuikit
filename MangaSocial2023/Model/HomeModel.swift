//
//  HomeModel.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 2/7/23.
//

import Foundation

import Foundation
import UIKit

class HomeMangaModel: NSObject {
    var manga_new: [MangaItemModel] = [MangaItemModel]()
    var hot_manga: [MangaItemModel] = [MangaItemModel]()
    var manga_last_update: [MangaItemModel] = [MangaItemModel]()
    var hot_update: [MangaItemModel] = [MangaItemModel]()
    
    func initLoad(_ json:  [String: Any]) -> HomeMangaModel{
        if let temp = json["manga_new"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:MangaItemModel = MangaItemModel()
                chapterItem = chapterItem.initLoad(item)
                manga_new.append(chapterItem)
            }
        }
        if let temp = json["hot_manga"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:MangaItemModel = MangaItemModel()
                chapterItem = chapterItem.initLoad(item)
                hot_manga.append(chapterItem)
            }
        }
        if let temp = json["manga_last_update"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:MangaItemModel = MangaItemModel()
                chapterItem = chapterItem.initLoad(item)
                manga_last_update.append(chapterItem)
            }
        }
        if let temp = json["hot_update"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:MangaItemModel = MangaItemModel()
                chapterItem = chapterItem.initLoad(item)
                hot_update.append(chapterItem)
            }
        }
        return self
    }
}
