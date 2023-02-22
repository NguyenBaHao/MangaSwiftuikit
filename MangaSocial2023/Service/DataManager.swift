//
//  DataManager.swift
//  ServiceManager
//
//  Created by mac on 12/07/2022.
//

import UIKit
import RealmSwift

open class DataManager: NSObject {
    
    public var realm: Realm!
    public static let instance = DataManager()
    
    override init() {
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.schemaVersion = 0
        realmConfig.migrationBlock = {
            mig , oldver in
        }
        realm = try! Realm(configuration: realmConfig)
    }
    
    func listFavoriteMangas() -> [MangaInfoModel]{
        let results = realm.objects(MangaInfoModel.self).filter("isFavorite == true").sorted(byKeyPath: "historyDate", ascending: false)
        return Array(results)
    }
    
    func listHistoryMangas() -> [MangaInfoModel]{
        let results = realm.objects(MangaInfoModel.self).filter("isHistory == true").sorted(byKeyPath: "historyDate", ascending: false)
        return Array(results)
    }
    
    func listCachedMangas() -> [MangaInfoModel]{
        let results = realm.objects(MangaInfoModel.self).filter("isCached == true").sorted(byKeyPath: "historyDate", ascending: false)
        return Array(results)
    }
    
    func listLibraryMangas() -> [MangaInfoModel]{
        let results = realm.objects(MangaInfoModel.self).filter("isLibrary == true").sorted(byKeyPath: "historyDate", ascending: false)
        return Array(results)
    }
    
    func mangaById(_ mangaId: String) -> MangaInfoModel?{
        return realm.object(ofType: MangaInfoModel.self, forPrimaryKey: mangaId)
    }
    
    func chapterById(_ chapterId: String) -> ChapterModel?{
        return realm.object(ofType: ChapterModel.self, forPrimaryKey: chapterId)
    }
    
    public func deleteObject(_ object: Object){
        try! realm.write({
            realm.delete(object)
        })
    }
        
    public func deleteObjects(_ objects: [Object]){
        try! realm.write({
            realm.delete(objects)
        })
    }
    
    @discardableResult
    public func insertObject(_ object: Object) -> Object{
        try! realm.write({
            realm.add(object, update: .all)
        })
        return object
    }
}
