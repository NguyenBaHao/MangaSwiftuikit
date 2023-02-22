//
//  MangaItemModel.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/26/23.
//

import Foundation
import UIKit

class MangaItemModel: NSObject {
    var id: Int = 0
    var type: String = ""
    var title: String = ""
    var slug: String = ""
    var status: String = ""
    var is_active: Int = 0
    var image: String = ""
    var chapter_count: Int = 0
    var rank: Int = 0
    var descriptionPro: String = ""
    var release_at: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
    var authors: [String] = []
    var categories: [String] = []

    func initLoad(_ json:  [String: Any]) -> MangaItemModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["type"] as? String { type = temp }
        if let temp = json["title"] as? String { title = temp }
        if let temp = json["slug"] as? String { slug = temp }
        if let temp = json["status"] as? String { status = temp }
        if let temp = json["is_active"] as? Int { is_active = temp }
        if let temp = json["image"] as? String { image = temp }
        if let temp = json["chapter_count"] as? Int { chapter_count = temp }
        if let temp = json["description"] as? String { descriptionPro = temp }
        if let temp = json["release_at"] as? String { release_at = temp }
        if let temp = json["created_at"] as? Int { created_at = temp }
        if let temp = json["updated_at"] as? Int { updated_at = temp }
        if let temp = json["authors"] as? [String] { authors = temp }
        if let temp = json["categories"] as? [String] { categories = temp }

        return self
    }
}
