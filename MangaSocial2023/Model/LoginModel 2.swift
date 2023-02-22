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
struct LoginResponseModel{
    let name: String
    let email: String
}
