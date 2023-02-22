//
//  LoginModel.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 01/02/2023.
//

import Foundation
import UIKit

struct LoginModel: Encodable{
    let email : String
    let password : String
}
//struct LoginResponseModel{
//    let name: String
//    let email: String
//}

class LoginResponseModel: NSObject {
    var code: Int = 0
    var email: String = ""
    var message: String = ""
    

    func initLoad(_ json:  [String: Any]) -> LoginResponseModel{
        if let temp = json["code"] as? Int { code = temp }
        print(json)
        if let temp = json["errors"] as? [String:Any ] {
            if let emailErr = temp["email"] as? String { email = emailErr }
        }
        if let temp = json["message"] as? String {
            message = temp
        }
        return self
    }
}
