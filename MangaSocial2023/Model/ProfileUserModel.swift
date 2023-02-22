//
//  Prodileuser.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 06/02/2023.
//

import Foundation
class ProfileUserModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var avatar: String = ""
    

    func initLoad(_ json:  [String: Any]) -> ProfileUserModel{
        if let temp = json["id"] as? Int { id = temp }
        if let temp = json["name"] as? String { name = temp }
        if let temp = json["email"] as? String { email = temp }
        if let temp = json["avatar"] as? String { avatar = temp }


        return self
    }
}



struct UpdateNameModel : Encodable{
    var name: String
    mutating func initload(name: String, email: String, password: String) {
        self.name = name
    }
}


struct ChangePasswordModel : Encodable{
    var old_password: String
    var password: String
    mutating func initload(old_password: String, password: String) {
        self.old_password = old_password
        self.password = password
    }
}
