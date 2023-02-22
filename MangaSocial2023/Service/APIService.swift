//
//  APIService.swift
//  MangaSocial2023
//
//  Created by tuyetvoi on 1/26/23.
//

import Foundation
import UIKit
import Alamofire

enum APIError: Error{
    case custom(message: String)
}

typealias ApiCompletion = (_ data: Any?, _ error: Error?) -> ()

typealias ApiParam = [String: Any]

typealias Handler = (Swift.Result<Any?, APIError>)-> Void
enum ApiMethod: String {
    case GET = "GET"
    case POST = "POST"
}
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            if value is String {
                let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            else {
                return "\(percentEscapedKey)=\(value)"
            }
        }
        return parameterArray.joined(separator: "&")
    }
}
class APIService:NSObject {
    static let shared: APIService = APIService()
    
    func requestSON(_ url: String,
                    param: ApiParam?,
                    method: ApiMethod,
                    loading: Bool,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
            if let paramString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(url)?\(paramString)")!)
            }
            else {
                request = URLRequest(url: URL(string:url)!)
            }
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            do {
                if let p = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                }
            } catch { }
        }
        
        request.timeoutInterval = 30
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                }
                
                if let resJson = self.convertToJson(data) {
                    completion(resJson, nil)
                }
                else if let resString = String(data: data, encoding: .utf8) {
                    completion(resString, error)
                }
                else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    private func convertToJson(_ byData: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: byData, options: [])
        } catch {
            //            self.debug("convert to json error: \(error)")
        }
        return nil
    }
    
    func GetMangaAll(closure: @escaping (_ response: [MangaItemModel]?, _ error: Error?) -> Void) {
        requestSON("https://api-dev-manga.tozi.vn/api/manga", param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listComicReturn:[MangaItemModel] = [MangaItemModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:MangaItemModel = MangaItemModel()
                            commicAdd = commicAdd.initLoad(item1)
                            listComicReturn.append(commicAdd)
                        }
                    }
                    closure(listComicReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
        
    }
    
    func GetDetailManga(idManga:String, closure: @escaping (_ response: MangaInfoModel?, _ error: Error?) -> Void) {
        requestSON("https://api-dev-manga.tozi.vn/api/manga/" + idManga, param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] { // MangaInfoModel
                if let dataOne = d["data"] as? [String : Any]{
                    var commicAdd:MangaInfoModel = MangaInfoModel()
                    commicAdd = commicAdd.initLoad(dataOne)
                    closure(commicAdd, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    func getMangaCategories( closure: @escaping (_ response: [CategoriesModel]?, _ error: Error?) -> Void){
        requestSON("https://api-dev-manga.tozi.vn/api/categories" , param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listComicReturn:[CategoriesModel] = [CategoriesModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:CategoriesModel = CategoriesModel()
                            commicAdd = commicAdd.initLoad(item1)
                            listComicReturn.append(commicAdd)
                        }
                    }
                    closure(listComicReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    
    
    func searchMangaText(searchKey:String, closure: @escaping (_ response: [MangaItemModel]?, _ error: Error?) -> Void) {
        requestSON("https://api-dev-manga.tozi.vn/api/manga?order_by=id&sort_direction=asc&search_text=" + searchKey, param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listComicReturn:[MangaItemModel] = [MangaItemModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:MangaItemModel = MangaItemModel()
                            commicAdd = commicAdd.initLoad(item1)
                            listComicReturn.append(commicAdd)
                        }
                    }
                    closure(listComicReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    
    func get3MangaItemList(idCategories:String, closure: @escaping (_ response: [MangaItemModel]?, _ error: Error?) -> Void){
        requestSON("https://api-dev-manga.tozi.vn/api/manga?category_id=" +  idCategories + "&page_size=3", param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listComicReturn:[MangaItemModel] = [MangaItemModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:MangaItemModel = MangaItemModel()
                            commicAdd = commicAdd.initLoad(item1)
                            listComicReturn.append(commicAdd)
                        }
                    }
                    closure(listComicReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    
    func getMangaCategoriItemList(idCategories:String, closure: @escaping (_ response: [MangaItemModel]?, _ error: Error?) -> Void){
        requestSON("https://api-dev-manga.tozi.vn/api/manga?category_id=" +  idCategories, param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listComicReturn:[MangaItemModel] = [MangaItemModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:MangaItemModel = MangaItemModel()
                            commicAdd = commicAdd.initLoad(item1)
                            listComicReturn.append(commicAdd)
                        }
                    }
                    closure(listComicReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    func PostRegister(register: RegisterModel,  completionHandler: @escaping (_ response: LoginResponseModel, _ error: Error?) -> Void){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    var trave: LoginResponseModel = LoginResponseModel()
                    trave = trave.initLoad(json as! [String : Any])
                    completionHandler(trave,nil)
                }catch{
                    print(error.localizedDescription)
                    var trave: LoginResponseModel = LoginResponseModel()
                    completionHandler(trave,nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                var trave: LoginResponseModel = LoginResponseModel()
                completionHandler(trave,nil)
            }
        }
    }
    func PostLoginAPI(login:LoginModel, completionHandler: @escaping (_ response: LoginResponseModel, _ error: Error?) -> Void){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    var trave: LoginResponseModel = LoginResponseModel()
                    trave = trave.initLoad(json as! [String : Any])
                    completionHandler(trave,nil)
                }catch{
                    print(error.localizedDescription)
                    var trave: LoginResponseModel = LoginResponseModel()
                    completionHandler(trave,nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                var trave: LoginResponseModel = LoginResponseModel()
                completionHandler(trave,nil)
            }
        }
    }
    
    func PostVerufyaccount(verufyaccount: Verufyaccount, completionHandler: @escaping Handler ){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(Verufyaccount_url, method: .post, parameters: verufyaccount, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200{
                        completionHandler(.success(json))
                    }else{
                        completionHandler(.failure(.custom(message: "Please check your netword connectivity")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try again")))
            }
        }
    }
    
//    func PostLogout(completionHandler: @escaping Handler ){
//        let headers: HTTPHeaders = [
//            .contentType("application/json")
//        ]
//        AF.request(logout_url, method: .post, parameters: "", encoder: JSONParameterEncoder.default, headers: headers).response{ response in
//            debugPrint(response)
//            switch response.result{
//            case .success(let data):
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                    if response.response?.statusCode == 200{
//                        completionHandler(.success(json))
//                    }else{
//                        completionHandler(.failure(.custom(message: "Please check your netword connectivity")))
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                    completionHandler(.failure(.custom(message: "Please try again")))
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                completionHandler(.failure(.custom(message: "Please try again")))
//            }
//        }
//    }
    
    func GetProfileuser(closure: @escaping (_ response: [ProfileUserModel]?, _ error: Error?) -> Void) {
        requestSON("https://api-dev-manga.tozi.vn/api/info", param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                var listinfoReturn:[ProfileUserModel] = [ProfileUserModel]()
                if let dataOne = d["data"] as? [String : Any]{
                    if let dataList = dataOne["data"] as? [[String : Any]] {
                        for item1 in dataList{
                            var InfoAdd:ProfileUserModel = ProfileUserModel()
                            InfoAdd = InfoAdd.initLoad(item1)
                            listinfoReturn.append(InfoAdd)
                        }
                    }
                    closure(listinfoReturn, nil)
                }
                else {
                    closure(nil,nil)
                }
            }
        }
    }
    func PutUpdateNameUser(updatename: UpdateNameModel, completionHandler: @escaping (Bool, String) -> ()){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(UpdateName_url, method: .put, parameters: updatename, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200{
                        completionHandler(true, "Username updated successfully")
                    }else{
                        completionHandler(false, "Please try again")
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(false, "Please try again")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "Please try again")
            }
        }
    }

    func PutChangePassword(changePassword: ChangePasswordModel, completionHandler: @escaping (Bool, String) -> ()){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(UpdateName_url, method: .put, parameters: changePassword, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200{
                        completionHandler(true, "Password has been updated successfully")
                    }else{
                        completionHandler(false, "Please try again")
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(false, "Please try again")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "Please try again")
            }
        }
    }
    
    func loadAllImageInChapter(chapterIn:ChapterModel, closure: @escaping (_ response: ChapterModel?, _ error: Error?) -> Void){
        requestSON("https://api-dev-manga.tozi.vn/api/manga/" + String(chapterIn.manga_id) + "/" + "chapter/" + String(chapterIn.idChapter ) , param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                if let dataItem = d["data"] as? [String : Any] {
                    if let dataList = dataItem["thumbnails"] as? [[String : Any]] {
                        for item1 in dataList{
                            var commicAdd:ImageModel = ImageModel()
                            commicAdd = commicAdd.initLoad(item1)
                            chapterIn.listImage.append(commicAdd)
                        }
                    }
                }
                
                closure(chapterIn, nil)
            }
        }
    }
    //_______SONPIPI______
    func getHomeMangaReload( closure: @escaping (_ response: HomeMangaModel?, _ error: Error?) -> Void){
        requestSON("https://api-dev-manga.tozi.vn/api/home?page_size=36" , param: nil, method: .GET, loading: true) { (data, error) in
            if let d = data as? [String: Any] {
                if let dataReturn = d["data"] as? [String : Any] {
                    var returnHome:HomeMangaModel = HomeMangaModel()
                    returnHome = returnHome.initLoad(dataReturn)
                    closure(returnHome, nil)
                }
            }
            else {
                closure(nil,nil)
            }
        }
    }
}
