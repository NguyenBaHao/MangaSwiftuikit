//
//  RegisterModel.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 01/02/2023.
//

import Foundation
import UIKit

struct RegisterModel : Encodable{
    var name: String
    var email: String
    var password: String
    mutating func initload(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
//struct ResponseModel: Codable {
//    let email, name: String
//    let avatar: String
//    let updatedAt, createdAt: String
//    let id: Int
//
//    enum CodingKeys: String, CodingKey {
//        case email, name, avatar
//        case updatedAt = "updated_at"
//        case createdAt = "created_at"
//        case id
//    }
//}
struct Verufyaccount : Encodable{
    var email: String
    mutating func initload(name: String, email: String, password: String) {
        self.email = email
    }
}
