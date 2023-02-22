//
//  Authentication.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 01/02/2023.
//

import Foundation
import UIKit

struct updateName : Encodable{
    var Name: String
    mutating func initload(Name: String) {
        self.Name = Name
    }
}
