//
//  MangaInfoModel.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/28/23.
//

import Foundation
import UIKit
import RealmSwift

class CategoriesModel: NSObject {
    var id: Int = 0
    var title:String = ""
    var slug:String = ""
    var is_active:Bool = false
    var total_manga:Int = 0
    var image:String = ""
    var descriptionPro:String = ""
    var created_at:Int = 0
    var updated_at:Int = 0
    var listMangaItem:[MangaItemModel] = [MangaItemModel]()
                                           
    func initLoad(_ json:  [String: Any]) -> CategoriesModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["title"] as? String { title = temp }
        if let temp = json["slug"] as? String { slug = temp }
        if let temp = json["is_active"] as? Bool { is_active = temp }
        if let temp = json["total_manga"] as? Int { total_manga = temp }
        if let temp = json["image"] as? String { image = temp }
        if let temp = json["description"] as? String { descriptionPro = temp }
        if let temp = json["created_at"] as? Int { created_at = temp }
        if let temp = json["updated_at"] as? Int { updated_at = temp }
        APIService.shared.get3MangaItemList(idCategories: String(id)) { (response, error) in
            if let itemManga = response{
                self.listMangaItem = itemManga
            }
        }
        return self
    }
}

class AuthorModel: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var title:String = ""
    func initLoad(_ json:  [String: Any]) -> AuthorModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["title"] as? String { title = temp }
        return self
    }
}

class ChapterModel: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var manga_id:Int = 0
    @objc public dynamic var name = ""
    @objc public dynamic var is_active = true
    @objc public dynamic var thumbnail_count = 0
    @objc public dynamic var created_at = 0
    @objc public dynamic var updated_at = 0
    @objc public dynamic var readingPage = 0
    @objc public dynamic var idChapter = ""
    var listImage = List<ImageModel>()
    public override static func primaryKey() -> String? {
        return "idChapter"
    }
    
    func initLoad(_ json:  [String: Any]) -> ChapterModel{
        if let temp = json["id"] as? Int {
            id = temp
            idChapter = String(id)
        }
        if let temp = json["name"] as? String { name = temp }
        if let temp = json["manga_id"] as? Int { manga_id = temp }
        if let temp = json["is_active"] as? Bool { is_active = temp }
        if let temp = json["thumbnail_count"] as? Int { thumbnail_count = temp }
        if let temp = json["created_at"] as? Int { created_at = temp }
        if let temp = json["updated_at"] as? Int { updated_at = temp }
        return self
    }
}

class CategoriModel: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var name:String = ""
    @objc public dynamic var descriptionPro = ""
    func initLoad(_ json:  [String: Any]) -> CategoriModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["name"] as? String { name = temp }
        if let temp = json["description"] as? String { descriptionPro = temp }
        return self
    }
}

class MangaInfoModel: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var type:String = ""
    @objc public dynamic var title = ""
    @objc public dynamic var slug = ""
    @objc public dynamic var status = ""
    @objc public dynamic var is_active = 0
    @objc public dynamic var image = ""
    @objc public dynamic var chapter_count = 0
    @objc public dynamic var rank = 0
    @objc public dynamic var descriptionPro = ""
    @objc public dynamic var release_at = 0
    @objc public dynamic var created_at = 0
    @objc public dynamic var updated_at = 0
    var authors = List<AuthorModel>()
    var categories = List<CategoriModel>()
    var chapterList = List<ChapterModel>()
    @objc public dynamic var idManga = ""

    public override static func primaryKey() -> String? {
        return "idManga"
    }
    func initLoad(_ json:  [String: Any]) -> MangaInfoModel{
        if let temp = json["id"] as? Int {
            id = temp
            idManga = String(id)
        }
        if let temp = json["type"] as? String { type = temp }
        if let temp = json["title"] as? String { title = temp }
        if let temp = json["slug"] as? String { slug = temp }
        if let temp = json["status"] as? String { status = temp }
        if let temp = json["is_active"] as? Int { is_active = temp }
        if let temp = json["rank"] as? Int { rank = temp }
        if let temp = json["image"] as? String { image = temp }
        if let temp = json["chapter_count"] as? Int { chapter_count = temp }
        if let temp = json["description"] as? String { descriptionPro = temp }
        if let temp = json["release_at"] as? Int { release_at = temp }
        if let temp = json["created_at"] as? Int { created_at = temp }
        if let temp = json["updated_at"] as? Int { updated_at = temp }
//        if let temp = json["authors"] as? [String] { authors = temp }
//        if let temp = json["categories"] as? [String] { categories = temp }
        if let temp = json["authors"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:AuthorModel = AuthorModel()
                chapterItem = chapterItem.initLoad(item)
                authors.append(chapterItem)
            }
        }
        if let temp = json["categories"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:CategoriModel = CategoriModel()
                chapterItem = chapterItem.initLoad(item)
                categories.append(chapterItem)
            }
        }
        if let temp = json["chapters"] as? [[String : Any]] {
            for item in temp{
                var chapterItem:ChapterModel = ChapterModel()
                chapterItem = chapterItem.initLoad(item)
                chapterList.append(chapterItem)
            }
        }
        return self
    }
}
